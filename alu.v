`timescale 1ns / 1ps

module alu_logic#(
    parameter OPERAND_SIZE = 8
)
(
    input [OPERAND_SIZE-1:0]dato_a,
    input [OPERAND_SIZE-1:0]dato_b,
    input [OP_CODE_SIZE-1:0]op_code,
    output [OPERAND_SIZE-1:0]o_resultado
);
    localparam OP_ADD = 8'b00100000;
    localparam OP_SUB = 8'b00100010;
    localparam OP_AND = 8'b00100100;
    localparam OP_OR = 8'b00100101;
    localparam OP_XOR = 8'b00100110;
    localparam OP_SRA = 8'b00000011;
    localparam OP_SRL = 8'b00000010;
    localparam OP_NOR = 8'b00100111;
    localparam OP_RESET = 8'b00000000;

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
                    resultado = dato_a >> 1;
                OP_SRL:
                    resultado = dato_a >>> 1;
                OP_NOR:
                    resultado = ~(dato_a | dato_b);
                OP_RESET:
                    resultado = 8'b00000000;
            endcase
    end
endmodule
