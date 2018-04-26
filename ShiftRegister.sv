module ShiftRegister
#(parameter WORD_LENGTH = 8)
(
	input clk,
	input reset,	//Activo en bajo	
	input load,	//Activo en alto
	input shift,	//Shift activo en alto
	input [WORD_LENGTH-1:0] Parallel_in,
	input Serial_in,
	input Right, //corrimiento hacia la derecha (1).
	input SyncReset,
	output [WORD_LENGTH-1:0] Parallel_Out
);

logic  [WORD_LENGTH-1:0] Data_logic;	

always_ff@(posedge clk or negedge reset ) begin: ThisIsARegister	

	if(reset == 1'b0) 
		Data_logic <= {WORD_LENGTH{1'b0}};
	else
		
		if (SyncReset == 1'b1)
			Data_logic <= {WORD_LENGTH{1'b0}};
		else if(load == 1'b1 ) 
				Data_logic <= Parallel_in;	
		else if(shift == 1'b1 && Right == 1'b0)
			Data_logic <= {Data_logic[WORD_LENGTH-2:0],Serial_in};
		else if(shift == 1'b1 && Right == 1'b1)
			Data_logic <= {Serial_in,Data_logic[WORD_LENGTH-1:1]};
			
end: ThisIsARegister	

assign Parallel_Out = Data_logic;	

endmodule