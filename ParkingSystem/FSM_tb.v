`timescale 1 ns / 1 ps

module FSM_tb;

  reg clk;
  reg [3:0] in;
  wire [3:0] state;
  wire door_open_pulse;

  FSM UUT (
      .clk(clk),
      .in(in),
      .state(state),
      .door_open_pulse(door_open_pulse)
  );

  initial begin

    $dumpvars(0, FSM_tb);
    $dumpfile("FSM_tb.vcd");
    clk = 0;
    forever #50 clk = ~clk;
  end

  initial begin
    in = 4'b0000;
    #100;

    in = 4'b1000;
    #100;

    in = 4'b0100;
    #100;

    in = 4'b1000;
    #100;

    in = 4'b1000;
    #100;

    in = 4'b1000;
    #100;

    #1000;

    $finish;
  end

endmodule
