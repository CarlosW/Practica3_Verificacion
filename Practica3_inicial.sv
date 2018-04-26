 ///*synthesis keep*/
module Practica3_inicial
#(
parameter DATA_LENGTH = 8,

	parameter Baud_Rate = 115200,
	parameter word_length = 32,
	parameter Internal_Clock = 25000000
)
(
	input  clk,
	input  reset,
	//Transmisor
	input  transmit,
	input  [DATA_LENGTH-1:0] data_to_transmit,
	output serial_tx,
	//Receptor
	input   serial_rx,
	input	  pop_test,
	output [DATA_LENGTH-1:0] received_data/*synthesis keep*/,
//	output logic rx_interrupt,
//	output logic Baud_clk_shot,
//	output clk_PLL,
	output parity_error
);

wire [DATA_LENGTH-1:0] data_recieved/*synthesis keep*/;
wire data_transmit;
wire rx_to_push;
wire Baud_clk_Wire;

	
//wire clkInter/*synthesis keep*/; 
//
//ClockGenerator	ClockGenerator_inst (
//	.areset ( !reset ),
//	.inclk0 ( clk ),
//	.c0 ( clkInter )
//);
//
//assign clk_PLL = clkInter;
	
UART
UART
(
	.clk(clk),
	.reset(reset),
	.data_to_transmit(data_to_transmit),
	.transmit(transmit),
	.serial_tx(serial_tx),
	.serial_rx(serial_rx),
	.received_data(data_recieved), 
	.parity_error(parity_error),
	.rx_interrupt(rx_to_push)
);

Baud_rate
#(
	.Baud_Rate(Baud_Rate),
	.word_length(word_length),
	.Internal_Clock(Internal_Clock)
)
Baudrate_gen
(
	.clk(clk),
	.reset(reset),
	.enable(1),
	.Counting(Baud_clk_Wire)
);

FIFO1
FIFO
(
	.clk(Baud_clk_Wire),
	.rst(reset),
	.Push(rx_to_push),
	.Pop(pop_test),
	.DataIn(data_recieved),
	.DataOut(received_data)
);

endmodule 