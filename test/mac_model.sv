`ifndef MAC_MODEL__SV
`define MAC_MODEL__SV

class mac_model extends uvm_component;
   
   uvm_blocking_get_port #(mac_transaction)  port;
   uvm_analysis_port #(mac_transaction)  ap;

   extern function new(string name, uvm_component parent);
   extern function void build_phase(uvm_phase phase);
   extern virtual  task main_phase(uvm_phase phase);
   extern task mac(mac_transaction tr_i, mac_transaction tr_o);

   `uvm_component_utils(mac_model)
endclass 

function mac_model::new(string name, uvm_component parent);
   super.new(name, parent);
endfunction 

function void mac_model::build_phase(uvm_phase phase);
   super.build_phase(phase);
   port = new("port", this);
   ap = new("ap", this);
endfunction

task mac_model::main_phase(uvm_phase phase);
   mac_transaction tr;
   mac_transaction new_tr;
   super.main_phase(phase);
   while(1) begin
      port.get(tr);
      new_tr = new("new_tr");
      mac(tr, new_tr);
      `uvm_info("mac_model", "get one transaction, copy and print it:", UVM_LOW);
      new_tr.print();
      ap.write(new_tr);
   end
endtask

task mac_model::mac(mac_transaction tr_i, mac_transaction tr_o);

   tr_o.copy(tr_i);

endtask
`endif
