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

   // int input signed expansion
   bit signed [8 : 0] int_weight = {tr_i.weight[7], tr_i.weight[7: 0]};
   bit signed [8 : 0] int_value  = {1'b0, tr_i.value[7: 0]};
   bit signed [17: 0] int_intr;

   // fp input signed expansion of mantissa, All zeros means 0, no expansion
   bit signed [12: 0] weight_man = (tr_i.weight == 'b0) ? 13'b0 : {tr_i.weight[15], ~tr_i.weight[15], tr_i.weight[10: 0]};
   bit signed [12: 0] value_man  = (tr_i.value  == 'b0) ? 13'b0 : {2'h1, tr_i.value[10: 0]};
   bit signed [12: 0] fps_man    = tr_i.fps[12:  0];

   // fp input signed expansion of exponent
   bit unsigned [ 3: 0] weight_exp = tr_i.weight[14: 11];
   bit unsigned [ 4: 0] value_exp  = tr_i.value[15: 11]; 
   bit unsigned [ 4: 0] fps_exp    = tr_i.fps[17: 13];

   // mantissa of tmp multiplication and cut the precision
   bit signed [24: 0] mul_man_full = weight_man * value_man;
   bit signed [13: 0] mul_man      = mul_man_full[24: 11];

   // exponent of tmp multiplication
   bit unsigned [ 5: 0] mul_exp = value_exp + weight_exp - 5'hc;

   // add the mantissa of bias and multiplication
   bit signed [ 5: 0] shift         = mul_exp - fps_exp;
   bit signed [13: 0] norm_mul_man  = mul_man >>> (  shift[5] ? -shift : 0);
   bit signed [12: 0] norm_fps_man  = fps_man >>> ( ~shift[5] ?  shift : 0);
   bit signed [13: 0] norm_man      = norm_mul_man + {norm_fps_man[12], norm_fps_man} ;
   
   // preclaration of the final variable
   bit signed   [12: 0] fpr_m;
   bit unsigned [4: 0]  fpr_e;

   // find index of the first valid bit 
   bit signed [ 4: 0] fpr_shift = 0;
   bit        [12: 0] tmp_xor   = {13{norm_man[13]}} ^ norm_man[12: 0];
   if      (tmp_xor[12]) begin fpr_shift = -5'd1;  end
   else if (tmp_xor[11]) begin fpr_shift =  5'd0;  end
   else if (tmp_xor[10]) begin fpr_shift =  5'd1;  end
   else if (tmp_xor[9])  begin fpr_shift =  5'd2;  end
   else if (tmp_xor[8])  begin fpr_shift =  5'd3;  end
   else if (tmp_xor[7])  begin fpr_shift =  5'd4;  end
   else if (tmp_xor[6])  begin fpr_shift =  5'd5;  end
   else if (tmp_xor[5])  begin fpr_shift =  5'd6;  end
   else if (tmp_xor[4])  begin fpr_shift =  5'd7;  end
   else if (tmp_xor[3])  begin fpr_shift =  5'd8;  end
   else if (tmp_xor[2])  begin fpr_shift =  5'd9;  end
   else if (tmp_xor[1])  begin fpr_shift =  5'd10; end
   else if (tmp_xor[0])  begin fpr_shift =  5'd11; end
   
   // normalization
   fpr_m = &fpr_shift ? norm_man[13: 1] : norm_man << fpr_shift;
   fpr_e = (~shift[5] ? mul_exp : fps_exp) - fpr_shift;

   // Copy the data of input of dut
   tr_o.copy(tr_i);

   //write the final output
   if (tr_i.mode == 'b1) begin //fp16
      tr_o.fpr =  {fpr_e, fpr_m};
   end else begin // int
      int_intr = int_value * int_weight;
   end

   // add the int bias to the mul of int
   tr_o.intr = {{10{int_intr[17]}}, int_intr[17: 0]} + tr_i.ints;

endfunction
`endif
