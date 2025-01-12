module Debouncer(
    input clk,
    input reset_n,
    input button,
    output reg debounce
);
    reg [2:0] shift_reg;

    always @(posedge clk or negedge reset) begin
        if (!reset) begin
            shift_reg <= 3'b111;
            clean_signal <= 0;
        end else begin
            shift_reg <= {shift_reg[1:0], noisy_signal};
            if (shift_reg == 3'b000) begin
                clean_signal <= 1;
					 shift_reg <= 3'b111;
            end else if (shift_reg != 3'b000) begin
                clean_signal <= 0;
            end
        end
    end

endmodule