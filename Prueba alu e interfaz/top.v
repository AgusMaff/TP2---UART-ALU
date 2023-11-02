`timescale 1ns / 1ps

module top(
        input CLK100MHz, Reset,
        input [7:0] sw,
        input tx_full_sw,
        input rx_empty_sw,
        input tx_done_tick_sw,
        output [7:0] LED,
        output rd_led, wr_led
    );
    
    wire [7:0] alu_result;
    wire [7:0] op_a;
    wire [7:0] op_b;
    wire [5:0] op_code;
    
    interface INT(
     .clk(CLK100MHz), 
     .i_reset(Reset),
     .i_data(sw), 
     .i_resul(alu_result),
     .tx_full_signal(tx_full_sw),
     .rx_empty_signal(rx_empty_sw), 
     .tx_done_tick(tx_done_tick_sw),
     .opA(op_a),
     .opB(op_b), 
     .opCode(op_code),
     .o_result(LED),
     .rd_signal(rd_led), 
     .wr_signal(wr_led));
    
    alu ALU(.dato_a(op_a),.dato_b(op_b),.op_code(op_code),.o_resultado(alu_result));

endmodule