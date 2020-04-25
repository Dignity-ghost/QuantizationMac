// Latch

module mul(a,b,r);

input   [11:0]   a;
input   [11:0]   b;
output  [23:0]   r;


// level 0 ***************************************************/
wire    [11:0]   lv0_0 = a & {12{b[0]}};
wire    [11:0]   lv0_1 = a & {12{b[1]}};
wire    [11:0]   lv0_2 = a & {12{b[2]}};
wire    [11:0]   lv0_3 = a & {12{b[3]}};
wire    [11:0]   lv0_4 = a & {12{b[4]}};
wire    [11:0]   lv0_5 = a & {12{b[5]}};
wire    [11:0]   lv0_6 = a & {12{b[6]}};
wire    [11:0]   lv0_7 = a & {12{b[7]}};
wire    [11:0]   lv0_8 = a & {12{b[8]}};
wire    [11:0]   lv0_9 = a & {12{b[9]}};
wire    [11:0]   lv0_10 = a & {12{b[10]}};
wire    [11:0]   lv0_11 = a & {12{b[11]}};

// level 1 ***************************************************/
wire    [13:0]   lv1_s0;
wire    [11:0]   lv1_c0;
wire    [13:0]   lv1_s1;
wire    [11:0]   lv1_c1;
wire    [13:0]   lv1_s2;
wire    [11:0]   lv1_c2;
wire    [13:0]   lv1_s3;
wire    [11:0]   lv1_c3;

// group 0
assign  lv1_s0[0] = lv0_0[0];
HA  HA_lv1_g0_b1    ( .x(lv0_0[1]), .y(lv0_1[0]), .s(lv1_s0[1]), .c(lv1_c0[0]) );
CSA CSA_lv1_g0_b2   ( .x(lv0_0[2]), .y(lv0_1[1]), .z(lv0_2[0]), .s(lv1_s0[2]), .c(lv1_c0[1]) );
CSA CSA_lv1_g0_b3   ( .x(lv0_0[3]), .y(lv0_1[2]), .z(lv0_2[1]), .s(lv1_s0[3]), .c(lv1_c0[2]) );
CSA CSA_lv1_g0_b4   ( .x(lv0_0[4]), .y(lv0_1[3]), .z(lv0_2[2]), .s(lv1_s0[4]), .c(lv1_c0[3]) );
CSA CSA_lv1_g0_b5   ( .x(lv0_0[5]), .y(lv0_1[4]), .z(lv0_2[3]), .s(lv1_s0[5]), .c(lv1_c0[4]) );
CSA CSA_lv1_g0_b6   ( .x(lv0_0[6]), .y(lv0_1[5]), .z(lv0_2[4]), .s(lv1_s0[6]), .c(lv1_c0[5]) );
CSA CSA_lv1_g0_b7   ( .x(lv0_0[7]), .y(lv0_1[6]), .z(lv0_2[5]), .s(lv1_s0[7]), .c(lv1_c0[6]) );
CSA CSA_lv1_g0_b8   ( .x(lv0_0[8]), .y(lv0_1[7]), .z(lv0_2[6]), .s(lv1_s0[8]), .c(lv1_c0[7]) );
CSA CSA_lv1_g0_b9   ( .x(lv0_0[9]), .y(lv0_1[8]), .z(lv0_2[7]), .s(lv1_s0[9]), .c(lv1_c0[8]) );
CSA CSA_lv1_g0_b10  ( .x(lv0_0[10]), .y(lv0_1[9]), .z(lv0_2[8]), .s(lv1_s0[10]), .c(lv1_c0[9]) );
CSA CSA_lv1_g0_b11  ( .x(lv0_0[11]), .y(lv0_1[10]), .z(lv0_2[9]), .s(lv1_s0[11]), .c(lv1_c0[10]) );
HA  HA_lv1_g0_b12   ( .x(lv0_1[11]), .y(lv0_2[10]), .s(lv1_s0[12]), .c(lv1_c0[11]) );
assign  lv1_s0[13] = lv0_2[11];

