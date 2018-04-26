 ///*synthesis keep*/
module UART 
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
	output [DATA_LENGTH-1:0] received_data,
	output logic rx_interrupt,
//	output logic Baud_clk_shot,
	output parity_error
//	output tx_busy
	//	output clk_PLL
);

logic Baud_clk_Wire/*synthesis keep*/;
wire rx_Interrupt_Shot_w/*synthesis keep*/;
wire Shot_to_Tx/*synthesis keep*/;
wire TX_load_wire;
wire TX_shift_wire;

//assign BaudRate=Baud_clk_Wire;
//assign clk_output=clk;
	
wire clkInter/*synthesis keep*/; 

//ClockGenerator	ClockGenerator_inst (
//	.areset ( !reset ),
//	.inclk0 ( clk ),
//	.c0 ( clkInter )
//);

//assign clk_PLL = clkInter;
	
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
	

//One_Shot
//Baudrate_Shot
//(
//	.clk(clk),
//	.reset(rst),
//	.Start(Baud_clk_Wire),
//	
//	.Shot(rx_interrupt)
//);

	
UART_RX
Receiver
(
	.serial_rx(serial_rx),
	.clk(Baud_clk_Wire),
	.reset(reset),
	.received_data(received_data),
	.rx_interrupt(rx_interrupt),
	.parity_error(parity_error)
);


One_Shot
Tx_Shot_button
(
	.clk(Baud_clk_Wire),
	.reset(reset),
	.Start(transmit),
	
	.Shot(Shot_to_Tx)
);

Tx_Control_Unit
Transmitter
(
	.clk(Baud_clk_Wire),
	.reset(reset),
	.sendData(Shot_to_Tx),
	.sendReady(),
	.SR_TX_load(TX_load_wire),
	.SR_TX_shift(TX_shift_wire)
);
	
ShiftRegister
#(.WORD_LENGTH(11))
Shift_Tx
(
	.clk(Baud_clk_Wire),
	.reset(reset),	//Activo en bajo	
	.load(TX_load_wire),	//Activo en alto
	.shift(TX_shift_wire),	//Shift activo en alto
	.Parallel_in({1'b1,1'b1,data_to_transmit,1'b0}),
	.Serial_in(1'b1),
	.Right(1'b1), //corrimiento hacia la derecha (1).
	.SyncReset(1'b0),
	.Parallel_Out(serial_tx)
);

	
endmodule
	