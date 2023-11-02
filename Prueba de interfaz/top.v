`timescale 1ns / 1ps

module top(
        input CLK100MHz, Reset,
        input [2:0] sw,
        output [4:0] LED,
        output rd, wr
    );
    
    interface INT(.clk(CLK100MHz), .i_reset(Reset), .tx_full_signal(sw[0]), .rx_empty_signal(sw[1]), 
    .tx_done_tick(sw[2]), .flags(LED), .rd_signal(rd), .wr_signal(wr));

endmodule