// group 1
assign  lv1_s1[0] = lv0_3[0];
HA  HA_lv1_g1_b1    ( .x(lv0_3[1]), .y(lv0_4[0]), .s(lv1_s1[1]), .c(lv1_c1[0]) );
CSA CSA_lv1_g1_b2   ( .x(lv0_3[2]), .y(lv0_4[1]), .z(lv0_5[0]), .s(lv1_s1[2]), .c(lv1_c1[1]) );
CSA CSA_lv1_g1_b3   ( .x(lv0_3[3]), .y(lv0_4[2]), .z(lv0_5[1]), .s(lv1_s1[3]), .c(lv1_c1[2]) );
CSA CSA_lv1_g1_b4   ( .x(lv0_3[4]), .y(lv0_4[3]), .z(lv0_5[2]), .s(lv1_s1[4]), .c(lv1_c1[3]) );
CSA CSA_lv1_g1_b5   ( .x(lv0_3[5]), .y(lv0_4[4]), .z(lv0_5[3]), .s(lv1_s1[5]), .c(lv1_c1[4]) );
CSA CSA_lv1_g1_b6   ( .x(lv0_3[6]), .y(lv0_4[5]), .z(lv0_5[4]), .s(lv1_s1[6]), .c(lv1_c1[5]) );
CSA CSA_lv1_g1_b7   ( .x(lv0_3[7]), .y(lv0_4[6]), .z(lv0_5[5]), .s(lv1_s1[7]), .c(lv1_c1[6]) );
CSA CSA_lv1_g1_b8   ( .x(lv0_3[8]), .y(lv0_4[7]), .z(lv0_5[6]), .s(lv1_s1[8]), .c(lv1_c1[7]) );
CSA CSA_lv1_g1_b9   ( .x(lv0_3[9]), .y(lv0_4[8]), .z(lv0_5[7]), .s(lv1_s1[9]), .c(lv1_c1[8]) );
CSA CSA_lv1_g1_b10  ( .x(lv0_3[10]), .y(lv0_4[9]), .z(lv0_5[8]), .s(lv1_s1[10]), .c(lv1_c1[9]) );
CSA CSA_lv1_g1_b11  ( .x(lv0_3[11]), .y(lv0_4[10]), .z(lv0_5[9]), .s(lv1_s1[11]), .c(lv1_c1[10]) );
HA  HA_lv1_g1_b12   ( .x(lv0_4[11]), .y(lv0_5[10]), .s(lv1_s1[12]), .c(lv1_c1[11]) );
assign  lv1_s1[13] = lv0_5[11];

// group 2
assign  lv1_s2[0] = lv0_6[0];
HA  HA_lv1_g2_b1    ( .x(lv0_6[1]), .y(lv0_7[0]), .s(lv1_s2[1]), .c(lv1_c2[0]) );
CSA CSA_lv1_g2_b2   ( .x(lv0_6[2]), .y(lv0_7[1]), .z(lv0_8[0]), .s(lv1_s2[2]), .c(lv1_c2[1]) );
CSA CSA_lv1_g2_b3   ( .x(lv0_6[3]), .y(lv0_7[2]), .z(lv0_8[1]), .s(lv1_s2[3]), .c(lv1_c2[2]) );
CSA CSA_lv1_g2_b4   ( .x(lv0_6[4]), .y(lv0_7[3]), .z(lv0_8[2]), .s(lv1_s2[4]), .c(lv1_c2[3]) );
CSA CSA_lv1_g2_b5   ( .x(lv0_6[5]), .y(lv0_7[4]), .z(lv0_8[3]), .s(lv1_s2[5]), .c(lv1_c2[4]) );
CSA CSA_lv1_g2_b6   ( .x(lv0_6[6]), .y(lv0_7[5]), .z(lv0_8[4]), .s(lv1_s2[6]), .c(lv1_c2[5]) );
CSA CSA_lv1_g2_b7   ( .x(lv0_6[7]), .y(lv0_7[6]), .z(lv0_8[5]), .s(lv1_s2[7]), .c(lv1_c2[6]) );
CSA CSA_lv1_g2_b8   ( .x(lv0_6[8]), .y(lv0_7[7]), .z(lv0_8[6]), .s(lv1_s2[8]), .c(lv1_c2[7]) );
CSA CSA_lv1_g2_b9   ( .x(lv0_6[9]), .y(lv0_7[8]), .z(lv0_8[7]), .s(lv1_s2[9]), .c(lv1_c2[8]) );
CSA CSA_lv1_g2_b10  ( .x(lv0_6[10]), .y(lv0_7[9]), .z(lv0_8[8]), .s(lv1_s2[10]), .c(lv1_c2[9]) );
CSA CSA_lv1_g2_b11  ( .x(lv0_6[11]), .y(lv0_7[10]), .z(lv0_8[9]), .s(lv1_s2[11]), .c(lv1_c2[10]) );
HA  HA_lv1_g2_b12   ( .x(lv0_7[11]), .y(lv0_8[10]), .s(lv1_s2[12]), .c(lv1_c2[11]) );
assign  lv1_s2[13] = lv0_8[11];

