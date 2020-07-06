`ifndef MAC_TRANSACTION__SV
`define MAC_TRANSACTION__SV

class mac_transaction extends uvm_sequence_item;

   rand bit [ 3: 0] mode;
   rand bit [15: 0] value, weight;
   rand bit [23: 0] ints;
   rand bit [30: 0] fps;

   rand bit [23: 0] intr;
   rand bit [30: 0] fpr;

   `uvm_object_utils_begin(mac_transaction)
      `uvm_field_int(mode, UVM_ALL_ON)
      `uvm_field_int(value, UVM_ALL_ON)
      `uvm_field_int(weight, UVM_ALL_ON)
      `uvm_field_int(ints, UVM_ALL_ON)
      `uvm_field_int(fps, UVM_ALL_ON)
      `uvm_field_int(intr, UVM_ALL_ON)
      `uvm_field_int(fpr, UVM_ALL_ON)
   `uvm_object_utils_end

   function new(string name = "mac_transaction");
      super.new();
   endfunction

endclass
`endif
