module fpu_dp_sub (

    input [63:0] a,
    input [63:0] b,
    output wire [63:0] result,
    output wire overflow,
    output wire underflow
    );
    wire [1:0] op;
    wire result_sign;
    wire [51:0] result_mantissa;
    wire [10:0] result_exponent;

    wire [10:0] biggest_exponent;
    wire [52:0] operand_1_mantissa;

    wire [52:0] operand_2_mantissa_shifted;
    wire operand_1_sign;
    wire operand_2_sign;

    wire [53:0] mantissa_sum;    

//compare exponents
    pre_processing  exponent_comparator (
       //inputs
        .a(a),
        .b(b),
        //outputs
        .difference(exponent_comparator_diff),
        .sign(exponent_comparator_sign), 
        .operand_1_mantissa(operand_1_mantissa),
        .operand_2_mantissa_shifted(operand_2_mantissa_shifted),
        .operand_1_sign(operand_1_sign),
        .operand_2_sign(operand_2_sign),
        .biggest_exponent(biggest_exponent)
    );


    fpu_big_alu #(.WIDTH(53)) mantissa_adder (
        .op(2'b1),
        .a(operand_1_mantissa),
        .a_sign(operand_1_sign),
        .b(operand_2_mantissa_shifted),
        .b_sign(operand_2_sign),
        .extended_result(mantissa_sum),
        .result_sign(result_sign)
    );


    fpu_normalizer #(.Mantissa_Size(52), .Exponent_Size(11)) mantissa_normalizer (
        .mantissa(mantissa_sum),
        .exponent(biggest_exponent),
        .normalized_mantissa(result_mantissa),
        .normalized_exponent(result_exponent),
        .overflow(overflow),
        .underflow(underflow)
    );

    assign result = {result_sign, result_exponent, result_mantissa};
    
endmodule
