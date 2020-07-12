`ifndef MAC_DRIVER__SV
`define MAC_DRIVER__SV
class mac_driver extends uvm_driver#(mac_transaction);

   virtual mac_if vif;

   `uvm_component_utils(mac_driver)
   function new(string name = "mac_driver", uvm_component parent = null);
      super.new(name, parent);
   endfunction

   virtual function void build_phase(uvm_phase phase);
      super.build_phase(phase);
      if(!uvm_config_db#(virtual mac_if)::get(this, "", "vif", vif))
         `uvm_fatal("mac_driver", "virtual interface must be set for vif!!!")
   endfunction

   extern task main_phase(uvm_phase phase);
   extern task drive_one_pkt(mac_transaction tr);
endclass

task mac_driver::main_phase(uvm_phase phase);

   vif.mode <= 2'b0;
   vif.value <= 16'b0;
   vif.weight <= 16'b0;
   vif.ints <= 23'b0;
   vif.fps <= 31'b0;

   while(!vif.rst_n)
      @(posedge vif.clk);
   while(1) begin
      seq_item_port.get_next_item(req);
      drive_one_pkt(req);
      seq_item_port.item_done();
   end
endtask

task mac_driver::drive_one_pkt(mac_transaction tr);
   
   `uvm_info("mac_driver", "begin to drive one pkt", UVM_LOW);

   repeat (3) @(posedge vif.clk);
   # 10;
   vif.mode <= tr.mode;
   vif.value <= tr.value;
   vif.weight <= tr.weight;
   vif.ints <= tr.ints;
   vif.fps <= tr.fps;

   `uvm_info("mac_driver", "end drive one pkt", UVM_LOW);
endtask


`endif
