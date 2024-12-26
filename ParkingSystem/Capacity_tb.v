`timescale 1 ns / 1 ps

module Capacity_tb;

  reg  [3:0] in;
  wire [2:0] out;

  Capacity UUT (
      .in (in),
      .out(out)
  );

  initial begin
    $dumpfile("Capacity_tb.vcd");
    $dumpvars(0, Capacity_tb);

  end

  initial begin
    in = 4'b0001;
    #100;

    in = 4'b0000;
    #100;

    in = 4'b0100;
    #100;

    in = 4'b1010;
    #100;

    in = 4'b1111;
    #100;

    in = 4'b1110;
    #100;

    $finish;
  end

endmodule
