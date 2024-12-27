module Full_Light (
    input [3:0] fsm_state,     // 4-bit FSM state
    input enter_sensor,  // Enter sensor signal
    input exit_sensor,   // Exit sensor signal
    input clk,  // Clock signal for edge detection
    output reg pulse  // Output pulse
);

  // Internal register to detect the posedge of enter_sensor
  reg enter_sensor_prev;

  // Initialize outputs and internal signals
  initial begin
    pulse = 0;
    enter_sensor_prev = 0;
  end

  always @(posedge clk) begin
    // Edge detection and pulse generation
    if ((fsm_state == 4'b1111) &&  // FSM state is 15 (full parking lot)
        (exit_sensor == 0) &&  // Exit sensor is not active
        (enter_sensor == 1) &&  // Enter sensor is active
        (enter_sensor_prev == 0)) begin  // Detect rising edge of enter_sensor
      pulse <= 1;  // Generate a pulse
    end else begin
      pulse <= 0;  // Reset the pulse
    end

    // Update the previous state of enter_sensor
    enter_sensor_prev <= enter_sensor;
  end

endmodule
