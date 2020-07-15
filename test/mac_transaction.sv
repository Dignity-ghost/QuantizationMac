`ifndef MAC_TRANSACTION__SV
`define MAC_TRANSACTION__SV

class mac_transaction extends uvm_sequence_item;

   rand bit         mode;
   rand bit [15: 0] value, weight;
   rand bit [27: 0] ints;
   rand bit [17: 0] fps;

   rand bit [27: 0] intr;
   rand bit [17: 0] fpr;

   // constraint one_hot {
   //    $countones(mode) == 1;
   // }

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
