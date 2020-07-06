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
      `uvm_info("mac_model", "get one transaction, calculated!", UVM_LOW);
      ap.write(new_tr);
   end
endtask

task mac_model::mac(mac_transaction tr_i, mac_transaction tr_o);

   bit signed [12: 0] mul_weight = (tr_i.weight == 'b0) ? 13'b0 : {tr_i.weight[15], ~tr_i.weight[15], tr_i.weight[10: 0]};
   bit unsigned [12: 0] mul_value = (tr_i.value == 'b0) ? 13'b0 : {1'b1, tr_i.value[11: 0]};

   bit signed [25: 0] mul_result = mul_value * mul_weight;

   bit signed [ 3: 0] exp_weight = tr_i.weight[14: 11];
   bit signed [ 3: 0] exp_value = tr_i.weight[15: 12]; 
   bit signed [ 4: 0] exp_mul_result = exp_value + exp_weight - 5'h0c;
   bit signed [ 4: 0] fps_exp = tr_i.fps[30: 26];
   bit signed [25: 0] fps_man = tr_i.fps[25: 0];

   bit signed [ 4: 0] shift = exp_mul_result - fps_exp;
   bit mul_lt_fps = ~shift[4];
   bit signed [25: 0] acc_mul = mul_result >>> (~mul_lt_fps ? -shift : 0);
   bit signed [25: 0] acc_fps = fps_man >>> ( mul_lt_fps ?  shift : 0);
   bit signed [25: 0] acc_fp_m = acc_mul + acc_fps;

   bit signed   [25: 0] fpr_m;
   bit unsigned [4: 0]  fpr_e;

   bit signed [ 4: 0] fpr_m_norm_shift = 0;
   for(int i = 0; i < 25; i++) begin
      if(acc_fp_m[i] ^ acc_fp_m[25]) begin
         fpr_m_norm_shift = 5'd24 - i;
      end
   end

   fpr_m = acc_fp_m << fpr_m_norm_shift;
   fpr_e = (mul_lt_fps ? exp_mul_result : fps_exp) - fpr_m_norm_shift;

      tr_o.copy(tr_i);
   if (tr_i.mode == 4'b0001) begin //fp
      tr_o.fpr =  {fpr_e, fpr_m};
   end else if (tr_i.mode == 4'b0010) begin // int * 1 
      tr_o.intr = tr_i.value * tr_i.weight * 1 + tr_i.ints;
   end else if (tr_i.mode == 4'b0100) begin // int * 4 
      tr_o.intr = tr_i.value * tr_i.weight * 4 + tr_i.ints;
   end else if (tr_i.mode == 4'b1000) begin // int * 16
      tr_o.intr = tr_i.value * tr_i.weight * 16 + tr_i.ints;
   end else begin
      tr_o.fpr = 'b0;
      tr_o.intr = 'b0;
   end

endtask
`endif
