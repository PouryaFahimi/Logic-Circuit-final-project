module PulseGenerator (
    input  wire [3:0] fsm_state,     // 4-bit FSM state
    input  wire       enter_sensor,  // Enter sensor signal
    input  wire       exit_sensor,   // Exit sensor signal
    input  wire       clk,           // Clock signal for edge detection
    output reg        pulse          // Output pulse
);

  // Internal register to detect the posedge of enter_sensor
  reg enter_sensor_prev;

  // Always block to monitor inputs and generate pulse
  always @(posedge clk) begin
    // Store the previous state of the enter_sensor
    enter_sensor_prev <= enter_sensor;

    // Check the conditions
    if ((fsm_state == 4'b1111) &&  // FSM state is 15
        (exit_sensor == 0) &&  // Exit sensor is 0
        (enter_sensor == 1) &&  // Enter sensor is 1
        (enter_sensor_prev == 0)  // Detect posedge of enter_sensor
        ) begin
      pulse <= 1;  // Generate the pulse
    end else begin
      pulse <= 0;  // Default state of the pulse
    end
  end

endmodule
