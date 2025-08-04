

module float_top(input		[1:0]	opcode,
		input		[63:0]	A, B,
		output			carry, zero,
		output	reg	[63:0]	Y
		);


//using 64x64 floating point adder instead of integer addition 
wire [63:0] fadd_result;
wire overflow1;
wire underflow1;

fpu_dp_adder float_adder_unit(
    .a(A), 
    .b(B),
    .result(fadd_result),
    .overflow(overflow1),
    .underflow(underflow1)

);

wire [63:0] fsub_result;
wire overflow2;
wire underflow2;

fpu_dp_sub float_sub_unit(
    .a(A), 
    .b(B),
    .result(fsub_result),
    .overflow(overflow2),
    .underflow(underflow2)

);


wire [63:0] fmult_result;
wire overflow3;
wire underflow3;

// Instantiate the module
fpu_dp_mult #(.WIDTH(64)) float_mult_unit (
    .A(A),
    .B(B),
    .result(fmult_result),
    .overflow(overflow3),
    .underflow(underflow3)
);

wire [63:0] fdiv_result;
wire overflow4;
wire underflow4;

// Instantiate the module
fpu_dp_divider #(.WIDTH(64)) float_div_unit (
    .A(A),
    .B(B),
    .result(fdiv_result),
    .overflow(overflow4),
    .underflow(underflow4)
);



localparam	add = 2'b00,		sub = 2'b01,
		mul = 2'b10,		div = 2'b11;



always @ (*) begin
	case(opcode)
		//Bitwise operations
		//add:	{adder_out, Y} = A + B;
                add:	Y = fadd_result;
		sub: 	Y = fsub_result;
		
                // Multiplication using Dadda
                mul:   Y = fmult_result;  // Lower 32 bits


		//Division and remainder:
		div:	Y = fdiv_result;
		//rem:	Y = A%B;


		default: Y = 64'd0;
	endcase
end

endmodule
