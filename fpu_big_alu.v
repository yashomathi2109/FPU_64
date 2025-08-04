// A generic integer alu that performs arithmetic operations on two numbers (add, subtract)
//`include "csel_64_adder.v"

module fpu_big_alu #(parameter WIDTH=53) (
    input op, // 0: add, 1: subtract
    input [WIDTH-1:0] a,
    input a_sign,
    input [WIDTH-1:0] b,
    input b_sign,
    output wire [WIDTH:0] extended_result,
    output wire result_sign
    );

    // convert to signed
    wire [63:0] temp_a;
    wire [63:0] temp_b;
    // concat zeros to the left of the number
    assign temp_a =  {11'b0 , a};
    assign temp_b = {11'b0 , b};

    wire signed [63:0] a_signed;
    wire signed [63:0] b_signed;
    assign a_signed = a_sign ? -temp_a : temp_a;
    assign b_signed = b_sign ? -temp_b : temp_b;

    wire signed [63:0] b_modified = op ? ~b_signed + 1 : b_signed;


//using csel_adder 64 bit for the addition 
wire signed [63:0] sum_result;

CSelA64 adder_inst (
        .sum(sum_result),
        .cout(cout),
        .a(a_signed),
        .b(b_modified)
    );

    // perform the operation
    wire signed [63:0] result;
    assign result = sum_result;

    // convert back to unsigned
    assign extended_result = result < 0 ? -result : result;
    assign result_sign = result<0;

endmodule
