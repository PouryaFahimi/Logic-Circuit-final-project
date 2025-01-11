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


  wire [3:0] state;
  wire door_open_trigger, full_trigger;

  FSM fsm (
      .clk(clk_40MHz),
      .in({entry_sensor, exit_sensor, switch}),
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

  /*** fix later ***/
  and (parking_slots[0], 1'b1, state[0]);
  and (parking_slots[1], 1'b1, state[1]);
  and (parking_slots[2], 1'b1, state[2]);
  and (parking_slots[3], 1'b1, state[3]);

  /*** fix later ***/
  wire full_temp;
  and (full_temp, state[0], state[1], state[2], state[3]);
  and #50 (full_light, full_temp, entry_sensor, ~exit_sensor);

  FullLight full_light_flasher (
      .clk_40MHz(clk_40MHz),
      .clk_1Hz(clk_1Hz),
      .trigger(full_trigger),
      .reset(reset),
      .LED(full_light)
  );


  wire [2:0] temp_cap;

  Capacity cap (
      .in (state),
      .out(capacity)
  );


  wire [2:0] temp_loc;

  Location loc (
      .in(state),
      .encoded(best_place)
  );

  and (
      temp_cap[0], 1'b1, capacity[0]
  ), (
      temp_cap[1], 1'b1, capacity[1]
  ), (
      temp_cap[2], 1'b1, capacity[2]
  ), (
      temp_loc[0], 1'b1, best_place[0]
  ), (
      temp_loc[1], 1'b1, best_place[1]
  ), (
      temp_loc[2], 1'b1, best_place[2]
  );

  reg [11:0] data;

  always @(*) begin
    // Initialize all bits to avoid 'x'
    data = 12'b0;

    // Assign values to specific bits
    data[2:0] = temp_loc;  // Location information
    data[8:6] = temp_cap;  // Capacity information
  end

  seven_segment_display sev_seg (
      .clk(clk),
      .s1a(data),
      .set_Data(sev_data),
      .see_sel(sev_sel)
  );

endmodule
