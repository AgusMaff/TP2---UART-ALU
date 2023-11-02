`timescale 1ns / 1ps

module interface
#(
    parameter BUS_SIZE = 8
              
)
(
    input clk, i_reset,
    //input [BUS_SIZE-1:0] i_data,
    //input [BUS_SIZE-1:0] i_resul,
    input tx_full_signal,
    input rx_empty_signal,
    input tx_done_tick,
    //output [BUS_SIZE-1:0] opA,
    //output [BUS_SIZE-1:0] opB,
    //output [BUS_SIZE-3:0] opCode,
    //output [BUS_SIZE-1:0] o_result,
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
    reg [4:0] f;
    reg [4:0] f_next;
    
    reg [1:0]state_next;
    reg [1:0]state_inter;
    
    //assign o_result = i_resul;
    assign rd_signal = rd;
    assign wr_signal = wr;
    assign flags = f;
   
    initial begin
        state_next = WAITING;
    end
    
    always @(posedge clk, posedge i_reset)
        if(i_reset)
            begin
                state_inter = WAITING;
                rd <= 1'b0;
                wr <= 1'b0;
                f <= 5'b00000;
                
            end
        else
            begin
                state_inter <= state_next;
                f <= f_next;
            end
            
    always @(*)    
        begin
        state_next = state_inter;
        f = f_next;
            case(state_inter)
                WAITING:
                    begin
                        f_next = 5'b00001;
                        if(~rx_empty_signal)
                            begin
                                f_next = 5'b00010;
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
                            //a_reg = i_data;
                            f_next = 5'b00100;
                            state_next = B;
                        end
                    end
                B:
                    begin
                    if(~rx_empty_signal)
                        begin
                            rd = 1'b1;
                            //b_reg = i_data;
                            f_next = 5'b01000;
                            state_next = OP;
                        end
                    end
                OP:
                    begin
                        if(~rx_empty_signal)
                            begin
                                rd = 1'b1;
                                //op_reg = i_data;
                                f_next = 5'b10000;
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
                                f_next = 5'b00001;
                                state_next = WAITING;
                                wr = 1'b0;
                            end 
                    end                                                                                                                                                    
            endcase
        end
endmodule