module seven_segment_display (
    input wire clk,
    input wire [11:0] s1a,
    output reg [7:0] set_Data,
    output reg [4:0] see_sel
);
  reg [ 2:0] digit;
  reg [ 1:0] digit_select;
  reg [21:0] refresh_counter;  // Counter to create a refresh rate
  
  initial begin
    set_Data = 0;
	 see_sel = 0;
	 digit_select = 0;
	 refresh_counter = 0;
  end

  // Generate a slower clock enable signal for refreshing the display
  always @(posedge clk) begin
    if (refresh_counter[9] == 1) refresh_counter <= 0;
    else refresh_counter <= refresh_counter + 1;
  end

  // Segment definitions for 0-9
  always @(digit) begin
    case (digit)
      3'd0: set_Data = 8'b00111111;
      3'd1: set_Data = 8'b00000110;
      3'd2: set_Data = 8'b01011011;
      3'd3: set_Data = 8'b01001111;
      3'd4: set_Data = 8'b01100110;
      3'd5: set_Data = 8'b01101101;
      default: set_Data = 8'b00000000;  // Off
    endcase
  end

  // Multiplexing digits with refresh counter
  always @(posedge clk) begin
    if (refresh_counter[9] == 1) begin
      if (digit_select < 3) digit_select <= digit_select + 1;
      else digit_select <= 0;
      case (digit_select)
        2'b00: begin
          digit   = 6;
          see_sel = 5'b01000;  // Select first 7-segment display
        end
        2'b01: begin
          digit   = s1a[8:6];
          see_sel = 5'b00100;  // Select second 7-segment display
        end
        2'b10: begin
          digit   = 6;
          see_sel = 5'b00010;  // Select third 7-segment display
        end
        2'b11: begin
          digit   = s1a[2:0];
          see_sel = 5'b00001;  // Select fourth 7-segment display
        end
      endcase
    end
  end
endmodule
