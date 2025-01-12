module Debouncer(
    input clk,
    input reset_n,
    input button,
    output reg debounce
);
    reg [2:0] shift_reg;

    always @(posedge clk or negedge reset_n) begin
        if (!reset_n) begin
            shift_reg <= 3'b111;
            debounce <= 0;
        end else begin
            shift_reg <= {shift_reg[1:0], button};
            if (shift_reg == 3'b000) begin
                debounce <= 1;
					 shift_reg <= 3'b111;
            end else if (shift_reg != 3'b000) begin
                debounce <= 0;
            end
        end
    end

endmodule