`include "uvm_macros.svh"

import uvm_pkg::*;
`include "mac_if.sv"
`include "mac_transaction.sv"
`include "mac_sequencer.sv"
`include "mac_driver.sv"
`include "mac_monitor.sv"
`include "mac_agent.sv"
`include "mac_model.sv"
`include "mac_scoreboard.sv"
`include "mac_sequence.sv"
`include "mac_env.sv"
`include "base_test.sv"

module top_tb;

reg clk;
reg rst_n;

mac_if input_if(clk, rst_n);
mac_if output_if(clk, rst_n);

// dut mac_dut(.clk(clk),
//            .rst_n(rst_n),
//            .rxd(input_if.data),
//            .rx_dv(input_if.valid),
//            .txd(output_if.data),
//            .tx_en(output_if.valid));

mac_ve5 mac_dut(.mode(input_if.mode),
            .value(input_if.value),
            .weight(input_if.weight),
            .ints(input_if.ints),
            .fps(input_if.fps),
            .intr(output_if.intr),
            .fpr(output_if.fpr));

initial begin
   clk = 0;
   forever begin
      #100 clk = ~clk;
   end
end

initial begin
   rst_n = 1'b0;
   #1000;
   rst_n = 1'b1;
end

initial begin
   run_test("base_test");
end

initial begin
   int simu_times = 100000;
   uvm_config_db#(virtual mac_if)::set(null, "uvm_test_top.env.i_agt.drv", "vif", input_if);
   uvm_config_db#(virtual mac_if)::set(null, "uvm_test_top.env.i_agt.mon", "vif", input_if);
   uvm_config_db#(virtual mac_if)::set(null, "uvm_test_top.env.o_agt.mon", "vif", output_if);
   uvm_config_db#(int)::set(null, "*", "simu_times", simu_times);
end

endmodule
