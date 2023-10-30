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
    input i_clk, i_reset,
    input RsRx,
    output RsTx,
    output [BUS_SIZE-1:0] LED
    );
    
    wire rd_signal;
    wire wr_signal;
    wire [BUS_SIZE-1:0] tx_data;
    wire [BUS_SIZE-1:0] rx_data;
    wire tx_full_signal;
    wire rx_empty_signal;
    
    wire [BUS_SIZE-1:0] op_a;
    wire [BUS_SIZE-1:0] op_b;
    wire [BUS_SIZE-3:0] op_code;
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
        .clk(i_clk), .reset(i_reset),
        .rd_uart(rd_signal), .wr_uart(wr_signal), .rx(RsRx),
        .w_data(tx_data),
        .r_data(rx_data),
        .tx_full(tx_full_signal), .rx_empty(rx_empty_signal), .tx(RsTx)
    );
    
    interface(
        .clk(i_clk), .reset(i_reset),
        .i_data(rx_data), .i_resul(i_alu_result), .tx_full_signal(tx_full_signal),.rx_empty_signal(rx_empty_signal),
        .op_a(op_a), .op_b(op_b), .op_code(op_code),
        .o_result(tx_data), .rd_signal(rd_signal), .wr_signal(wr_signal)
    );
    
    alu_logic(
        .dato_a(op_a),
        .dato_b(op_b),
        .op_code(op_code),
        .o_resultado(i_alu_result)
);
    
endmodule