// group 3
assign  lv1_s3[0] = lv0_9[0];
HA  HA_lv1_g3_b1    ( .x(lv0_9[1]), .y(lv0_10[0]), .s(lv1_s3[1]), .c(lv1_c3[0]) );
CSA CSA_lv1_g3_b2   ( .x(lv0_9[2]), .y(lv0_10[1]), .z(lv0_11[0]), .s(lv1_s3[2]), .c(lv1_c3[1]) );
CSA CSA_lv1_g3_b3   ( .x(lv0_9[3]), .y(lv0_10[2]), .z(lv0_11[1]), .s(lv1_s3[3]), .c(lv1_c3[2]) );
CSA CSA_lv1_g3_b4   ( .x(lv0_9[4]), .y(lv0_10[3]), .z(lv0_11[2]), .s(lv1_s3[4]), .c(lv1_c3[3]) );
CSA CSA_lv1_g3_b5   ( .x(lv0_9[5]), .y(lv0_10[4]), .z(lv0_11[3]), .s(lv1_s3[5]), .c(lv1_c3[4]) );
CSA CSA_lv1_g3_b6   ( .x(lv0_9[6]), .y(lv0_10[5]), .z(lv0_11[4]), .s(lv1_s3[6]), .c(lv1_c3[5]) );
CSA CSA_lv1_g3_b7   ( .x(lv0_9[7]), .y(lv0_10[6]), .z(lv0_11[5]), .s(lv1_s3[7]), .c(lv1_c3[6]) );
CSA CSA_lv1_g3_b8   ( .x(lv0_9[8]), .y(lv0_10[7]), .z(lv0_11[6]), .s(lv1_s3[8]), .c(lv1_c3[7]) );
CSA CSA_lv1_g3_b9   ( .x(lv0_9[9]), .y(lv0_10[8]), .z(lv0_11[7]), .s(lv1_s3[9]), .c(lv1_c3[8]) );
CSA CSA_lv1_g3_b10  ( .x(lv0_9[10]), .y(lv0_10[9]), .z(lv0_11[8]), .s(lv1_s3[10]), .c(lv1_c3[9]) );
CSA CSA_lv1_g3_b11  ( .x(lv0_9[11]), .y(lv0_10[10]), .z(lv0_11[9]), .s(lv1_s3[11]), .c(lv1_c3[10]) );
HA  HA_lv1_g3_b12   ( .x(lv0_10[11]), .y(lv0_11[10]), .s(lv1_s3[12]), .c(lv1_c3[11]) );
assign  lv1_s3[13] = lv0_11[11];


