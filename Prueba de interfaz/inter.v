`timescale 1ns / 1ps

module interface
#(
    parameter BUS_SIZE = 8
              
)
(
    input clk, i_reset,
    input [BUS_SIZE-1:0] i_data,
    input [BUS_SIZE-1:0] i_result,
    input tx_full_signal,
    input rx_empty_signal,
    input tx_done_tick,
    output [BUS_SIZE-1:0] opA,
    output [BUS_SIZE-1:0] opB,
    output [BUS_SIZE-3:0] opCode,
    output [BUS_SIZE-1:0] o_result
);

    localparam [2:0]
        WAITING = 3'b000,
        A = 3'b001,
        B = 3'b010,
        OP = 3'b011,
        SENDING = 3'b100;
       
    reg [BUS_SIZE-1:0] alu_result;
    reg [BUS_SIZE-1:0] a_reg;
    reg [BUS_SIZE-1:0] b_reg;
    reg [BUS_SIZE-3:0] op_reg;
    
    reg [2:0]state_next;
    reg [2:0]state_inter;
    
    assign o_result = alu_result;
    assign opA = a_reg;
    assign opB = b_reg;
    assign opCode = op_reg;
 
    initial begin
        state_inter = WAITING;
    end
    
    always @(posedge clk, posedge i_reset)
        if(i_reset)
            begin
                state_inter <= WAITING;
                
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
                            end
                    end
                A:
                   begin
                    if(~rx_empty_signal)
                        begin
                            a_reg = i_data;
                            state_next = B;
                        end
                    end
                B:
                    begin
                    if(~rx_empty_signal)
                        begin
                            b_reg = i_data;
                            state_next = OP;
                        end
                    end
                OP:
                    begin
                        if(~rx_empty_signal)
                            begin
                                op_reg = i_data;
                                state_next = SENDING;                       
                            end               
                    end
                SENDING:
                    begin
                        if(~tx_full_signal)
                            begin
                                alu_result = i_result;
                            end                   
                        if(tx_done_tick)
                            begin
                                state_next = WAITING;
                            end 
                    end                                                                                                                                                    
            endcase
        end
endmodule
