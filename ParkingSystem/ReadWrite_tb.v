module ReadWrite_tb;

  reg clk;
  reg entry;
  reg exit;
  reg [1:0] switch;
  wire [3:0] state;
  wire open;
  wire full;
  wire [2:0] capacity;
  wire [2:0] best_place;

  integer file;
  integer file_out;
  integer status;

  Circuit UUT (
      .clk(clk),
      .entry_sensor(entry),
      .exit_sensor(exit),
      .switch(switch),
      .parking_slots(state),
      .door_open_light(open),
      .full_light(full),
      .capacity(capacity),
      .best_place(best_place)
  );

  initial begin
    $dumpfile("ReadWrite_tb.vcd");
    $dumpvars(0, ReadWrite_tb);
    entry = 0;
    exit = 0;
    switch = 2'b00;
    clk = 0;

    file = $fopen("input.txt", "r");
    file_out = $fopen("output.txt", "w");
    if (file == 0) begin
      $display("Error: Failed to open file.");
      $finish;
    end

    while (!$feof(file)) begin
      status = $fscanf(file, "%1b %1b %1b %1b\n", entry, exit, switch[1], switch[0]);
      if (status == 4) begin
        #100;
        $fwrite(file_out, "%b [%d,%d] %s%s\n", state, capacity, best_place,
                open ? "Open Door " : "", full ? "Full" : "");


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
