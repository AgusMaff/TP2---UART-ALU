`timescale 1ns / 1ps

module interface
#(
    parameter BUS_SIZE = 8
              
)
(
    input clk, reset,
    input [BUS_SIZE-1:0] i_data,
    input [BUS_SIZE-1:0] i_result,
    input tx_full_signal,
    input rx_empty_signal,
    input tx_done_tick,
    output [BUS_SIZE-1:0] op_a,
    output [BUS_SIZE-1:0] op_b,
    output [BUS_SIZE-3:0] op_code,
    output [BUS_SIZE-1:0] o_result,
    output rd_signal,
    output wr_signal
);
    localparam [2:0]
        WAITING = 3'b000,
        A = 3'b001,
        B = 3'b010,
        OP = 3'b011,
        SENDING = 3'b100;
    
    reg rd;
    reg wr;    
    reg [BUS_SIZE-1:0] alu_result;
    reg [BUS_SIZE-1:0] a_reg;
    reg [BUS_SIZE-1:0] b_reg;
    reg [BUS_SIZE-3:0] op_reg;
    
    reg [1:0]state_next;
    reg [1:0]state_inter;
    
    assign o_result = alu_result;
    assign rd_signal = rd;
    assign wr_signal = wr;
    assign op_a = a_reg;
    assign op_b = b_reg;
    assign op_code = op_reg;
    
    
    initial begin
        state_inter = WAITING;
    end
    
    always @(posedge clk, posedge reset)
        if(reset)
            begin
                state_inter = WAITING;
                rd <= 1'b0;
                wr <= 1'b0;
                a_reg <= 8'b00000000;
                b_reg <= 8'b00000000;
                op_reg <= 6'b000000;
                
            end
        else
            begin
                state_inter <= state_next;
            end
            
    always @(*)    
        begin
        state_next = state_inter;
            case(state_inter)
                WAITING:
                    begin
                        if(~rx_empty_signal)
                            begin
                                state_next = A;
                                rd = 1'b1;
                            end
                        else
                             rd = 1'b0;
 
                    end
                A:
                    if(~rx_empty_signal)
                        begin
                            rd = 1'b1;
                            a_reg = i_data;
                            state_next = B;
                        end
                B:
                    if(~rx_empty_signal)
                        begin
                            rd = 1'b1;
                            b_reg = i_data;
                            state_next = OP;
                        end
                OP:
                    begin
                        if(~rx_empty_signal)
                            begin
                                rd = 1'b1;
                                op_reg = i_data;
                                state_next = SENDING;                       
                            end               
                    end
                SENDING:
                    begin
                        if(~tx_full_signal)
                            begin
                                rd = 1'b0;                           
                                wr = 1'b1;
                                alu_result = i_result;
                            end
                    
                        if(tx_done_tick)
                            begin
                                state_next = WAITING;
                                wr = 1'b0;
                            end 
                    end                                                                                                                                                    
            endcase
        end
endmodule
