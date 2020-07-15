`ifndef MAC_IF__SV
`define MAC_IF__SV

interface mac_if(input clk, input rst_n);

   logic         mode;
   logic [15: 0] value, weight;
   logic [27: 0] ints;
   logic [17: 0] fps;
   
   logic [27: 0] intr;
   logic [17: 0] fpr;
endinterface

`endif