// level 2 ***************************************************/
wire    [16:0]   lv2_s0;
wire    [11:0]   lv2_c0;
wire    [14:0]   lv2_s1;
wire    [13:0]   lv2_c1;
wire    [13:0]   lv2_s2;
wire    [11:0]   lv2_c2;

// group 0
assign  lv2_s0[1:0] = lv1_s0[1:0];
assign  lv2_s0[16:14] = lv1_s1[13:11];
HA  HA_lv2_g0_b2    ( .x(lv1_s0[2]), .y(lv1_c0[0]), .s(lv2_s0[2]), .c(lv2_c0[0]) );
CSA CSA_lv2_g0_b3   ( .x(lv1_s0[3]), .y(lv1_c0[1]), .z(lv1_s1[0]), .s(lv2_s0[3]), .c(lv2_c0[1]) );
CSA CSA_lv2_g0_b4   ( .x(lv1_s0[4]), .y(lv1_c0[2]), .z(lv1_s1[1]), .s(lv2_s0[4]), .c(lv2_c0[2]) );
CSA CSA_lv2_g0_b5   ( .x(lv1_s0[5]), .y(lv1_c0[3]), .z(lv1_s1[2]), .s(lv2_s0[5]), .c(lv2_c0[3]) );
CSA CSA_lv2_g0_b6   ( .x(lv1_s0[6]), .y(lv1_c0[4]), .z(lv1_s1[3]), .s(lv2_s0[6]), .c(lv2_c0[4]) );
CSA CSA_lv2_g0_b7   ( .x(lv1_s0[7]), .y(lv1_c0[5]), .z(lv1_s1[4]), .s(lv2_s0[7]), .c(lv2_c0[5]) );
CSA CSA_lv2_g0_b8   ( .x(lv1_s0[8]), .y(lv1_c0[6]), .z(lv1_s1[5]), .s(lv2_s0[8]), .c(lv2_c0[6]) );
CSA CSA_lv2_g0_b9   ( .x(lv1_s0[9]), .y(lv1_c0[7]), .z(lv1_s1[6]), .s(lv2_s0[9]), .c(lv2_c0[7]) );
CSA CSA_lv2_g0_b10  ( .x(lv1_s0[10]), .y(lv1_c0[8]), .z(lv1_s1[7]), .s(lv2_s0[10]), .c(lv2_c0[8]) );
CSA CSA_lv2_g0_b11  ( .x(lv1_s0[11]), .y(lv1_c0[9]), .z(lv1_s1[8]), .s(lv2_s0[11]), .c(lv2_c0[9]) );
CSA CSA_lv2_g0_b12  ( .x(lv1_s0[12]), .y(lv1_c0[10]), .z(lv1_s1[9]), .s(lv2_s0[12]), .c(lv2_c0[10]) );
CSA CSA_lv2_g0_b13  ( .x(lv1_s0[13]), .y(lv1_c0[11]), .z(lv1_s1[10]), .s(lv2_s0[13]), .c(lv2_c0[11]) );

