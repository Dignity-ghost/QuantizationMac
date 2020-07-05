`ifndef MAC_SEQUENCE__SV
`define MAC_SEQUENCE__SV

class mac_sequence extends uvm_sequence #(mac_transaction);
   mac_transaction m_trans;

   int simu_times;

   function new(string name= "mac_sequence");
      super.new(name);
   endfunction

   virtual task body();

      if(!uvm_config_db#(int)::get(this, "", "simu_times", simu_times))
         `uvm_fatal("mac_sequence", "simulation times must be set for sequence!!!")

      if(starting_phase != null) 
         starting_phase.raise_objection(this);
      repeat (simu_times) begin
         `uvm_do(m_trans)
      end
      #1000;
      if(starting_phase != null) 
         starting_phase.drop_objection(this);
   endtask

   `uvm_object_utils(mac_sequence)
endclass
`endif
