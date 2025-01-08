module Circuit (
    input clk,
    input entry_sensor,
    input exit_sensor,
    input [1:0] switch,

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
      .clk_40MHz_out(clk_40MHz),
      .clk_100Hz(clk_100Hz),
      .clk_2Hz(clk_2Hz),
      .clk_1Hz(clk_1Hz)
  );

  FSM fsm (
      .clk(clk_40MHz),
      .in({entry_sensor, exit_sensor, switch}),
      .state(state),
      .door_open_pulse(door_open_light)
  );

  wire [3:0] state;
  and (parking_slots[0], 1'b1, state[0]);
  and (parking_slots[1], 1'b1, state[1]);
  and (parking_slots[2], 1'b1, state[2]);
  and (parking_slots[3], 1'b1, state[3]);

  wire full_temp;
  and (full_temp, state[0], state[1], state[2], state[3]);
  and #50 (full_light, full_temp, entry_sensor, ~exit_sensor);

  Capacity cap (
      .in (state),
      .out(capacity)
  );

  wire [2:0] temp_cap;
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

seven_segment_display sev_seg (
    .clk(clk),
    .s1a({3'b000, temp_cap, 3'b000, temp_loc}),
    .set_Data(sev_data),
    .see_sel(sev_sel)
);

endmodule
