module score_display
	(	
	    input wire clk, reset,   // clock, reset signal inputs for synchronous roms and registers
	    input wire playing_reg,    // input wire asserted when eggs module increments score
	    input wire [13:0] score, // current score routed in from eggs module
	    input wire [9:0] x, y,   // vga x/y pixel location		 
	    output reg score_on     // output asserted when x/y are within score location in display
       
        );	
	
binarytobcd binaryconverter(.binary(score),.hundreds(bcd3),.tens(bcd2),.ones(bcd1));
 
 wire [3:0] bcd3, bcd2, bcd1;
	 

// *** on screen score display ***
	
	// row and column regs to index numbers_rom
	reg [7:0] row;
	reg [3:0] col;
	
	// output from numbers_rom
	wire color_data;
	
	// infer number bitmap rom
	numbers_rom numbers_rom_unit(.clk(clk), .row(row), .col(col), .color_data(color_data));
	
	// display 4 digits on screen
	always @* 
		begin
		// defaults
		score_on = 0;
		row = 0;
		col = 0;
	if(playing_reg) begin 
		// if vga pixel within bcd3 location on screen
		if(x >= 336 && x < 352 && y >= 95 && y < 115)
			begin
			col = x -336;
			row = y - 16*6+ (bcd3 * 16); // offset row index by scaled bcd3 value
			if(color_data == 1'b1)      // if bit is 1, assert score_on output
				score_on = 1;
			end
		
		// if vga pixel within bcd2 location on screen
		if(x >= 352 && x < 368 && y >= 95 && y < 115)
			begin
			col = x - 336;
			row = y - 16*6 + (bcd2 * 16); // offset row index by scaled bcd2 value
			if(color_data == 1'b1)      // if bit is 1, assert score_on output
				score_on = 1;
			end
		
		// if vga pixel within bcd1 location on screen
		if(x >= 368 && x < 384 && y >= 95 && y < 115)
			begin
			col = x - 336;
			row = y - 16*6+ (bcd1 * 16); // offset row index by scaled bcd1 value
			if(color_data == 1'b1)      // if bit is 1, assert score_on output
				score_on = 1;
			end
		
	
end 
else begin  
	 

        if(x >= 336 && x < 352 && y >= 95 && y < 115)
			begin
			col = x -336;
			row = y - 16*6; // offset row index by scaled bcd3 value
			if(color_data == 1'b1)      // if bit is 1, assert score_on output
				score_on = 1;
			end
		
		// if vga pixel within bcd2 location on screen
		if(x >= 352 && x < 368 && y >= 95 && y < 115)
			begin
			col = x - 336;
			row = y - 16*6; // offset row index by scaled bcd2 value
			if(color_data == 1'b1)      // if bit is 1, assert score_on output
				score_on = 1;
			end
		
		// if vga pixel within bcd1 location on screen
		if(x >= 368 && x < 384 && y >= 95 && y < 115)
			begin
			col = x - 336;
			row = y - 16*6; // offset row index by scaled bcd1 value
			if(color_data == 1'b1)      // if bit is 1, assert score_on output
				score_on = 1;
			end
		
end 	
			
end
		
endmodule
