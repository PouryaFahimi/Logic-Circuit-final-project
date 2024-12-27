module Circuit (
    input clk,
    input entry_sensor,
    input exit_sensor,
    input [1:0] switch,
    output [3:0] parking_slots,
    output door_open_light,
    output full_light,
    output [2:0] capacity,
    output [2:0] best_place
);

  wire [3:0] state;
  and (parking_slots[0], 1'b1, state[0]);
  and (parking_slots[1], 1'b1, state[1]);
  and (parking_slots[2], 1'b1, state[2]);
  and (parking_slots[3], 1'b1, state[3]);

  FSM fsm (
      .clk(clk),
      .in({entry_sensor, exit_sensor, switch}),
      .state(state),
      .door_open_pulse(door_open_light)
  );

  Capacity cap (
      .in(state),
      .out(capacity)
  );

  Location loc (
      .in(state),
      .encoded(best_place)
  );

  Full_Light full (
      .fsm_state(state),
      .enter_sensor(entry_sensor),
      .exit_sensor(exit_sensor),
      .clk(clk),
      .pulse(full_light)
  );

endmodule