// group 1
assign  lv2_s1[0] = lv1_c1[0];
HA  HA_lv2_g1_b1    ( .x(lv1_c1[1]), .y(lv1_s2[0]), .s(lv2_s1[1]), .c(lv2_c1[0]) );
HA  HA_lv2_g1_b2    ( .x(lv1_c1[2]), .y(lv1_s2[1]), .s(lv2_s1[2]), .c(lv2_c1[1]) );
CSA CSA_lv2_g1_b3   ( .x(lv1_c1[3]), .y(lv1_s2[2]), .z(lv1_c2[0]), .s(lv2_s1[3]), .c(lv2_c1[2]) );
CSA CSA_lv2_g1_b4   ( .x(lv1_c1[4]), .y(lv1_s2[3]), .z(lv1_c2[1]), .s(lv2_s1[4]), .c(lv2_c1[3]) );
CSA CSA_lv2_g1_b5   ( .x(lv1_c1[5]), .y(lv1_s2[4]), .z(lv1_c2[2]), .s(lv2_s1[5]), .c(lv2_c1[4]) );
CSA CSA_lv2_g1_b6   ( .x(lv1_c1[6]), .y(lv1_s2[5]), .z(lv1_c2[3]), .s(lv2_s1[6]), .c(lv2_c1[5]) );
CSA CSA_lv2_g1_b7   ( .x(lv1_c1[7]), .y(lv1_s2[6]), .z(lv1_c2[4]), .s(lv2_s1[7]), .c(lv2_c1[6]) );
CSA CSA_lv2_g1_b8   ( .x(lv1_c1[8]), .y(lv1_s2[7]), .z(lv1_c2[5]), .s(lv2_s1[8]), .c(lv2_c1[7]) );
CSA CSA_lv2_g1_b9   ( .x(lv1_c1[9]), .y(lv1_s2[8]), .z(lv1_c2[6]), .s(lv2_s1[9]), .c(lv2_c1[8]) );
CSA CSA_lv2_g1_b10  ( .x(lv1_c1[10]), .y(lv1_s2[9]), .z(lv1_c2[7]), .s(lv2_s1[10]), .c(lv2_c1[9]) );
CSA CSA_lv2_g1_b11  ( .x(lv1_c1[11]), .y(lv1_s2[10]), .z(lv1_c2[8]), .s(lv2_s1[11]), .c(lv2_c1[10]) );
HA  HA_lv2_g1_b12   ( .x(lv1_s2[11]), .y(lv1_c2[11]), .s(lv2_s1[12]), .c(lv2_c1[11]) );
HA  HA_lv2_g1_b13   ( .x(lv1_s2[12]), .y(lv1_c2[10]), .s(lv2_s1[13]), .c(lv2_c1[12]) );
HA  HA_lv2_g1_b14   ( .x(lv1_s2[13]), .y(lv1_c2[9]), .s(lv2_s1[14]), .c(lv2_c1[13]) );

// group 2
assign  lv2_s2 = lv1_s3;
assign  lv2_c2 = lv1_c3;



// level 3 ***************************************************/
wire    [19:0]   lv3_s0;
wire    [13:0]   lv3_c0;
wire    [15:0]   lv3_s1;
wire    [13:0]   lv3_c1;

// group 0
assign lv3_s0[2:0]=lv2_s0[2:0];
HA  HA_lv3_g0_b3    ( .x(lv2_s0[3]), .y(lv2_c0[0]), .s(lv3_s0[3]), .c(lv3_c0[0]) );
HA  HA_lv3_g0_b4    ( .x(lv2_s0[4]), .y(lv2_c0[1]), .s(lv3_s0[4]), .c(lv3_c0[1]) );
CSA CSA_lv3_g0_b5   ( .x(lv2_s0[5]), .y(lv2_c0[2]), .z(lv2_s1[0]), .s(lv3_s0[5]), .c(lv3_c0[2]) );
CSA CSA_lv3_g0_b6   ( .x(lv2_s0[6]), .y(lv2_c0[3]), .z(lv2_s1[1]), .s(lv3_s0[6]), .c(lv3_c0[3]) );
CSA CSA_lv3_g0_b7   ( .x(lv2_s0[7]), .y(lv2_c0[4]), .z(lv2_s1[2]), .s(lv3_s0[7]), .c(lv3_c0[4]) );
CSA CSA_lv3_g0_b8   ( .x(lv2_s0[8]), .y(lv2_c0[5]), .z(lv2_s1[3]), .s(lv3_s0[8]), .c(lv3_c0[5]) );
CSA CSA_lv3_g0_b9   ( .x(lv2_s0[9]), .y(lv2_c0[6]), .z(lv2_s1[4]), .s(lv3_s0[9]), .c(lv3_c0[6]) );
CSA CSA_lv3_g0_b10  ( .x(lv2_s0[10]), .y(lv2_c0[7]), .z(lv2_s1[5]), .s(lv3_s0[10]), .c(lv3_c0[7]) );
CSA CSA_lv3_g0_b11  ( .x(lv2_s0[11]), .y(lv2_c0[8]), .z(lv2_s1[6]), .s(lv3_s0[11]), .c(lv3_c0[8]) );
CSA CSA_lv3_g0_b12  ( .x(lv2_s0[12]), .y(lv2_c0[9]), .z(lv2_s1[7]), .s(lv3_s0[12]), .c(lv3_c0[9]) );
CSA CSA_lv3_g0_b13  ( .x(lv2_s0[13]), .y(lv2_c0[10]), .z(lv2_s1[8]), .s(lv3_s0[13]), .c(lv3_c0[10]) );
CSA CSA_lv3_g0_b14  ( .x(lv2_s0[14]), .y(lv2_c0[11]), .z(lv2_s1[9]), .s(lv3_s0[14]), .c(lv3_c0[11]) );
HA  HA_lv3_g0_b15   ( .x(lv2_s0[15]), .y(lv2_s1[10]), .s(lv3_s0[15]), .c(lv3_c0[12]) );
HA  HA_lv3_g0_b16   ( .x(lv2_s0[16]), .y(lv2_s1[11]), .s(lv3_s0[16]), .c(lv3_c0[13]) );
assign lv3_s0[19:17]=lv2_s1[14:12];

