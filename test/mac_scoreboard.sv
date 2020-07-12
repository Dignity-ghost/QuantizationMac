`ifndef MAC_SCOREBOARD__SV
`define MAC_SCOREBOARD__SV
class mac_scoreboard extends uvm_scoreboard;
   mac_transaction  actual_queue[$];
   uvm_blocking_get_port #(mac_transaction)  exp_port;
   uvm_blocking_get_port #(mac_transaction)  act_port;
   `uvm_component_utils(mac_scoreboard)

   extern function new(string name, uvm_component parent = null);
   extern virtual function void build_phase(uvm_phase phase);
   extern virtual task main_phase(uvm_phase phase);
endclass 

function mac_scoreboard::new(string name, uvm_component parent = null);
   super.new(name, parent);
endfunction 

function void mac_scoreboard::build_phase(uvm_phase phase);
   super.build_phase(phase);
   exp_port = new("exp_port", this);
   act_port = new("act_port", this);
endfunction 

task mac_scoreboard::main_phase(uvm_phase phase);
   mac_transaction  get_expect,  get_actual, tmp_tran;
   bit result, result_int, result_fp;
 
   super.main_phase(phase);
   fork 
      while (1) begin
         act_port.get(get_actual);
         actual_queue.push_back(get_actual);
      end
      while (1) begin
         exp_port.get(get_expect);
         if(actual_queue.size() > 0) begin
            tmp_tran = actual_queue.pop_front();
            result_int = get_expect.intr == tmp_tran.intr;
            result_fp = get_expect.fpr == tmp_tran.fpr;
            result = (get_expect.mode == 'b0001) ? result_fp : result_int;
            if(result) begin 
               `uvm_info("mac_scoreboard", "Compare SUCCESSFULLY", UVM_LOW);
            end
            else begin
               `uvm_error("mac_scoreboard", "Compare FAILED");
               $display("the expect pkt is");
               get_expect.print();
               $display("the actual pkt is");
               tmp_tran.print();
            end
         end
         else begin
            `uvm_error("mac_scoreboard", "Received from DUT, while Expect Queue is empty");
            $display("the unexpected pkt is");
            get_expect.print();
         end 
      end
   join
endtask
`endif
