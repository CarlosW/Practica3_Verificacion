module Baud_rate
#(
	parameter Baud_Rate = 115200,
	parameter word_length = 32,
	parameter Internal_Clock = 25000000
	
)
(
input clk,
input reset,
input enable,
output logic Counting
);

localparam Max_Count=(Internal_Clock/Baud_Rate);
//Reloj 50 Mhz
logic [word_length-1 : 0] Counting_reg = 0;
logic flag = 0;

always_ff@(posedge clk or negedge reset) begin: ThisIsACounter
	if (reset == 1'b0)
		Counting_reg <= {word_length{1'b0}};
	else 
	begin	
		if(enable == 1'b1)
		begin
				if(Counting_reg == Max_Count)
				begin
				flag <= ~flag;
				Counting_reg <= {word_length{1'b0}};
				end
				else
				Counting_reg <= Counting_reg + 1'b1;
		end
		else
		Counting_reg <= Counting_reg;
	end	
end: ThisIsACounter

assign Counting = flag;
endmodule
