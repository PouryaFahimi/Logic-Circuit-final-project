module FullLight (
    input  wire clk_40MHz,  // 40MHz clock (input trigger detection)
    input  wire clk_1Hz,    // Slow clock (1Hz or 2Hz for flashing)
    input  wire trigger,    // Trigger signal (one 40MHz cycle pulse)
    input  wire reset,      // Asynchronous reset
    output reg  LED         // LED output
);

  initial LED = 0;

  // Parameters for the number of clock cycles to flash
  parameter FLASH_COUNT = 6;

  // Internal state variables
  reg [3:0] counter = 0;  // Counter for flash cycles
  reg       flashing = 0;  // Indicates if flashing is active
  reg       trigger_latched = 0;  // Latches trigger detection at 40MHz
  reg       trigger_processed = 0; // Indicates that the trigger has been processed

  // Trigger detection logic (using 40MHz clock)
  always @(posedge clk_40MHz or posedge reset) begin
    if (reset) begin
      trigger_latched <= 0;
      trigger_processed <= 0;
    end else if (trigger && !trigger_processed) begin
      trigger_latched <= 1;      // Latch the trigger
      trigger_processed <= 1;    // Mark the trigger as processed
    end else begin
      trigger_latched <= 0;      // Clear the latch after detection
    end
  end

  // Flashing process (using slow clock)
  always @(posedge clk_1Hz or posedge reset) begin
    if (reset) begin
      // Reset all states
      counter <= 0;
      flashing <= 0;
      LED <= 0;
    end else if (trigger_latched && !flashing) begin
      // On trigger, start a new flashing process
      counter <= FLASH_COUNT;
      flashing <= 1;
      LED <= 1;
    end else if (flashing) begin
      // Continue flashing if active
      if (counter > 1) begin
        counter <= counter - 1;
        LED <= ~LED;  // Toggle LED
      end else begin
        // End flashing process
        counter <= 0;
        flashing <= 0;
        LED <= 0;
      end
    end
  end

endmodule
