`timescale 1 ns / 1 ps

module Full_Light_tb;

  reg [3:0] in;
  reg ent;
  reg ext;
  reg clk;
  wire pulse;

  Full_Light UUT (
      .fsm_state(in),
      .enter_sensor(ent),
      .exit_sensor(ext),
      .clk(clk),
      .pulse(pulse)
  );

  initial begin
    $dumpfile("Full_Light_tb.vcd");
    $dumpvars(0, Full_Light_tb);
    clk = 0;
    forever #50 clk = ~clk;
  end

  initial begin
    in  = 4'b0001;
    ent = 0;
    ext = 0;
    #100;

    in  = 4'b0000;
    ent = 1;
    ext = 0;
    #100;

    in  = 4'b1111;
    ent = 1;
    ext = 0;
    #100;

    in  = 4'b1010;
    ent = 1;
    ext = 0;
    #100;

    in  = 4'b1111;
    ent = 1;
    ext = 0;
    #100;

    in  = 4'b1111;
    ent = 0;
    ext = 0;
    #100;

    in  = 4'b1111;
    ent = 1;
    ext = 0;
    #100;

    in  = 4'b1100;
    ent = 1;
    ext = 0;
    #100;

    in  = 4'b1101;
    ent = 0;
    ext = 0;
    #100;

    in  = 4'b1111;
    ent = 1;
    ext = 0;
    #100;

  end

endmodule
