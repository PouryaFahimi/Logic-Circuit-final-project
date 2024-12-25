// The module returns the first 0 it founds in input.
// if there is any park it returns index. 0 to 3

// And if there isn't any park spot, full state, it returns 5. 101

module Location (
    input  wire [3:0] in,
    output wire [2:0] encoded
);

  wire not_in3, not_in2, not_in1, not_in0;
  wire and0, and1, and2;


  not U0 (not_in3, in[3]);
  not U1 (not_in2, in[2]);
  not U2 (not_in1, in[1]);
  not U3 (not_in0, in[0]);

  and U4 (and0, not_in1, in[0]);
  and U5 (and1, not_in2, in[1], in[0]);
  and U6 (and2, not_in3, in[2], in[1], in[0]);

  and U7 (encoded[2], in[3], in[2], in[1], in[0]);


  or U8 (encoded[1], and2, and1);
  or U9 (encoded[0], encoded[2], and2, and0);


endmodule
