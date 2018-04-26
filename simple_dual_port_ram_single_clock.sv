module simple_dual_port_ram_single_clock
#(
parameter DATA_WIDTH=8, 
parameter ADDR_WIDTH=2
)
(
	input [(DATA_WIDTH-1):0] data,
	input [(ADDR_WIDTH-1):0] read_addr, write_addr,
	input we, clk, //rst,
	output logic [(DATA_WIDTH-1):0] q
);

	// Declare the RAM variable
	logic [DATA_WIDTH-1:0] ram[2**ADDR_WIDTH-1:0];

	always_ff @ (posedge clk)
	begin
		// Write
//		if(rst==1)
//		begin
//			ram <= 0;
//		end
	   /*else */if (we)
			ram[write_addr] <= data;

		// Read (if read_addr == write_addr, return OLD data).	To return
		// NEW data, use = (blocking write) rather than <= (non-blocking write)
		// in the write assignment.	 NOTE: NEW data may require extra bypass
		// logic around the RAM.
		q <= ram[read_addr];
	end

endmodule
