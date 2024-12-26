module Capacity (
    input  [3:0] in,
    output [2:0] out
);

  // Intermediate signals for NOT operations
  wire not_in0, not_in1, not_in2, not_in3;

  // NOT gates to generate inverted inputs
  not U1 (not_in0, in[0]);
  not U2 (not_in1, in[1]);
  not U3 (not_in2, in[2]);
  not U4 (not_in3, in[3]);

  // out[2] = in[3] & in[2] & in[1] & in[0]
  wire and_out2;
  and U5 (and_out2, in[3], in[2], in[1], in[0]);

  // out[1] = (~in[3] + ~in[2] + ~in[0] + ~in[3])(in[3] + in[2] + in[1])(in[3] + in[2] + in[0])(in[3] + in[1] + in[0])(in[2] + in[1] + in[0])
  wire or1, or2, or3, or4, or5;

  // OR gates for the first part of out[1]
  or U6 (or1, not_in3, not_in2, not_in0, not_in1);

  // OR gates for the second part of out[1]
  or U7 (or2, in[3], in[2], in[1]);
  or U8 (or3, in[3], in[2], in[0]);
  or U9 (or4, in[3], in[1], in[0]);
  or U10 (or5, in[2], in[1], in[0]);

  // AND gate for final out[1]
  wire and_out1;
  and U11 (and_out1, or1, or2, or3, or4, or5);

  // out[0] = in[3] ^ in[2] ^ in[1] ^ in[0]
  wire xor_out1, xor_out2;

  xor U12 (xor_out1, in[3], in[2]);
  xor U13 (out[0], xor_out1, in[1], in[0]);

  // Assigning outputs
  assign out[2] = and_out2;
  assign out[1] = and_out1;

endmodule
