module mac(
	mode,
    value, weight,
    ints, fps,
    intr, fpr
);

// port **********************************************************
input   wire    [ 3: 0]     mode;
input   wire    [15: 0]     value, weight;
input   wire    [23: 0]     ints;   // int8 bias in
input   wire    [17: 0]     fps;    // fp16 bias in
output  wire    [23: 0]     intr;   // int8 result
output  wire    [17: 0]     fpr;    // fp16 bias out

// parameter *****************************************************
parameter                   mode_fp     = 0;
parameter                   mode_int_s  = 1;
parameter                   mode_int_m  = 2;
parameter                   mode_int_l  = 3;
parameter                   exp_zero    = 5'h0c;

// logic *********************************************************
wire    signed      [12: 0]     mul_weight  =   ( weight == 16'h0       ) ? {          13'h0                                } :
                                                ( mode[mode_fp]         ) ? {     weight[15],    ~weight[15], weight[10:0]  } :
                                                ( mode[mode_int_s]      ) ? { {2{weight[7]}},   weight[ 7:0], 3'b0          } :
                                                                            {                   weight[ 7:0], 5'b0          } ;
wire    signed      [13: 0]     mul_value   =   ( value  == 16'h0       ) ? {          14'h0                                } :
                                                ( mode[mode_fp]         ) ? {           2'h1,    value[11:0]                } :
                                                ( mode[mode_int_l]      ) ? {           1'b0,    value[ 7:0], 5'b0          } :
                                                                            {           3'b0,    value[ 7:0], 3'b0          } ;
wire    signed      [25: 0]     mul_result  =   mul_value * mul_weight;
wire    signed      [13: 0]     mul_result_fp=  mul_result[25:12]; 

wire    signed      [ 3: 0]     exp_weight  =   ( mode[mode_fp] ) ? weight[14:11] : 4'h0;
wire    signed      [ 3: 0]     exp_value   =   ( mode[mode_fp] ) ? value[15:12]  : 4'h0;
wire    signed      [ 4: 0]     exp_mul_result = exp_value + exp_weight;
wire    signed      [ 4: 0]     fps_exp     =   fps[17:13];
wire    signed      [12: 0]     fps_man     =   fps[12:0];

assign                          intr        =   ints + { {6{mul_result[23]}}, mul_result[23:6] };

wire    signed      [ 4: 0]     shift       =   exp_mul_result - fps_exp;
wire                            mul_lt_fps  =   ~shift[4];
wire    signed      [13: 0]     acc_mul     =   mul_result_fp   >>> ( ~mul_lt_fps ? -shift : 0 );
wire    signed      [12: 0]     acc_fps     =   fps_man         >>> (  mul_lt_fps ?  shift : 0 );
wire    signed      [13: 0]     acc_fp_m    =   acc_mul + { acc_fps[12], acc_fps } ;

integer                         i;
reg     signed      [ 3: 0]     fpr_m_norm_shift;
always @* begin
    fpr_m_norm_shift = 0;
    for (i = 0; i < 13; i = i + 1) begin
        if (acc_fp_m[i] ^ acc_fp_m[13])
            fpr_m_norm_shift = 4'd11-i;
   end
end

wire    signed      [12: 0]     fpr_m       = &fpr_m_norm_shift ? acc_fp_m[13:1] : acc_fp_m << ( fpr_m_norm_shift );
wire    unsigned    [ 4: 0]     fpr_e       = ( mul_lt_fps ? exp_mul_result : fps_exp ) - fpr_m_norm_shift;

assign                          fpr         =   { fpr_e, fpr_m };

endmodule 