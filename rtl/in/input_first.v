module input_first(
    clk, rst, en,
    indata, type_sel, n,
    out_sign, out_exp, out_mantissa,
    out_zero_flag
);



parameter   width_in = 16;
parameter   width_in_exp = 5;
parameter   width_in_mantissa = width_in - width_in_exp - 1;

parameter   width_out = 16;
parameter   width_out_exp = 5;
parameter   width_out_mantissa = width_in - width_out_exp - 1;



input                               clk, rst, en;

input   [           width_in-1: 0]  indata;
input                               type_sel;
input   [       width_in_exp-1: 0]  n;

output                                  out_sign;
output reg  [      width_out_exp-1: 0]  out_exp;
output reg  [ width_out_mantissa-1: 0]  out_mantissa;

output                                  out_zero_flag;



reg                                 in_sign;
reg     [       width_in_exp-1: 0]  in_exp;
reg     [  width_in_mantissa-1: 0]  in_mantissa;

always @( posedge clk or negedge rst ) begin
    if (~rst) begin
        in_sign     =   'd0;
        in_exp      =   'd0;
        in_mantissa =   'd0;
    end else if ( en ) begin
        in_sign     =   indata[width_in-1];
        in_exp      =   indata[width_in-2:width_in-width_in_exp-1];
        in_mantissa =   indata[width_in-width_in_exp-2:0];
    end
end



reg     [2:0]  int_zero_num;

assign  out_sign        =   in_sign;
assign  out_zero_flag   =   &int_zero_num;

always @* begin
out_exp = 'd0;
if (type_sel) begin
    out_exp[width_out_exp - 1 : width_out_exp - width_in_exp] = in_exp;
end else begin
    if (n > int_zero_num) begin
        out_exp[width_out_exp - 1 : width_out_exp - width_in_exp] = n - int_zero_num;
    end
end
end

always @* begin
out_mantissa = 'd0;
if (type_sel) begin
        out_mantissa[ width_out_mantissa - 1 : width_out_mantissa - width_in_mantissa] = n - in_mantissa;
end else begin
    if ((n >= int_zero_num)) begin
        case (int_zero_num)
        3'h0: begin out_mantissa[width_out_mantissa-1:width_out_mantissa-6] = in_mantissa[5:0]; end
        3'h1: begin out_mantissa[width_out_mantissa-1:width_out_mantissa-5] = in_mantissa[4:0]; end
        3'h2: begin out_mantissa[width_out_mantissa-1:width_out_mantissa-4] = in_mantissa[3:0]; end
        3'h3: begin out_mantissa[width_out_mantissa-1:width_out_mantissa-3] = in_mantissa[2:0]; end        
        3'h4: begin out_mantissa[width_out_mantissa-1:width_out_mantissa-2] = in_mantissa[1:0]; end
        3'h5: begin out_mantissa[                     width_out_mantissa-1] = in_mantissa[  0]; end
        default: begin end
        endcase
    end
end
end

always @* begin
if (type_sel) begin int_zero_num = 3'h0; end
else begin
    casez (in_mantissa[6:0])
    7'b1??????: begin int_zero_num = 3'h0; end
    7'b01?????: begin int_zero_num = 3'h1; end
    7'b001????: begin int_zero_num = 3'h2; end
    7'b0001???: begin int_zero_num = 3'h3; end
    7'b00001??: begin int_zero_num = 3'h4; end
    7'b000001?: begin int_zero_num = 3'h5; end
    7'b0000001: begin int_zero_num = 3'h6; end
    default: begin int_zero_num = 3'h7; end
    endcase
end
end


















endmodule 