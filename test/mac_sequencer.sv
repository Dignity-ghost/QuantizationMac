`ifndef MAC_SEQUENCER__SV
`define MAC_SEQUENCER__SV

class mac_sequencer extends uvm_sequencer #(mac_transaction);
   
   function new(string name, uvm_component parent);
      super.new(name, parent);
   endfunction 
   
   `uvm_component_utils(mac_sequencer)
endclass

`endif
