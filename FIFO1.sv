module FIFO1
#(
parameter word_length = 8, 
parameter address_width = 4
)
(
	input clk,
	input rst,
	input Push,
	input Pop,
	input [word_length-1:0] DataIn,
	output [word_length-1:0] DataOut
);
																
/* wires */
logic push_shot_out_wire;
logic pop_shot_out_wire;

logic writeData_wire; 
logic readData_wire;	
logic emptyComp_wire;	
logic fullComp_wire;	
logic [address_width-1:0] writeAddress_wire;
logic [address_width-1:0] readAddress_wire;
logic [address_width:0] N_counter_wire;

logic [word_length-1:0] ramOutput_wire;

logic [word_length-1:0] readMuxToReg_wire;
logic [word_length-1:0] writeDataReg_wire;


/** Contadores que nos dicen las posiciones de los numeros de llegada de la Fifo **/

Counter
#(
	.counter_bits(address_width)
)
WriteAddressCounter
(
	// inputs
	.clk(clk),
	.rst(rst),
	.Mas(writeData_wire),
	.Menos(1'b0),
	// outputs
	.Counting(writeAddress_wire)
);

Counter
#(
	.counter_bits(address_width)
)
ReadAddressCounter
(
	// inputs
	.clk(clk),
	.rst(rst),
	.Mas(readData_wire),
	.Menos(1'b0),
	// outputs
	.Counting(readAddress_wire)
);

Counter
#(
	.counter_bits(address_width+1'b1)
)
N_Counter
(
	// inputs
	.clk(clk),
	.rst(rst),
	.Mas(writeData_wire),
	.Menos(readData_wire),
	// outputs
	.Counting(N_counter_wire)
);

/** Comparadores para verificar si la Fifo esta llena o vacia **/

Comparator
#(
	.word_length(address_width+1'b1)
)
EmptyComparator
(
	// inputs
	.value(N_counter_wire),
	.compare_value(1'b0),
	//outputs
	.compare_flag(emptyComp_wire)
);

Comparator
#(
	.word_length(address_width+1'b1)
)
FullComparator
(
	// inputs
	.value(N_counter_wire),
	.compare_value((2**address_width)),
	//outputs
	.compare_flag(fullComp_wire)
);



/** Memoria Ram donde la fifo guarda las datos **/

simple_dual_port_ram_single_clock
#(
	.DATA_WIDTH(word_length), 
	.ADDR_WIDTH(address_width)
)
RAM
(
	// inputs
	.data(DataIn),
	.read_addr(readAddress_wire), 
	.write_addr(writeAddress_wire),
	.we(writeData_wire), 
	.clk(clk),

	//outputs
	.q(ramOutput_wire)
);

/** Registro donde se verifica que llego un enable sale el dato Registrado **/
Registro
#(
	.word_length(word_length)
)
Output_Register
(
	.reset(rst),
	.clk(clk),
	.enable(readData_wire), 
	.Data_IN(ramOutput_wire/*readMuxToReg_wire*/),
	.Data_OUT(DataOut)
);
//Asignacion de Write data si  fue hecho un push y la bandera de full esta desactivada
//de Read Data si fue hecho un pop y la bandera de empty esta vacia
assign writeData_wire =  Push && ~fullComp_wire;
assign readData_wire =  Pop && ~emptyComp_wire;

endmodule
