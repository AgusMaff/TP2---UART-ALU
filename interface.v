`timescale 1ns / 1ps

module interface
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
    output [BUS_SIZE-1:0] o_result
);
    localparam [1:0]
        WAITING = 2'b00,
        OP_A = 2'b00,
        OP_B = 2'b00,
        OP_CODE = 2'b00;


    reg rd_signal;
    reg wr_signal;
    reg tx_full_signal;
    reg rx_empty_signal;
    reg [BUS_SIZE-1:0] rx_data;
    reg [BUS_SIZE-1:0] tx_data;
    reg signed [BUS_SIZE-1:0] op_a;
    reg signed [BUS_SIZE-1:0] op_b;
    reg [BUS_SIZE-3:0] op_code;
    reg [BUS_SIZE-1:0] alu_result;
    
    reg [1:0]state_next;
    reg [1:0]state_inter;
    

    always @(posedge i_clk, posedge i_reset)
        if(i_reset)
            begin
                state_inter = WAITING;
                rd_signal <= 1'b0;
                wr_signal <= 1'b0;
                op_a <= 8'b00000000;
                op_b <= 8'b00000000;
                op_code <= 6'b000000;
            end
        else
            begin
                state_inter <= state_next;
            end
            
    always @(*)    
        begin
            case(state_inter)
                WAITING:
                    begin
                        if(~rx_empty_signal)
                            begin
                                state_next = OP_A;
                                rd_signal = 1'b1;
                            end
                        else
                             rd_signal = 1'b0;
 
                    end
                OP_A:
                    begin
                        op_a = rx_data;
                        state_next = OP_B;
                    end
                OP_B:
                    begin
                        op_b = rx_data;
                        state_next = OP_CODE;
                    end
                OP_CODE:
                    begin
                        wr_signal = 1'b0;
                        if(~tx_full_signal)                           
                            wr_signal = 1'b1;
                        op_code = rx_data;
                        tx_data = alu_result;
                        state_next = WAITING;                                                                   
                    end
            endcase
        end
                           
uart_core(
    .clk(i_clk),
    .reset(i_reset),
    .rd_uart(rd_signal),
    .wr_uart(wr_signal),
    .rx(RsRx),
    .w_data(tx_data),
    .r_data(rx_data),
    .tx_full(tx_full_signal),
    .rx_empty(rx_empty_signal),
    .tx(RsTx)
);

alu_logic(
    .dato_a(op_a),
    .dato_b(op_b),
    .op_code(op_code),
    .o_resultado(alu_result)
);
endmodule