// group 1
assign lv3_s1[1:0]=lv2_c1[1:0];
HA  HA_lv3_g1_b22   ( .x(lv2_c1[2]), .y(lv2_s2[0]), .s(lv3_s1[2]), .c(lv3_c1[0]) );
HA  HA_lv3_g1_b33   ( .x(lv2_c1[3]), .y(lv2_s2[1]), .s(lv3_s1[3]), .c(lv3_c1[1]) );
CSA CSA_lv3_g1_b4   ( .x(lv2_c1[4]), .y(lv2_s2[2]), .z(lv2_c2[0]), .s(lv3_s1[4]), .c(lv3_c1[2]) );
CSA CSA_lv3_g1_b5   ( .x(lv2_c1[5]), .y(lv2_s2[3]), .z(lv2_c2[1]), .s(lv3_s1[5]), .c(lv3_c1[3]) );
CSA CSA_lv3_g1_b6   ( .x(lv2_c1[6]), .y(lv2_s2[4]), .z(lv2_c2[2]), .s(lv3_s1[6]), .c(lv3_c1[4]) );
CSA CSA_lv3_g1_b7   ( .x(lv2_c1[7]), .y(lv2_s2[5]), .z(lv2_c2[3]), .s(lv3_s1[7]), .c(lv3_c1[5]) );
CSA CSA_lv3_g1_b8   ( .x(lv2_c1[8]), .y(lv2_s2[6]), .z(lv2_c2[4]), .s(lv3_s1[8]), .c(lv3_c1[6]) );
CSA CSA_lv3_g1_b9   ( .x(lv2_c1[9]), .y(lv2_s2[7]), .z(lv2_c2[5]), .s(lv3_s1[9]), .c(lv3_c1[7]) );
CSA CSA_lv3_g1_b10  ( .x(lv2_c1[10]), .y(lv2_s2[8]), .z(lv2_c2[6]), .s(lv3_s1[10]), .c(lv3_c1[8]) );
CSA CSA_lv3_g1_b11  ( .x(lv2_c1[11]), .y(lv2_s2[9]), .z(lv2_c2[7]), .s(lv3_s1[11]), .c(lv3_c1[9]) );
CSA CSA_lv3_g1_b12  ( .x(lv2_c1[12]), .y(lv2_s2[10]), .z(lv2_c2[8]), .s(lv3_s1[12]), .c(lv3_c1[10]) );
CSA CSA_lv3_g1_b13  ( .x(lv2_c1[13]), .y(lv2_s2[11]), .z(lv2_c2[9]), .s(lv3_s1[13]), .c(lv3_c1[11]) );
HA  HA_lv3_g1_b14   ( .x(lv2_s2[12]), .y(lv2_c2[10]), .s(lv3_s1[14]), .c(lv3_c1[12]) );
HA  HA_lv3_g1_b15   ( .x(lv2_s2[13]), .y(lv2_c2[11]), .s(lv3_s1[15]), .c(lv3_c1[13]) );


