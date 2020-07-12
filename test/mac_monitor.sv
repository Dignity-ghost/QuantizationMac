`ifndef MAC_MONITOR__SV
`define MAC_MONITOR__SV
class mac_monitor extends uvm_monitor;

   virtual mac_if vif;

   uvm_analysis_port #(mac_transaction)  ap;
   
   `uvm_component_utils(mac_monitor)
   function new(string name = "mac_monitor", uvm_component parent = null);
      super.new(name, parent);
   endfunction

   virtual function void build_phase(uvm_phase phase);
      super.build_phase(phase);
      if(!uvm_config_db#(virtual mac_if)::get(this, "", "vif", vif))
         `uvm_fatal("mac_monitor", "virtual interface must be set for vif!!!")
      ap = new("ap", this);
   endfunction

   extern task main_phase(uvm_phase phase);
   extern task collect_one_pkt(mac_transaction tr);
endclass

task mac_monitor::main_phase(uvm_phase phase);
   mac_transaction tr;
   while(1) begin
      tr = new("tr");
      collect_one_pkt(tr);
      ap.write(tr);
   end
endtask

task mac_monitor::collect_one_pkt(mac_transaction tr);
   while(1) begin
        repeat (3) @(posedge vif.clk);
        if(vif.fps != 'b0 && vif.rst_n) break;
        if(vif.fpr != 'b0 && vif.rst_n) break;
        if(vif.intr != 'b0 && vif.rst_n) break;
   end
   
   `uvm_info("mac_monitor", "begin to collect one pkt", UVM_LOW);
   
   tr.mode = vif.mode;
   tr.value = vif.value;
   tr.weight = vif.weight;
   tr.ints = vif.ints;
   tr.fps = vif.fps;

   tr.fpr = vif.fpr;
   tr.intr = vif.intr;

   `uvm_info("mac_monitor", "end collect one pkt", UVM_LOW);
endtask


`endif
