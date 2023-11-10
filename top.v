`timescale 1ns / 1ps

module top
#(
    parameter BUS_SIZE = 8,
              DBIT        = 8,    // data bits
              SB_TICK     = 16,   // ticks for stop bits
                                    // 16/24/32 for 1/1.5/2 stop bits
              DVSR        = 163,  // baud rate divisor
                                    // DVSR = 50M/(16* baud rate)
              DVSR_BITS   = 9,    // number of bits in divisor
              FIFO_W      = 2    // FIFO width
                                    // words in FIFO = 2^FIFO_W
)
(
    input CLK100MHz, Reset,
    input RsRx,
    output RsTx,
    output[BUS_SIZE-1:0] LED
    );
    
    wire rd_signal;
    wire wr_signal;
    wire [BUS_SIZE-1:0] tx_data;
    wire [BUS_SIZE-1:0] rx_data;
    wire tx_full_signal;
    wire rx_empty_signal;
    wire tx_done_tick;
    
    wire [BUS_SIZE-1:0] opA;
    wire [BUS_SIZE-1:0] opB;
    wire [BUS_SIZE-3:0] opCode;
    wire [BUS_SIZE-1:0] i_alu_result;
    
    assign LED = i_alu_result;
    
    uart_core#(
        .DBIT(DBIT),
        .SB_TICK(SB_TICK),
        .DVSR(DVSR),
        .DVSR_BITS(9),
        .FIFO_W(FIFO_W)
    )
    (
        .clk(CLK100MHz), .reset(Reset),
        .rd_uart(rd_signal), .wr_uart(wr_signal), .rx(RsRx),
        .w_data(tx_data),
        .r_data(rx_data),
        .tx_full(tx_full_signal), .rx_empty(rx_empty_signal), .tx(RsTx), .tx_done_tick(tx_done_tick)
    );
    
    interface(
        .clk(CLK100MHz), .reset(Reset),
        .i_data(rx_data), .i_result(i_alu_result), .tx_full_signal(tx_full_signal),.rx_empty_signal(rx_empty_signal), .tx_done_tick(tx_done_tick),
        .op_a(opA), .op_b(opB), .op_code(opCode),
        .o_result(tx_data), .rd_signal(rd_signal), .wr_signal(wr_signal)
    );
    
    alu(
        .dato_a(opA),
        .dato_b(opB),
        .op_code(opCode),
        .o_resultado(i_alu_result)
);
    
endmodule
