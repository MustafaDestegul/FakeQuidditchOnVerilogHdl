module timer180sec( clk,reset,start_in,playing_reg,timer_reg);
	
	  input reset;
	  input clk;
	  input start_in;
	  output playing_reg;
	  output timer_reg;
	  
	 
		  

 debouncer(.clk(clk),.n_reset(reset),.button_in(start_in),.DB_out(start));
  //debouncer(.clk(clk),.n_reset(reset),.button_in(stop_in),.DB_out(stop));
	wire start;

 
/////////////1 hz timer /////////////////////////////////////////////////////
reg new_clk_1hz;
reg [27:0] counter;
wire clk_1hz;
reg gameover;

initial begin 
timer=8'd180;
counter=0;
playing=0;
gameover=0;
end
always@(posedge clk) begin 
if(counter==24999999) begin 
counter<=0;
new_clk_1hz<=~new_clk_1hz;
end 
else 
counter<=counter +28'd1 ;
end
assign clk_1hz= new_clk_1hz;


 ///   start  ///////////
reg playing;
reg [7:0] timer;
wire [7:0] timer_reg;
wire playing_reg;
 always@(negedge start or posedge gameover) begin 
if(~start) 
     playing<=1;
	  
else if(gameover)
     playing<=0;
end 
assign playing_reg = playing;
assign timer_reg= timer;
//  180 sec timer ///////////////
always@(posedge clk_1hz)
begin 

 if(playing)
    begin 
	 
      if(timer==0)
		begin
		 gameover<=1;
		 timer<=8'd0;
		end
	   else 
	    timer<= timer-8'd1;
end
else if(~playing) begin
gameover<=0;
timer<=8'd180;
end
end




		
endmodule

