`timescale 1 ns / 1 ps

module Location_tb;

  reg  [3:0] in;
  wire [2:0] encoded;

  Location UUT (
      .in (in),
      .encoded(encoded)
  );

  initial begin
    $dumpfile("Location_tb.vcd");
    $dumpvars(0, Location_tb);

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

    in = 4'b0111;
    #100;

    $finish;
  end

endmodule
