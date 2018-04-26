module Counter
#(
	parameter counter_bits = 4
)
(
//inputs
	input clk,
	input rst,
	input Mas,
	input Menos,
//outputs
	output [counter_bits - 1:0]  Counting
);
//Variables a utilizar
logic [counter_bits - 1:0] contador;

always_ff @(posedge clk, negedge rst) begin: COUNTER
	if (rst==0)
		contador <= 0;
	else if (Mas) 
		contador <= contador + 1'b1;
	else if (Menos)
		contador <= contador - 1'b1;
end: COUNTER
//Asignacion del contador a su variable de salida
assign Counting = contador;

endmodule
