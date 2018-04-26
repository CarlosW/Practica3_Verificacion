module Comparator
#(
	parameter word_length = 8
)
(
//inputs
	input [word_length-1:0] value,
	input [word_length-1:0] compare_value,
//Outputs
	output compare_flag
);
//Variables a utilizar
bit flag=0;

always_comb begin
	if (compare_value == value)
		flag = 1'b1;
	else
		flag = 1'b0;
end 
//asignacion de salida
assign compare_flag = flag;

endmodule
