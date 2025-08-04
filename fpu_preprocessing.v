// A generic comparator for the FPU that subtracts two numbers and returns the difference
// input is generic, output is generic

module pre_processing 
(
    input [63:0] a,
    input[63:0] b,
    output unsigned [10:0] difference,
    output sign,
    output [52:0] operand_1_mantissa,
    output [52:0] operand_2_mantissa_shifted,
    output operand_1_sign,
    output operand_2_sign,
    output [10:0] biggest_exponent
    );

    wire a_sign;
    wire b_sign;

    wire [51:0] a_mantissa;
    wire [51:0] b_mantissa;

    wire [10:0] a_exponent;
    wire [10:0] b_exponent;

    
    wire [52:0] operand_2_mantissa;
    wire [10:0] exponent_comparator_diff;
    wire exponent_comparator_sign;

//divide sem
    assign a_mantissa = a[51:0];
    assign a_exponent = a[62:52];
    assign a_sign = a[63];
    assign b_mantissa = b[51:0];
    assign b_exponent = b[62:52];
    assign b_sign = b[63];



    // return the absolute value of the difference
    
    assign difference = (a_exponent >= b_exponent) ? a_exponent - b_exponent : b_exponent - a_exponent;
    assign sign = (a_exponent >= b_exponent) ? 1'b0 : 1'b1;
// if a_exponent > b_exponent (comp_sign = 0), then operand_1 = a, operand_2 = b

    // concat 1 to the mantissa to account for the hidden bit
    assign operand_1_mantissa = sign ? {1'b1, b_mantissa} : {1'b1, a_mantissa};
    assign operand_1_sign = sign ? b_sign : a_sign;
    assign operand_2_mantissa = sign ? {1'b1, a_mantissa} : {1'b1, b_mantissa};
    assign operand_2_sign = sign ? a_sign : b_sign;

    // operand 1 is the larger number and operand 2 is the smaller number
    // we need to shift operand 2's mantissa to the right by the difference in exponents


    assign operand_2_mantissa_shifted = operand_2_mantissa >> difference;



    assign biggest_exponent = sign ? b_exponent : a_exponent;

endmodule
