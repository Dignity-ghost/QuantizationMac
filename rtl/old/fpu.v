module fpu(
    op1, op2, ops, result
);

input   [ 15 : 0 ]  op1, op2, ops;
output  [ 15 : 0 ]  result;

wire                mul_op1_s   =   op1[15];
wire                mul_op2_s   =   op2[15];
wire                acc_ops_s   =   ops[15];
wire    [  4 : 0 ]  mul_op1_e   =   op1[14:10];
wire    [  4 : 0 ]  mul_op2_e   =   op2[14:10];
wire    [  4 : 0 ]  acc_ops_e   =   ops[14:10];
wire    [ 10 : 0 ]  mul_op1_m   =   { 1'b1, op1[9:0] };
wire    [ 10 : 0 ]  mul_op2_m   =   { 1'b1, op2[9:0] };
wire    [ 10 : 0 ]  acc_ops_m   =   { 1'b1, ops[9:0] };

wire                mul_s   =   ~ ( mul_op1_s ^ mul_op2_s );
wire    [  4 : 0 ]  mul_e   =   mul_op1_e + mul_op2_e - 5'h0f;
wire    [ 10 : 0 ]  mul_m   =   ( mul_op1_m * mul_op2_m )[21:11];

reg                 add_s;
reg     [  4 : 0 ]  add_e;
reg     [ 11 : 0 ]  add_m;

wire    [  4 : 0 ]  dif_e   =   mul_e - ops_e;
reg     [ 10 : 0 ]  add_op1;
reg     [ 10 : 0 ]  add_op2;


always @* begin
if ( dif_e[4] ) begin
    add_op1 = acc_ops_m;
    add_op2 = mul_m >> ( -dif_e[3:0] );
    add_s = acc_ops_s;
end else begin
    add_op1 = mul_m;
    add_op2 = acc_ops_m >> dif_e[3:0];
    add_s = mul_s;
end
end    


always @* begin
if ( mul_s ^ ops_s ) begin
    add_m = add_op1 - add_op2;
end else begin
    add_m = add_op1 + add_op2;
end
end

reg     [  4 : 0 ]  acc_e_add;

always @* begin
if ( add_m[11] )
    acc_e_add = 5'h01;
else if ( add_m[10] )
    acc_e_add = 5'h00;
else if ( add_m[9] )
    acc_e_add = 5'h1f;
else if ( add_m[8] )
    acc_e_add = 5'h1e;
else if ( add_m[7] )
    acc_e_add = 5'h1d;
else if ( add_m[6] )
    acc_e_add = 5'h1c;
else if ( add_m[5] )
    acc_e_add = 5'h1b;
else if ( add_m[4] )
    acc_e_add = 5'h1a;
else if ( add_m[3] )
    acc_e_add = 5'h19;
else if ( add_m[2] )
    acc_e_add = 5'h18;
else if ( add_m[1] )
    acc_e_add = 5'h17;
else if ( add_m[0] )
    acc_e_add = 5'h16;
else
    acc_e_add = 5'h10;
end














endmodule