module Circuit (
    input clk,
    input entry_sensor,
    input exit_sensor,
    input [1:0] switch,
    input reset,

    output [3:0] parking_slots,
    output door_open_light,
    output full_light,
    output [2:0] capacity,
    output [2:0] best_place,
    output [7:0] sev_data,
    output [4:0] sev_sel
);

  wire clk_40MHz, clk_100Hz, clk_2Hz, clk_1Hz;

  FrequencyDivider freqDiv (
      .clk_40MHz(clk),
      .rst(reset),
      .clk_40MHz_out(clk_40MHz),
      .clk_100Hz(clk_100Hz),
      .clk_2Hz(clk_2Hz),
      .clk_1Hz(clk_1Hz)
  );

  wire db_entry, db_exit;
  Debouncer en_b (
    .clk(clk),
    .reset_n(reset),
    .button(entry_sensor),
    .debounce(db_entry)
  );
  Debouncer ex_b (
    .clk(clk),
    .reset_n(reset),
    .button(exit_sensor),
    .debounce(db_exit)
  );


  wire [3:0] state;
  wire door_open_trigger, full_trigger;

  FSM fsm (
      .clk(clk_40MHz),
      .in({db_entry, db_exit, switch}),
      .reset(reset),
      .state(state),
      .door_open_pulse(door_open_trigger)
  );

  DoorOpen door_open_flasher (
      .clk_40MHz(clk_40MHz),
      .clk_2Hz(clk_2Hz),
      .trigger(door_open_trigger),
      .reset(reset),
      .LED(door_open_light)
  );

  /*** Parking slots representation ***/
  assign parking_slots[0] = state[0];
  assign parking_slots[1] = state[1];
  assign parking_slots[2] = state[2];
  assign parking_slots[3] = state[3];

  /*** Full logic ***/
  // Temporary signal for full state detection
  wire full_temp;
  assign full_temp = &state;  // True when all parking slots are full

  // Trigger signal for the FullLight module
  assign full_trigger = full_temp & db_entry & ~db_exit;

  // FullLight flasher
  wire full_light_signal;
  FullLight full_light_flasher (
      .clk_40MHz(clk_40MHz),
      .clk_1Hz(clk_1Hz),
      .trigger(full_trigger),
      .reset(reset),
      .LED(full_light_signal)
  );

  // Use the full_light_signal as the output for full_light
  assign full_light = full_light_signal;

  /*** Capacity and Best Place ***/
  Capacity cap (
      .in(state),
      .out(capacity)
  );

  Location loc (
      .in(state),
      .encoded(best_place)
  );

  /*** Data for Seven Segment Display ***/
  reg [11:0] data;

  always @(*) begin
    // Initialize all bits to avoid 'x'
    data = 12'b0;

    // Assign values to specific bits
    data[2:0] = best_place;  // Location information
    data[8:6] = capacity;    // Capacity information
  end

  seven_segment_display sev_seg (
      .clk(clk),
      .s1a(data),
      .set_Data(sev_data),
      .see_sel(sev_sel)
  );

endmodule
