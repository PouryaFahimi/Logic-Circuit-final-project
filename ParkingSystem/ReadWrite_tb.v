module ReadWrite_tb;

  reg clk;
  reg entry;
  reg exit;
  reg [1:0] _switch;
  wire [3:0] state;
  wire open;

  integer file;
  integer file_out;
  integer status;

  FSM UUT (
      .clk(clk),
      .in({entry, exit, _switch}),
      .state(state),
      .door_open_pulse(open)
  );

  initial begin
    $dumpfile("ReadWrite_tb.vcd");
    $dumpvars(0, ReadWrite_tb);
    entry = 0;
    exit = 0;
    _switch = 2'b00;
    clk = 0;

    file = $fopen("input.txt", "r");
    file_out = $fopen("output.txt", "w");
    $display("the file content : %d", file);
    if (file == 0) begin
      $display("Error: Failed to open file.");
      $finish;
    end

    while (!$feof(
        file
    )) begin
      status = $fscanf(file, "%1b %1b %1b %1b\n", entry, exit, _switch[1], _switch[0]);
      if (status == 4) begin
        #100;
        $fwrite(file_out, "%b %s\n", state, open ? "open_door " : "");


      end else begin
        $display("Error: File format incorrect or incomplete data.");
        $finish;
      end
    end

    $fclose(file);
    $fclose(file_out);

    #200 $finish;
  end

    always begin
        #50;
        clk = ~clk;
    end
endmodule
