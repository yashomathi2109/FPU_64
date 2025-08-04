module fpu_dp_mult #(parameter WIDTH=64) (
input [WIDTH-1:0] A,
input [WIDTH-1:0] B,
output wire [WIDTH-1:0] result,
output wire overflow,
output wire underflow
);

wire a_sign,b_sign,result_sign,zero;
wire [52:0] a_mantissa,b_mantissa;
wire [51:0] result_mantissa;
wire [105:0] temp_mantissa;
wire [10:0] a_exponent,b_exponent;
wire [11:0] temp_exponent,result_exponent;

assign a_exponent=A[62:52];
assign a_sign=A[63];

assign b_exponent=B[62:52];
assign b_sign=B[63];

 //Normal Operation
 
 // XOR of Sign Bit
 assign result_sign=a_sign^b_sign;
 //If Exponent = 0, first bit = 0 
 assign a_mantissa=(|a_exponent) ? {1'b1,A[51:0]} : {1'b0,A[51:0]};
 assign b_mantissa=(|b_exponent) ? {1'b1,B[51:0]} : {1'b0,B[51:0]};
 //Product of Mantissas
 assign temp_mantissa=a_mantissa*b_mantissa; 
 //Normalization
 assign result_mantissa=temp_mantissa[105] ? temp_mantissa[104:53] : temp_mantissa[103:52];

 //Check for zero Mantissa
 assign zero = (result_mantissa==52'd0) ?1'b1:1'b0;
 //Exponent
 assign temp_exponent=a_exponent+b_exponent-1023;
 assign result_exponent= temp_mantissa[105] ? temp_exponent+1'b1 :temp_exponent;
 
 //OverFlow & UnderFlow
 assign overflow = ((result_exponent[11] & !result_exponent[10]) &!zero) ? 1'b1:1'b0;
 assign underflow= ((result_exponent[11] & result_exponent[10]) &!zero)  ? 1'b1:1'b0;
 //Result
 assign result = overflow ? {result_sign,11'b11111111111,52'd0} 
 : underflow ? {result_sign,63'd0} : {result_sign,result_exponent[10:0],result_mantissa};

endmodule 
