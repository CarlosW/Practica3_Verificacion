module Practica3_inicial_TB;

parameter Baud_Rate = 115200;
parameter DATA_LENGTH = 8;

	reg clk=0;
	//wire BaudGen_Out_wire;
	reg reset;
	reg [DATA_LENGTH-1:0]data_to_transmit;
	reg serial_rx;
	reg pop_test;
//	reg Clear_Interrupt;
	reg transmit;
	wire [DATA_LENGTH-1:0]received_data;
//	wire Rx_Interrupt;
	wire serial_tx;
	wire parity_error;



Practica3_inicial

DUT
(
	//.BaudGen_Out_wire(BaudGen_Out_wire),
	.clk(clk),
	.reset(reset),
	.data_to_transmit(data_to_transmit),
	.serial_rx(serial_rx),
	.transmit(transmit),
	.pop_test(pop_test),
	.received_data(received_data),
	.serial_tx(serial_tx),
	.parity_error(parity_error)
);

/*********************************************************/
initial // Clock generator
  begin
    forever #10 clk = !clk;
  end
/*********************************************************/
initial begin // reset generator
	#0 reset = 0;
	#8680 reset = 1;
end

/*********************************************************/
initial begin // enable
	#8680 transmit = 1;
	#8680 pop_test = 0;
	#8680 data_to_transmit = 15;
	#8680 serial_rx = 1;
	#34720 serial_rx = 0;
	
	#8680 serial_rx = 1;
	#8680 serial_rx = 0;
	
	#78120 serial_rx = 1;
	#8680 serial_rx = 0;
	#17360 serial_rx = 1;
	#8680 serial_rx = 0; //2
	
	#69440 serial_rx = 1;
	#8680 serial_rx = 0;	
	#8680 serial_rx = 1;
	#17360 serial_rx = 0; //3

	#69440 serial_rx = 1;
	#8680 serial_rx = 0;	
	#26040 serial_rx = 1;
	#8680 serial_rx = 0; //4
	
	#60760 serial_rx = 1;
	#8680 serial_rx = 0;
	#8680 serial_rx = 1;
	#8680 serial_rx = 0;
	#8680 serial_rx = 1;
	#8680 serial_rx = 0;//5
	
	#60760 serial_rx = 1;
	#8680 serial_rx = 0;
	#17360 serial_rx = 1;
	#8680 serial_rx = 0;
	#8680 serial_rx = 1;
	#8680 serial_rx = 0;//10
	
	//Pop Test
	#60760 pop_test = 1;
	#8680 pop_test = 0;
	
	#8680 pop_test = 1;
	#8680 pop_test = 0;
	
	#8680 pop_test = 1;
	#8680 pop_test = 0;


end



/*********************************************************/


endmodule 