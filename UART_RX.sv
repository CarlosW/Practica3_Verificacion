
module UART_RX

(
input   serial_rx,
input   clk,
input   reset,
output [7:0] received_data,
output logic rx_interrupt/*synthesis keep*/,
output parity_error
);

logic rx_interrupt_log;
logic [7:0]  rx_register;
logic serial_rx_log;
logic parity=1'b0;
logic [3:0] count=4'b0;

assign serial_rx_log=serial_rx;


always_ff @(posedge clk, negedge reset)
	begin
		if(reset==0)
			begin
			rx_register<={8{1'b0}};
			rx_interrupt_log=1'b0;
			end
		else
			begin
			if(count >= 1)
				begin
				if(count<=8)
					begin					
					rx_register={serial_rx_log,rx_register[7:1]};
					count=count+1'b1;
					end
				else if(count==9)
					begin
					parity = serial_rx_log&(~(^rx_register));
					count=count+1'b1;
					rx_interrupt_log=1'b1;
					end				
				else if(count==10) begin				
					count=0;
					rx_interrupt_log=1'b0;
					end
				end
			else if(serial_rx_log==1'b0) 	
				count = 1;									
			end
	end
	
assign parity_error = parity;
assign received_data = rx_register;
assign rx_interrupt = rx_interrupt_log;

endmodule
