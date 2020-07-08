`ifndef MAC_MODEL__SV
`define MAC_MODEL__SV

class mac_model extends uvm_component;
   
   uvm_blocking_get_port #(mac_transaction)  port;
   uvm_analysis_port #(mac_transaction)  ap;

   extern function new(string name, uvm_component parent);
   extern function void build_phase(uvm_phase phase);
   extern virtual  task main_phase(uvm_phase phase);
   extern function mac(mac_transaction tr_i, mac_transaction tr_o);

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

function mac_model::mac(mac_transaction tr_i, mac_transaction tr_o);

   bit signed [12: 0] mul_weight = (tr_i.weight == 'b0) ? 13'b0 : {tr_i.weight[15], ~tr_i.weight[15], tr_i.weight[10: 0]};
   bit signed [13: 0] mul_value = (tr_i.value == 'b0) ? 14'b0 : {2'h1, tr_i.value[11: 0]};

   bit signed [25: 0] mul_result = mul_value * mul_weight;
   bit signed [13: 0] mul_result_fp = mul_result[25: 12];


   bit signed [ 3: 0] exp_weight = tr_i.weight[14: 11];
   bit signed [ 3: 0] exp_value = tr_i.value[15: 12]; 
   bit signed [ 4: 0] exp_mul_result = exp_value + exp_weight;
   bit signed [ 4: 0] fps_exp = tr_i.fps[17: 13];
   bit signed [12: 0] fps_man = tr_i.fps[12:  0];

   bit signed [ 4: 0] shift = exp_mul_result - fps_exp;
   bit                mul_lt_fps = ~shift[4];
   bit signed [13: 0] acc_mul = mul_result_fp >>> (~mul_lt_fps ? -shift : 0);
   bit signed [12: 0] acc_fps = fps_man       >>> ( mul_lt_fps ?  shift : 0);
   bit signed [13: 0] acc_fp_m = acc_mul + {acc_fps[12], acc_fps} ;

   bit signed   [12: 0] fpr_m;
   bit unsigned [4: 0]  fpr_e;

   bit signed [25: 0] tmp_intr;
   bit signed [12: 0] tmp_weight;
   bit signed [13: 0] tmp_value;

   bit signed [ 3: 0] fpr_m_norm_shift = 0;
   for(int i = 0; i < 13; i++) begin
      if(acc_fp_m[i] ^ acc_fp_m[13]) begin
         fpr_m_norm_shift = 4'd11 - i;
      end
   end

   fpr_m = &fpr_m_norm_shift ? acc_fp_m[13: 1] : acc_fp_m << fpr_m_norm_shift;
   fpr_e = (mul_lt_fps ? exp_mul_result : fps_exp) - fpr_m_norm_shift;

      tr_o.copy(tr_i);
   if (tr_i.mode == 4'b0001) begin //fp
      tr_o.fpr =  {fpr_e, fpr_m};
   end else if (tr_i.mode == 4'b0010) begin // int * 1
      tmp_value = {3'b0, tr_i.value[7: 0], 3'b0};
      tmp_weight = {{2{tr_i.weight[7]}}, tr_i.weight[7: 0], 3'b0};
      tmp_intr = tmp_value * tmp_weight;
   end else if (tr_i.mode == 4'b0100) begin // int * 4 
      tmp_value = {3'b0, tr_i.value[7: 0], 3'b0};
      tmp_weight = {tr_i.weight[7: 0], 5'b0};
      tmp_intr = tmp_value * tmp_weight;
   end else if (tr_i.mode == 4'b1000) begin // int * 16
      tmp_value = {1'b0, tr_i.value[7: 0], 5'b0};
      tmp_weight = {tr_i.weight[7: 0], 5'b0};
      tmp_intr = tmp_value * tmp_weight;
   end else begin
      tr_o.fpr = 'b0;
      tr_o.intr = 'b0;
   end

   tr_o.intr = {{6{tmp_intr[23]}}, tmp_intr[23: 6]} + tr_i.ints;

endfunction
`endif
