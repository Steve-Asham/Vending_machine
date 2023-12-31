module vending_machine 
(
//Defining inputs and outputs of FSM
input wire clk,rst,
input wire five, ten, tf, //input coins
output reg vend, // output i a soft drink will be given or not
output reg [2:0] change //change given from machine with the 3-bits representing 20 10 5
);
// Declaring States as parameters
 localparam [2:0] IDLE=3'b000,
		  FIVE=3'b001,
		  TEN=3'b010,
		  FIFTEEN=3'b011,
		  TWENTY=3'b100,
		  TWENTY_FIVE=3'b101;
// Defining states as reg
 reg [2:0] state_reg, state_next, rem;
 // Reset machine state to IDLE, vend & change to none
 always @ (posedge clk)
	if(rst) begin
		state_reg <= IDLE;
		vend <= 1'b0;
		change <= 3'b000;
	end
	else state_reg <= state_next;
	
//always block for determining next state and calculating change in each of the 6 states
 always @ * begin
	state_next = IDLE ;
	case (state_reg)
	    IDLE:
		 if(five) state_next = FIVE;
		 else if (ten) state_next = TEN;
		 else if (tf) state_next = TWENTY_FIVE;
	     else state_next = IDLE;
	    FIVE:
		 if(five) state_next = TEN;
		 else if(ten) state_next = FIFTEEN;
		 else if(tf) begin
			state_next = TWENTY_FIVE;
			rem = 3'b001;
			end
		 else state_next = FIVE;
	    TEN:
		 if(five) state_next = FIFTEEN;
		 else if(ten) state_next = TWENTY;
		 else if(tf) begin
			state_next = TWENTY_FIVE;
			rem = 3'b010;
			end
		 else state_next = TEN;
	    FIFTEEN:
		 if(five) state_next = TWENTY;
		 else if(ten) state_next = TWENTY_FIVE;
		 else if (tf) begin
			state_next = TWENTY_FIVE;
			rem = 3'b011;
			end
		 else state_next = FIFTEEN;
	    TWENTY: 
		 if (five) state_next = TWENTY_FIVE;
		 else if (ten) begin
			state_next = TWENTY_FIVE;
			rem = 3'b001;
			end
		 else if (tf) begin
			state_next = TWENTY_FIVE;
			rem = 3'b100;
			end
		else state_next = TWENTY;
	    TWENTY_FIVE: 
			state_next = IDLE;
		default: state_next = IDLE;
    endcase
   end
   
 // Mealy output of the FSM (vend & change)
 always @(posedge clk) begin
	case (state_next)
		IDLE, FIVE, TEN, FIFTEEN, TWENTY : begin
			vend <= 1'b0;
			change <= 3'b000;
		end
		TWENTY_FIVE : begin
		vend <= 1'b1;
		change <= rem;
		end
    endcase
   end    
endmodule
