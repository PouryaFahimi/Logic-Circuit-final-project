module Circuit_tb;

  reg clk;
  reg entry;
  reg exit;
  reg [1:0] switch;
  wire [3:0] state;
  wire open;
  wire full;
  wire [2:0] capacity;
  wire [2:0] best_place;
  wire [7:0] sev_data;
  wire [4:0] sev_sel;

  Circuit UUT (
      .clk(clk),
      .entry_sensor(entry),
      .exit_sensor(exit),
      .switch(switch),
      .parking_slots(state),
      .door_open_light(open),
      .full_light(full),
      .capacity(capacity),
      .best_place(best_place),
      .sev_data(sev_data),
      .sev_sel(sev_sel)
  );

  initial begin
    entry = 0;
    exit = 0;
    switch = 2'b00;
    clk = 0;

    #100;
	 
	 entry = 1;
    exit = 0;
    switch = 2'b00;
	 #100;
	 
	 entry = 1;
    exit = 0;
    switch = 2'b01;
	 #100;
	 
	 entry = 0;
    exit = 0;
    switch = 2'b01;
	 #100;
	 
	 entry = 1;
    exit = 0;
    switch = 2'b11;
	 #100;
	 
	 entry = 0;
    exit = 1;
    switch = 2'b01;
	 #100;
	 
	 entry = 1;
    exit = 0;
    switch = 2'b00;
	 #100;
	 
	 entry = 0;
    exit = 1;
    switch = 2'b00;
	 #100;
	 
	 entry = 0;
    exit = 1;
    switch = 2'b00;
	 #100;
	 
	 entry = 1;
    exit = 0;
    switch = 2'b01;
	 #100;
	 
	 entry = 1;
    exit = 0;
    switch = 2'b00;
	 #100;
	 
	 entry = 1;
    exit = 0;
    switch = 2'b11;
	 #100;
	 
	 entry = 1;
    exit = 0;
    switch = 2'b00;
	 #100;
	 
	 entry = 0;
    exit = 0;
    switch = 2'b00;
	 #100;
	 
	 entry = 0;
    exit = 1;
    switch = 2'b00;
	 #100;
	 
	 entry = 0;
    exit = 0;
    switch = 2'b11;
	 #100;
	 
	 entry = 0;
    exit = 1;
    switch = 2'b10;
	 #100;
	 
	 entry = 0;
    exit = 1;
    switch = 2'b11;
	 #100;
	 
	 entry = 0;
    exit = 1;
    switch = 2'b01;
	 #100;
	 
	 entry = 0;
    exit = 0;
    switch = 2'b00;
	 #100;

  end

  always begin
    #50;
    clk = ~clk;
  end
endmodule
