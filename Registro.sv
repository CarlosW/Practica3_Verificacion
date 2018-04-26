module Registro
#(
	parameter word_length = 4
)
(
//inputs
	input reset,
	input clk,
	input enable, 
	input [word_length - 1:0] Data_IN,
//outputs
	output [word_length - 1:0] Data_OUT
);
//Variables a utilizar
logic [word_length - 1:0] FF;
 
always_ff @(posedge clk, negedge reset) begin: ThisIsARegister
	
	if (reset==0)
		FF <= 0;
	else if(enable) 
		FF <= Data_IN;
	else
		FF <= FF;

end: ThisIsARegister
//Asignacion de salida
assign Data_OUT = FF;

endmodule
