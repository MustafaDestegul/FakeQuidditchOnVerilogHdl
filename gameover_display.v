module gameover_display
    (
        input wire clk,
        input playing_reg,		  // input clock signal for synchronous rom
        input wire [9:0] x, y,      // current pixel coordinates from vga_sync circuit
        output reg gameover_on     // output signal asserted when x/y are within gameover on display
    );
	
	// vectors to index game_logo_rom
	reg [3:0] row;
	reg [6:0] col;
	wire rgb_out;
	// instantiate game_logo_rom
	gameover_rom gameover_rom_unit (.clk(clk), .row(row), .col(col), .color_data(rgb_out));
	
always @* 
		begin
		// defaults
	gameover_on=0;
		row = 0;
		col = 0;

if(~playing_reg) begin 
		
		// if vga pixel within bcd3 location on screen
		 if(x >= 282 && x < 360 && y >= 72 && y < 100)
			begin
			col = x - 282;
			row = y - 72; 
			if(rgb_out == 1'b1)      // if bit is 1, assert score_on output
				gameover_on = 1;
			end
end	
	
end

endmodule