// level 4 ***************************************************/
wire    [19:0]   lv4_s0;
wire    [19:0]   lv4_s1;
wire    [15:0]   lv4_c1;

// group 0
assign lv4_s0 = lv3_s0;

// group 1
assign lv4_s1[2:0] = lv3_c0[2:0];
HA  HA_lv4_g1_b3    ( .x(lv3_c0[3]), .y(lv3_s1[0]), .s(lv4_s1[3]), .c(lv4_c1[0]) );
HA  HA_lv4_g1_b4    ( .x(lv3_c0[4]), .y(lv3_s1[1]), .s(lv4_s1[4]), .c(lv4_c1[1]) );
HA  HA_lv4_g1_b5    ( .x(lv3_c0[5]), .y(lv3_s1[2]), .s(lv4_s1[5]), .c(lv4_c1[2]) );
CSA CSA_lv4_g1_b6   ( .x(lv3_c0[6]), .y(lv3_s1[3]), .z(lv3_c1[0]), .s(lv4_s1[6]), .c(lv4_c1[3]) );
CSA CSA_lv4_g1_b7   ( .x(lv3_c0[7]), .y(lv3_s1[4]), .z(lv3_c1[1]), .s(lv4_s1[7]), .c(lv4_c1[4]) );
CSA CSA_lv4_g1_b8   ( .x(lv3_c0[8]), .y(lv3_s1[5]), .z(lv3_c1[2]), .s(lv4_s1[8]), .c(lv4_c1[5]) );
CSA CSA_lv4_g1_b9   ( .x(lv3_c0[9]), .y(lv3_s1[6]), .z(lv3_c1[3]), .s(lv4_s1[9]), .c(lv4_c1[6]) );
CSA CSA_lv4_g1_b10  ( .x(lv3_c0[10]), .y(lv3_s1[7]), .z(lv3_c1[4]), .s(lv4_s1[10]), .c(lv4_c1[7]) );
CSA CSA_lv4_g1_b11  ( .x(lv3_c0[11]), .y(lv3_s1[8]), .z(lv3_c1[5]), .s(lv4_s1[11]), .c(lv4_c1[8]) );
CSA CSA_lv4_g1_b12  ( .x(lv3_c0[12]), .y(lv3_s1[9]), .z(lv3_c1[6]), .s(lv4_s1[12]), .c(lv4_c1[9]) );
CSA CSA_lv4_g1_b13  ( .x(lv3_c0[13]), .y(lv3_s1[10]), .z(lv3_c1[7]), .s(lv4_s1[13]), .c(lv4_c1[10]) );
HA  HA_lv4_g1_b14   ( .x(lv3_s1[11]), .y(lv3_c1[8]), .s(lv4_s1[14]), .c(lv4_c1[11]) );
HA  HA_lv4_g1_b15   ( .x(lv3_s1[12]), .y(lv3_c1[9]), .s(lv4_s1[15]), .c(lv4_c1[12]) );
HA  HA_lv4_g1_b16   ( .x(lv3_s1[13]), .y(lv3_c1[10]), .s(lv4_s1[16]), .c(lv4_c1[13]) );
HA  HA_lv4_g1_b17   ( .x(lv3_s1[14]), .y(lv3_c1[11]), .s(lv4_s1[17]), .c(lv4_c1[14]) );
HA  HA_lv4_g1_b18   ( .x(lv3_s1[15]), .y(lv3_c1[12]), .s(lv4_s1[18]), .c(lv4_c1[15]) );
assign lv4_s1[19] = lv3_c1[13];



// level 5 ***************************************************/
wire    [23:0]   lv5_s;
wire    [18:0]   lv5_c;

