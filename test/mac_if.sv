`ifndef MAC_IF__SV
`define MAC_IF__SV

interface mac_if(input clk, input rst_n);

   logic [ 3: 0] mode;
   logic [15: 0] value, weight;
   logic [23: 0] ints;
   logic [17: 0] fps;
   
   logic [23: 0] intr;
   logic [17: 0] fpr;
endinterface

`endif
