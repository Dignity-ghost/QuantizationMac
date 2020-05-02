module tb_input_first();

reg clk, rst, en;
reg type_sel;
reg [ 4:0]   n;
reg [15:0]  indata;

input_first input_first(
    .clk(clk),
    .rst(rst),
    .en(en),
    .type_sel(type_sel),
    .n(n),
    .indata(indata),
    .out_sign(), 
    .out_exp(), 
    .out_mantissa(), 
    .out_zero_flag()
);

initial begin
    clk = 1'b1;
    rst = 1'b0;
    en  = 1'b1;
    n   = 5'hf;
    type_sel  = 1'b0;
    indata = 16'h002c;
    #2
    rst = 1'b1;



end

always #1 clk = ~clk;



endmodule