assign lv5_s[3:0] = lv4_s0[3:0];
HA  HA_lv5_b4       ( .x(lv4_s0[4]), .y(lv4_s1[0]), .s(lv5_s[4]), .c(lv5_c[0]) );
HA  HA_lv5_b5       ( .x(lv4_s0[5]), .y(lv4_s1[1]), .s(lv5_s[5]), .c(lv5_c[1]) );
HA  HA_lv5_b6       ( .x(lv4_s0[6]), .y(lv4_s1[2]), .s(lv5_s[6]), .c(lv5_c[2]) );
HA  HA_lv5_b7       ( .x(lv4_s0[7]), .y(lv4_s1[3]), .s(lv5_s[7]), .c(lv5_c[3]) );
CSA CSA_lv5_b8      ( .x(lv4_s0[8]), .y(lv4_s1[4]), .z(lv4_c1[0]), .s(lv5_s[8]), .c(lv5_c[4]) );
CSA CSA_lv5_b9      ( .x(lv4_s0[9]), .y(lv4_s1[5]), .z(lv4_c1[1]), .s(lv5_s[9]), .c(lv5_c[5]) );
CSA CSA_lv5_b10     ( .x(lv4_s0[10]), .y(lv4_s1[6]), .z(lv4_c1[2]), .s(lv5_s[10]), .c(lv5_c[6]) );
CSA CSA_lv5_b11     ( .x(lv4_s0[11]), .y(lv4_s1[7]), .z(lv4_c1[3]), .s(lv5_s[11]), .c(lv5_c[7]) );
CSA CSA_lv5_b12     ( .x(lv4_s0[12]), .y(lv4_s1[8]), .z(lv4_c1[4]), .s(lv5_s[12]), .c(lv5_c[8]) );
CSA CSA_lv5_b13     ( .x(lv4_s0[13]), .y(lv4_s1[9]), .z(lv4_c1[5]), .s(lv5_s[13]), .c(lv5_c[9]) );
CSA CSA_lv5_b14     ( .x(lv4_s0[14]), .y(lv4_s1[10]), .z(lv4_c1[6]), .s(lv5_s[14]), .c(lv5_c[10]) );
CSA CSA_lv5_b15     ( .x(lv4_s0[15]), .y(lv4_s1[11]), .z(lv4_c1[7]), .s(lv5_s[15]), .c(lv5_c[11]) );
CSA CSA_lv5_b16     ( .x(lv4_s0[16]), .y(lv4_s1[12]), .z(lv4_c1[8]), .s(lv5_s[16]), .c(lv5_c[12]) );
CSA CSA_lv5_b17     ( .x(lv4_s0[17]), .y(lv4_s1[13]), .z(lv4_c1[9]), .s(lv5_s[17]), .c(lv5_c[13]) );
CSA CSA_lv5_b18     ( .x(lv4_s0[18]), .y(lv4_s1[14]), .z(lv4_c1[10]), .s(lv5_s[18]), .c(lv5_c[14]) );
CSA CSA_lv5_b19     ( .x(lv4_s0[19]), .y(lv4_s1[15]), .z(lv4_c1[11]), .s(lv5_s[19]), .c(lv5_c[15]) );
HA  HA_lv5_b20      ( .x(lv4_s1[16]), .y(lv4_c1[12]), .s(lv5_s[20]), .c(lv5_c[16]) );
HA  HA_lv5_b21      ( .x(lv4_s1[17]), .y(lv4_c1[13]), .s(lv5_s[21]), .c(lv5_c[17]) );
HA  HA_lv5_b22      ( .x(lv4_s1[18]), .y(lv4_c1[14]), .s(lv5_s[22]), .c(lv5_c[18]) );
assign lv5_s[23] = lv4_s1[19] | lv4_c1[15];


// level 5 (final) *******************************************/
assign r[ 4: 0] = lv5_s[ 4:0];
assign r[23: 5] = lv5_s[23:5] + lv5_c;



endmodule 