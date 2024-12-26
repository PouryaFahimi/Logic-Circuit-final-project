module FSM (
    input  wire       clk,             // Clock signal
    input  wire [3:0] in,              // 4-bit input: {EnterSensor, ExitSensor, ExitPlace[1:0]}
    output reg  [3:0] state,           // 4-bit state representing the parking spots
    output reg        door_open_pulse  // Pulse for door open LED
);

  // Initialization
  initial begin
    state           = 4'b0000;  // Initial state: all parking spots empty
    door_open_pulse = 1'b0;     // Door open LED initially off
  end

reg [3:0] next_state; // Internal signal to store the next state

  always @(posedge clk) begin
    next_state = state;   // Default next state is the current state

    case (in[3:2])  // Check the input format
      2'b10: begin  // Enter sensor triggered, Exit sensor not triggered
        if (state != 4'b1111) begin  // Parking not full
          // Find the first empty parking spot (rightmost 0 becomes 1)
          case (state)
            4'b0000: next_state = 4'b0001;
            4'b0001: next_state = 4'b0011;
            4'b0010: next_state = 4'b0011;
            4'b0011: next_state = 4'b0111;
            4'b0100: next_state = 4'b0101;
            4'b0101: next_state = 4'b0111;
            4'b0110: next_state = 4'b0111;
            4'b0111: next_state = 4'b1111;
            4'b1000: next_state = 4'b1001;
            4'b1001: next_state = 4'b1011;
            4'b1010: next_state = 4'b1011;
            4'b1011: next_state = 4'b1111;
            4'b1100: next_state = 4'b1101;
            4'b1101: next_state = 4'b1111;
            4'b1110: next_state = 4'b1111;
            default: next_state = state; // Default to current state
          endcase
        end
      end

      2'b01: begin  // Exit sensor triggered, Enter sensor not triggered
        // Check the exit place validity and remove the car
        case (in[1:0])  // ExitPlace
          2'b00: if (state[0]) next_state = state & 4'b1110;  // Exit from spot 0
          2'b01: if (state[1]) next_state = state & 4'b1101;  // Exit from spot 1
          2'b10: if (state[2]) next_state = state & 4'b1011;  // Exit from spot 2
          2'b11: if (state[3]) next_state = state & 4'b0111;  // Exit from spot 3
          default: next_state = state; // Invalid exit place, keep current state
        endcase
      end

      default: next_state = state; // No valid input, keep current state
    endcase

    // Update the state at each clock cycle
    if (state != next_state) begin
      door_open_pulse <= 1'b1; // Generate the pulse
    end else begin
      door_open_pulse <= 1'b0; // No state change, no pulse
    end
    
    state <= next_state; // Assign the next state to the current state
  end
endmodule
