module ParkingFSM (
    input  wire       clk,             // Clock signal
    input  wire [3:0] in,              // 4-bit input: {EnterSensor, ExitSensor, ExitPlace[1:0]}
    output reg  [3:0] state,           // 4-bit state representing the parking spots
    output reg        door_open_pulse  // Pulse for door open LED
);

  // Internal signal for previous state to detect state changes
  reg [3:0] prev_state;

  // Initialization
  initial begin
    state           = 4'b0000;  // Initial state: all parking spots empty
    door_open_pulse = 1'b0;  // Door open LED initially off
    prev_state      = 4'b0000;  // Initial previous state
  end

  always @(posedge clk) begin
    // Save the current state to detect state changes
    prev_state <= state;

    case (in[3:2])  // Check the input format
      2'b10: begin  // Enter sensor triggered, Exit sensor not triggered
        if (state != 4'b1111) begin  // Parking not full
          // Find the first empty parking spot (rightmost 0 becomes 1)
          case (state)
            4'b0000: state <= 4'b0001;
            4'b0001: state <= 4'b0011;
            4'b0010: state <= 4'b0011;
            4'b0011: state <= 4'b0111;
            4'b0100: state <= 4'b0101;
            4'b0101: state <= 4'b0111;
            4'b0110: state <= 4'b0111;
            4'b0111: state <= 4'b1111;
            4'b1000: state <= 4'b1001;
            4'b1001: state <= 4'b1011;
            4'b1010: state <= 4'b1011;
            4'b1011: state <= 4'b1111;
            4'b1100: state <= 4'b1101;
            4'b1101: state <= 4'b1111;
            4'b1110: state <= 4'b1111;
            default: state <= state;  // Default to current state
          endcase
        end
      end

      2'b01: begin  // Exit sensor triggered, Enter sensor not triggered
        // Check the exit place validity and remove the car
        case (in[1:0])  // ExitPlace
          2'b00:   if (state[0]) state <= state & 4'b1110;  // Exit from spot 0
          2'b01:   if (state[1]) state <= state & 4'b1101;  // Exit from spot 1
          2'b10:   if (state[2]) state <= state & 4'b1011;  // Exit from spot 2
          2'b11:   if (state[3]) state <= state & 4'b0111;  // Exit from spot 3
          default: state <= state;  // Invalid exit place, keep current state
        endcase
      end

      default: state <= state;  // No valid input, keep current state
    endcase

    // Generate a pulse for door_open_pulse when state changes
    if (state != prev_state) begin
      door_open_pulse <= 1'b1;
    end else begin
      door_open_pulse <= 1'b0;
    end
  end

endmodule
