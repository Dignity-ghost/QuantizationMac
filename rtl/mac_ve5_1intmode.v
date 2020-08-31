module mac_ve5_1intmode(
	mode,
    value, weight,
    ints, fps,
    intr, fpr
);

// port **********************************************************
input   wire                mode;   // 1-fp16 0-int8
input   wire    [15: 0]     value, weight;
input   wire    [27: 0]     ints;   // int8 bias in
input   wire    [17: 0]     fps;    // fp16 bias in
output  wire    [27: 0]     intr;   // int8 result
output  wire    [17: 0]     fpr;    // fp16 bias out

// logic *********************************************************
wire                            weight_notzero  =   |weight;
wire                            value_notzero   =   |value;
wire    signed      [12: 0]     mul_weight  =   mode    ?   { weight[15] & weight_notzero, ~weight[15] & weight_notzero, weight[10:0] } :
                                                            { {5{weight[7]}}, weight[7:0] } ;
wire    signed      [12: 0]     mul_value   =   mode    ?   { 1'b0, value_notzero, value[10:0] } :
                                                            { 5'h0, value[7:0] } ;
wire    signed      [24: 0]     mul_result  =   mul_value * mul_weight;
wire    signed      [13: 0]     mul_result_fp=  mul_result[24:11]; 

wire    unsigned    [ 3: 0]     exp_weight  =   weight[14:11];
wire    unsigned    [ 4: 0]     exp_value   =   value[15:11];
wire    unsigned    [ 5: 0]     exp_mul_result = exp_value + exp_weight - 5'hc;
wire    unsigned    [ 4: 0]     fps_exp     =   fps[17:13];
wire    signed      [12: 0]     fps_man     =   fps[12:0];

assign                          intr        =   ints + { {12{mul_result[15]}}, mul_result[15:0] };

wire    signed      [ 5: 0]     shift       =   exp_mul_result - fps_exp;
wire                            mul_lt_fps  =   ~shift[5];
wire    signed      [13: 0]     acc_mul     =   mul_result_fp   >>> ( ~mul_lt_fps ? -shift : 0 );
wire    signed      [12: 0]     acc_fps     =   fps_man         >>> (  mul_lt_fps ?  shift : 0 );
wire    signed      [13: 0]     acc_fp_m    =   acc_mul + { acc_fps[12], acc_fps } ;

integer                         i;
reg     signed      [ 4: 0]     fpr_m_norm_shift;
always @* begin
    fpr_m_norm_shift = 0;
    for (i = 0; i < 13; i = i + 1) begin
        if (acc_fp_m[i] ^ acc_fp_m[13])
            fpr_m_norm_shift = 5'd11-i;
   end
end

wire    signed      [12: 0]     fpr_m       = &fpr_m_norm_shift ? acc_fp_m[13:1] : acc_fp_m << ( fpr_m_norm_shift );
wire    unsigned    [ 4: 0]     fpr_e       = ( mul_lt_fps ? exp_mul_result : fps_exp ) + ( -fpr_m_norm_shift );

assign                          fpr         =   { fpr_e, fpr_m };

endmodule 