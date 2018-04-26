module Tx_Control_Unit
(
	input clk,
	input reset,
	input sendData,
	output bit sendReady,
	output bit SR_TX_load,
	output bit SR_TX_shift
);

enum logic [1:0] {IDLE,LOAD,SEND,READY} state;
 
bit enable_count;
wire countFinished;
wire [3:0]count;


CounterParameter
#(.Maximum_Value(11))
Contador
(
	.clk(clk),
	.reset(reset),
	.enable(enable_count),
	.syncReset(1'b0),
	.Flag(countFinished),
	.Counting(count)
);

always_ff@(posedge clk, negedge reset) begin

	if(reset == 1'b0)
			state <= IDLE;
	else 
		case(state)
			IDLE:
				if(sendData == 1'b1)
					state <= LOAD;	
				else
					state <= IDLE;
			LOAD:
					state <= SEND;
			SEND: 
				if(countFinished == 1'b1)
					state <= READY;	
				else
					state <= SEND;
			READY:
					state <= IDLE;	
				
			default:
					state <= IDLE;	
			endcase
end

always_comb begin
	SR_TX_load = 1'b0;
	sendReady = 1'b0;
	SR_TX_shift =1'b0;
	enable_count = 1'b0;
	case(state)
		IDLE:
			begin
			SR_TX_load = 1'b0;
			sendReady = 1'b1;
			SR_TX_shift =1'b0;
			enable_count = 1'b0;
			end
		LOAD:
			begin
			SR_TX_load = 1'b1;
			sendReady = 1'b0;
			SR_TX_shift =1'b0;
			enable_count = 1'b0;
			end
		SEND:
			begin
			SR_TX_load = 1'b0;
			sendReady = 1'b0;
			SR_TX_shift =1'b1;
			enable_count = 1'b1;
			end
		READY:
			begin
			SR_TX_load = 1'b0;
			sendReady = 1'b1;
			SR_TX_shift =1'b0;
			enable_count = 1'b0;
			end
		default:
			begin

			end
		
	endcase
end


endmodule	