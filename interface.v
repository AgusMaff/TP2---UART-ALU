`timescale 1ns / 1ps

module interface
#(
    parameter BUS_SIZE = 8
              
)
(
    input clk, reset,
    input [BUS_SIZE-1:0] i_data,
    input [BUS_SIZE-1:0] i_resul,
    input tx_full_signal,
    input rx_empty_signal,
    output [BUS_SIZE-1:0] opA,
    output [BUS_SIZE-1:0] opB,
    output [BUS_SIZE-3:0] opCode,
    output [BUS_SIZE-1:0] o_result,
    output rd_signal,
    output wr_signal
);
    localparam [1:0]
        WAITING = 2'b00,
        OP_A = 2'b01,
        OP_B = 2'b10,
        OP_CODE = 2'b11;
    
    reg rd;
    reg wr;    
    reg [BUS_SIZE-1:0] alu_result;
    reg [BUS_SIZE-1:0] a;
    reg [BUS_SIZE-1:0] b;
    reg [BUS_SIZE-3:0] op;
    
    reg [1:0]state_next;
    reg [1:0]state_inter;
    
    assign o_result = i_resul;
    assign rd_signal = rd;
    assign wr_signal = wr;
    assign opA = a;
    assign opB = b;
    assign opCode = op;
    
    always @(posedge clk, posedge reset)
        if(reset)
            begin
                state_inter = WAITING;
                rd <= 1'b0;
                wr <= 1'b0;
                a <= 8'b00000000;
                b <= 8'b00000000;
                op <= 6'b000000;
                
            end
        else
            begin
                state_inter <= state_next;
            end
            
    always @(*)    
        begin
        wr = 1'b0;
            case(state_inter)
                WAITING:
                    begin
                        if(~rx_empty_signal)
                            begin
                                state_next = OP_A;
                                rd = 1'b1;
                            end
                        else
                             rd = 1'b0;
 
                    end
                OP_A:
                    begin
                        a = i_data;
                        state_next = OP_B;
                    end
                OP_B:
                    begin
                        b = i_data;
                        state_next = OP_CODE;
                    end
                OP_CODE:
                    begin
                        if(~tx_full_signal)
                            begin
                                rd = 1'b0;                           
                                wr = 1'b1;
                                op = i_data;
                            end                   
                        state_next = WAITING;                                                                   
                    end
            endcase
        end
endmodule
