`ifndef MAC_AGENT__SV
`define MAC_AGENT__SV

class mac_agent extends uvm_agent ;
   mac_sequencer  sqr;
   mac_driver     drv;
   mac_monitor    mon;
   
   uvm_analysis_port #(mac_transaction)  ap;
   
   function new(string name, uvm_component parent);
      super.new(name, parent);
   endfunction 
   
   extern virtual function void build_phase(uvm_phase phase);
   extern virtual function void connect_phase(uvm_phase phase);

   `uvm_component_utils(mac_agent)
endclass 


function void mac_agent::build_phase(uvm_phase phase);
   super.build_phase(phase);
   if (is_active == UVM_ACTIVE) begin
      sqr = mac_sequencer::type_id::create("sqr", this);
      drv = mac_driver::type_id::create("drv", this);
   end
   mon = mac_monitor::type_id::create("mon", this);
endfunction 

function void mac_agent::connect_phase(uvm_phase phase);
   super.connect_phase(phase);
   if (is_active == UVM_ACTIVE) begin
      drv.seq_item_port.connect(sqr.seq_item_export);
   end
   ap = mon.ap;
endfunction

`endif

