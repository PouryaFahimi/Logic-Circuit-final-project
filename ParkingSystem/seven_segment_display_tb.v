`timescale 1ns / 1ps

module seven_segment_display_tb;

  // Testbench signals
  reg clk;
  reg [11:0] s1a;
  wire [7:0] set_Data;
  wire [4:0] see_sel;

  // Instantiate the DUT (Device Under Test)
  seven_segment_display uut (
      .clk(clk),
      .s1a(s1a),
      .set_Data(set_Data),
      .see_sel(see_sel)
  );

  // Clock generation (50 MHz)
  initial begin
    clk = 0;
    forever #10 clk = ~clk;  // 20 ns clock period (50 MHz)
  end

  // Test stimulus
  initial begin
    // Initialize inputs
    s1a = 12'b0;

    // Wait for the initial reset period
    #100;

    // Test case 1: All zeros
    s1a = 12'b000000000000;  // Expect "0" on the first display
    #100;

    // Test case 2: Mixed values
    s1a = 12'b000111010110;  // Expect "0", "1", "2", and "3" on displays
    #400;  // Wait for multiple refresh cycles

    // Test case 3: All ones
    s1a = 12'b111111111111;  // Expect "7" on all displays
    #400;

    // Test case 4: Random values
    s1a = 12'b101010101010;  // Test edge cases
    #400;

    // End simulation
    $stop;
  end

  // Monitor output
  initial begin
    $monitor("Time=%0t | s1a=%b | set_Data=%b | see_sel=%b", $time, s1a, set_Data, see_sel);
  end

endmodule
