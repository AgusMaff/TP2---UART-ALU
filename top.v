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
    
    wire rd;
    wire wr;
    wire [BUS_SIZE-1:0] tx_data;
    wire [BUS_SIZE-1:0] rx_data;
    wire full_signal;
    wire empty_signal;
    wire done_tick;
    
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
        .rd_uart(rd), .wr_uart(wr), .rx(RsRx),
        .w_data(tx_data),
        .r_data(rx_data),
        .tx_full(full_signal), .rx_empty(empty_signal), .tx(RsTx), .tx_done_tick(done_tick)
    );
    
    interface(
        .clk(CLK100MHz), .reset(Reset),
        .i_data(rx_data), .i_result(i_alu_result), .tx_full_signal(full_signal),.rx_empty_signal(empty_signal), .tx_done_tick(done_tick),
        .op_a(opA), .op_b(opB), .op_code(opCode),
        .o_result(tx_data), .rd_signal(rd), .wr_signal(wr)
    );
    
    alu(
        .dato_a(opA),
        .dato_b(opB),
        .op_code(opCode),
        .o_resultado(i_alu_result)
);
    
endmodule
