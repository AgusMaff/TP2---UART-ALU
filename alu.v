`timescale 1ns / 1ps

module alu#(
    parameter OPERAND_SIZE = 8,
    parameter OP_CODE_SIZE = 6
)
(
    input signed [OPERAND_SIZE-1:0]dato_a,
    input signed [OPERAND_SIZE-1:0]dato_b,
    input [OP_CODE_SIZE-1:0]op_code,
    output [OPERAND_SIZE-1:0]o_resultado
);
    localparam OP_ADD = 6'b100000;
    localparam OP_SUB = 6'b100010;
    localparam OP_AND = 6'b100100;
    localparam OP_OR = 6'b100101;
    localparam OP_XOR = 6'b100110;
    localparam OP_SRA = 6'b000011;
    localparam OP_SRL = 6'b000010;
    localparam OP_NOR = 6'b100111;
    localparam OP_RESET = 6'b000000;

    reg [OPERAND_SIZE-1:0] resultado = 8'b00000000;
    assign o_resultado=resultado; 
    
    always @(*)
    begin
            case(op_code)
                OP_ADD:
                    resultado = dato_a + dato_b;
                OP_SUB:
                    resultado = dato_a - dato_b;
                OP_AND:
                    resultado = dato_a & dato_b;
                OP_OR:
                    resultado = dato_a | dato_b;
                OP_XOR:
                    resultado = dato_a ^ dato_b;
                OP_SRA:
                    resultado = dato_a >>> 1;
                OP_SRL:
                    resultado = dato_a >> 1;
                OP_NOR:
                    resultado = ~(dato_a | dato_b);
                OP_RESET:
                    resultado = 8'b00000000;
            endcase
    end
endmodule
