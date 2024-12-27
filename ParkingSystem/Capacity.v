module Capacity (
    input [3:0] in,  // 4-bit input data
    output reg [2:0] out  // 3-bit output to store the count of zeros (max 4 zeros)
);

  integer i;  // Loop variable

  always @(*) begin
    out = 0;  // Initialize the count
    for (i = 0; i < 4; i = i + 1) begin
      if (in[i] == 1'b0) begin
        out = out + 1;
      end
    end
  end

endmodule
