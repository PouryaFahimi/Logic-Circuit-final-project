// Frequency Divider Module
module frequency_divider (
    input  wire clk_40MHz,      // 40 MHz input clock
    input  wire rst,            // Active-high reset
    output reg  clk_40MHz_out,  // Pass-through of 40 MHz clock
    output reg  clk_100Hz,      // 100 Hz clock output
    output reg  clk_2Hz,        // 2 Hz clock output
    output reg  clk_1Hz         // 1 Hz clock output
);

  // Parameters for frequency division
  parameter DIV_100HZ = 400000;  // 40MHz / 100Hz = 400000
  parameter DIV_2HZ = 20000000;  // 40MHz / 2Hz = 20000000
  parameter DIV_1HZ = 40000000;  // 40MHz / 1Hz = 40000000

  // Counters for each frequency
  reg [31:0] counter_100Hz = 0;
  reg [31:0] counter_2Hz = 0;
  reg [31:0] counter_1Hz = 0;

  // Clock outputs initialization
  initial begin
    clk_40MHz_out = 0;
    clk_100Hz = 0;
    clk_2Hz = 0;
    clk_1Hz = 0;
  end

  always @(posedge clk_40MHz or posedge rst) begin
    if (rst) begin
      // Reset all counters and outputs
      counter_100Hz <= 0;
      counter_2Hz <= 0;
      counter_1Hz <= 0;
      clk_40MHz_out <= 0;
      clk_100Hz <= 0;
      clk_2Hz <= 0;
      clk_1Hz <= 0;
    end else begin
      // Pass-through 40 MHz clock
      clk_40MHz_out <= ~clk_40MHz_out;

      // Generate 100 Hz clock
      if (counter_100Hz == (DIV_100HZ / 2) - 1) begin
        clk_100Hz <= ~clk_100Hz;
        counter_100Hz <= 0;
      end else begin
        counter_100Hz <= counter_100Hz + 1;
      end

      // Generate 2 Hz clock
      if (counter_2Hz == (DIV_2HZ / 2) - 1) begin
        clk_2Hz <= ~clk_2Hz;
        counter_2Hz <= 0;
      end else begin
        counter_2Hz <= counter_2Hz + 1;
      end

      // Generate 1 Hz clock
      if (counter_1Hz == (DIV_1HZ / 2) - 1) begin
        clk_1Hz <= ~clk_1Hz;
        counter_1Hz <= 0;
      end else begin
        counter_1Hz <= counter_1Hz + 1;
      end
    end
  end

endmodule
