module acc_int(
    clk, rst_n,
    r_mul, ops_2,
    result
);





input               clk, rst_n;
input   [ 8: 0]     r_mul;
input   [ 7: 0]     ops_2;

output reg [ 7: 0]     result;


wire                lt        = r_mul[7:1] < ops_2[6:0];
wire                sgn_xor   = r_mul[8] ^ ops_2[7];
wire    [ 6: 0]     ops_2_inv = ~ops_2[6:0];
wire    [ 6: 0]     r_mul_inv = ~r_mul[7:1];
wire                c_in      = ~sgn_xor ? r_mul[0] :
                                lt ? ~r_mul[0] :
                                1'b1;
wire    [ 6: 0]     add_a = ( sgn_xor &  lt ) ? r_mul_inv : r_mul[7:1];
wire    [ 6: 0]     add_b = ( sgn_xor & ~lt ) ? ops_2_inv : ops_2[6:0];




always @(posedge clk or negedge rst_n) begin
if (~rst_n) begin
    result <= 8'h0;
end else begin
    result[7]   <= lt ? ops_2[7] : r_mul[8];
    result[6:0] <= add_a + add_b + c_in;
end
end



endmodule