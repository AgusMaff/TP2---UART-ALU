`timescale 1ns / 1ps

module baud_generator
    #(
        parameter N = 9,  //bit necesarios para la cuenta
                  M = 163 //valoe maximo hasta el cual voy a contar
    )
    (
        input clk, reset,
        output max_tick, 
        output [N-1:0] q     
    );
    
    reg [N-1:0] r_reg;
    wire [N-1:0] r_next;
    
    assign r_next = (r_reg == (M-1)) ? 0 : r_reg + 1;
    
    assign q = r_reg;
    assign max_tick = (r_reg == (M-1)) ? 1'b1 : 1'b0;
    
    always @(posedge clk, posedge reset)
        if (reset)
            r_reg <= 0;
        else
            r_reg <= r_next;
endmodule
