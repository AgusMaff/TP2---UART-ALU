`timescale 1ns / 1ps

module interface
#(
    parameter BUS_SIZE = 8
              
)
(
    input clk, i_reset,
    input [BUS_SIZE-1:0] i_data,
    input [BUS_SIZE-1:0] i_resul,
    input tx_full_signal,
    input rx_empty_signal,
    input tx_done_tick,
    output [BUS_SIZE-1:0] opA,
    output [BUS_SIZE-1:0] opB,
    output [BUS_SIZE-3:0] opCode,
    output [BUS_SIZE-1:0] o_result,
    output [4:0] flags,
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
    //reg [BUS_SIZE-1:0] alu_result;
    reg [BUS_SIZE-1:0] op_a;
    reg [BUS_SIZE-1:0] op_b;
    reg [BUS_SIZE-3:0] op_code;
    
    reg [1:0]state_next;
    reg [1:0]state_inter;
    
    assign o_result = i_resul;
    assign rd_signal = rd;
    assign wr_signal = wr;
    assign opA = op_a;
    assign opA = op_b;
    assign opA = op_code;
   
    initial begin
        state_next = WAITING;
    end
    
    always @(posedge clk, posedge i_reset)
        if(i_reset)
            begin
                state_inter = WAITING;
                rd <= 1'b0;
                wr <= 1'b0;
                op_a <= 8'b00000000;
                op_b <= 8'b00000000;
                op_code <= 6'b0000000;
                
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
                   begin
                    if(~rx_empty_signal)
                        begin
                            rd = 1'b1;
                            op_a = i_data;
                            state_next = B;
                        end
                    end
                B:
                    begin
                    if(~rx_empty_signal)
                        begin
                            rd = 1'b1;
                            op_b = i_data;
                            state_next = OP;
                        end
                    end
                OP:
                    begin
                        if(~rx_empty_signal)
                            begin
                                rd = 1'b1;
                                op_code = i_data;                              
                                state_next = SENDING;                       
                            end               
                    end
                SENDING:
                    begin
                        if(~tx_full_signal)
                            begin
                                rd = 1'b0;                           
                                wr = 1'b1;
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