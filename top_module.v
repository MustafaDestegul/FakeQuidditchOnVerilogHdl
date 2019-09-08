module top_module(
               start_in,
               sw1,
					sw2,
					sw3,
               sw4,
					sw5,
					sw6,
					sw7,
					sw8,
					sw9,
					sw10,
					clk,
					reset,
					hys,
					vys,
					rgb_r,
					rgb_g,
					rgb_b,
					led_out
					
               );

input start_in;					
input clk;
input reset;   
input sw1,sw2,sw3,sw4,sw5,sw6,sw7,sw8,sw9,sw10;   
output hys;
output vys;
output [3:0]led_out;
output  rgb_r;
output  rgb_g;
output  rgb_b;
reg rgb_r;
reg rgb_g;
reg rgb_b;
wire[3:0]led_out;

reg[9:0] h_cnt;  // vga horizontal counter
reg[9:0] v_cnt;   // vga vertical counter



////////////25Mhz Clock and debouncers///////////////////
vga_pll	vga_pll_inst (.inclk0(clk),.c0(clk0));  
/////////////////////////////////////////////////////////////



////////////////////////VGA DRİVER////////////////////////////


always@(posedge clk0 or negedge reset)
	if(!reset)begin
	h_cnt<=10'd0;
	end
	else if(h_cnt==10'd800) h_cnt<=10'd0;
	else
	h_cnt<=h_cnt+1'b1;

always@(posedge clk0 or negedge reset)
	if(!reset) begin
	v_cnt<=10'd0;
	end
	else if(v_cnt==10'd525)  v_cnt<=10'd0; 
	else if(h_cnt==10'd800)  v_cnt<=v_cnt+1;
	
//generate hys
reg hys_r;
always@(posedge clk0 or negedge reset)
	if(!reset) hys_r<=0;
	else if(h_cnt==10'd0) hys_r<=1'b0;
	else if(h_cnt==10'd96) hys_r<=1'b1;
	
assign hys=hys_r;

//generate vys
reg vys_r;
always@(posedge clk0 or negedge reset)begin 
	if(!reset) vys_r<=1'b0;
	else if(v_cnt==10'd0) vys_r<=1'b0;
   else if(v_cnt==10'd34) vys_r<=1'b1;	
	end 
	
assign vys=vys_r;



wire valid;

assign valid=(v_cnt>=10'd34)&&(v_cnt<514)&&(h_cnt>=10'd144)&&(h_cnt<784);	// display valid 

////////////////////////////////////////////////////////////////////////////////////////////

///180 sec timer/////
timer180sec GamingTime(.clk(clk),.reset(reset),.start_in(start_in),.playing_reg(playing_reg),.timer_reg(timer_reg));
wire playing_reg;
wire [7:0]timer_reg;

assign led_out[0]= ~timer_reg[0];
assign led_out[1]= ~timer_reg[1];
assign led_out[2]= ~timer_reg[2];
assign led_out[3]= ~timer_reg[3];

////gameover_display////
gameover_display finishtime(.clk(clk),.x(h_cnt),.y(v_cnt),.gameover_on(gameover_on),.playing_reg(playing_reg));



/////////////////SCORE DISPLAYING ON SCREEN/////////////////////////


score_display team1(.clk(clk0),.reset(reset),.playing_reg(playing_reg),.x(h_cnt),.y(v_cnt),.score_on(score_on_top),.score(topteamscore)); // score displaying submodules
score_displateam2 team2(.clk(clk0),.reset(reset),.playing_reg(playing_reg),.x(h_cnt),.y(v_cnt),.score_on(score_on_bottom),.score(bottomteamscore));
score_display_timer gamingtime(.clk(clk0),.reset(reset),.playing_reg(playing_reg),.x(h_cnt),.y(v_cnt),.score_on(timing_on),.score(timer_reg));

/////////////////////////////////////////////////////////////////////////////////////////////////////

wire timing_on;
wire score_on_top;
wire score_on_bottom;
wire [13:0] topteamscore;
wire [13:0] bottomteamscore;
wire new_score;
assign new_score=1; 

////////////////////////////DEBOUNCERS///////////////////////////////////////

debouncer db1(.clk(clk),.n_reset(reset),.button_in(sw1),.DB_out(sw1_db));
debouncer db2(.clk(clk),.n_reset(reset),.button_in(sw2),.DB_out(sw2_db));
debouncer db3(.clk(clk),.n_reset(reset),.button_in(sw3),.DB_out(sw3_db));
debouncer db4(.clk(clk),.n_reset(reset),.button_in(sw4),.DB_out(sw4_db));
debouncer db5(.clk(clk),.n_reset(reset),.button_in(sw5),.DB_out(sw5_db));
debouncer db6(.clk(clk),.n_reset(reset),.button_in(sw6),.DB_out(sw6_db));
debouncer db7(.clk(clk),.n_reset(reset),.button_in(sw7),.DB_out(sw7_db));
debouncer db8(.clk(clk),.n_reset(reset),.button_in(sw8),.DB_out(sw8_db));
debouncer db9(.clk(clk),.n_reset(reset),.button_in(sw9),.DB_out(sw9_db));
debouncer db10(.clk(clk),.n_reset(reset),.button_in(sw10),.DB_out(sw10_db));
/////////////////////////////////////////////////////////////////////////////

//////////////////////PLAYER LOCATIONS ON SCREEN//////////////////////////////

updown5 P1(.up(sw1_db),.down(sw2_db),.reset(reset),.out(player1y));  //player 1 top left //up/ down counters
updown5 P2(.up(sw3_db),.down(sw4_db),.reset(reset),.out(player2x));  // player2 top right
updown5 P3(.up(sw7_db),.down(sw8_db),.reset(reset),.out(player3x));  // player3 bottom left
updown5 P4(.up(sw5_db),.down(sw6_db),.reset(reset),.out(player4y));  // player4 bottom right
updown1 To(.up(top_score),.down(sw10_db),.reset(reset),.out(topteamscore));     // arranging score and goes to score_display submodule
updown1 Bo(.up(bottom_score),.down(sw6_db),.reset(reset),.out(bottomteamscore));     
//////////////////////player's location on screen//////////////////////////////////



////////////////////////////////////////////////////////////////




//*****************************************CONSTANT CIRCLES***************************************************************************

integer circle1x=500;
integer circle1y=100;
integer circle2x=580;
integer circle2y=150;
integer circle3x=420;
integer circle3y=150;
integer circle4x=500;
integer circle4y=440;
integer circle5x=580;
integer circle5y=490;
integer circle6x=420;
integer circle6y=490;
////////////////////////////////////////////////////////////////////////////////////

wire [8:0] player1y, player4y ,player2x ,player3x; ///players positions

wire player1,player2,player3,player4;
wire circle1,circle2,circle3,circle4,circle5,circle6;
wire borders;
wire bludger;
wire main_ball;

assign bludger =  (v_cnt-ball_y)**2 + (h_cnt-ball_x)**2 <10**2;  
assign main_ball =(v_cnt-main_y)**2 + (h_cnt-main_x)**2 <10**2; 
assign circle1= (((v_cnt-circle1y)**2 + (h_cnt-circle1x)**2 )>15**2) && (((v_cnt-circle1y)**2 + (h_cnt-circle1x)**2 )<17**2) ;
assign circle2= (((v_cnt-circle2y)**2 + (h_cnt-circle2x)**2 )>15**2) && (((v_cnt-circle2y)**2 + (h_cnt-circle2x)**2 )<17**2) ;
assign circle3= (((v_cnt-circle3y)**2 + (h_cnt-circle3x)**2 )>15**2) && (((v_cnt-circle3y)**2 + (h_cnt-circle3x)**2 )<17**2) ;
assign circle4= (((v_cnt-circle4y)**2 + (h_cnt-circle4x)**2 )>15**2) && (((v_cnt-circle4y)**2 + (h_cnt-circle4x)**2 )<17**2) ;
assign circle5= (((v_cnt-circle5y)**2 + (h_cnt-circle5x)**2 )>15**2) && (((v_cnt-circle5y)**2 + (h_cnt-circle5x)**2 )<17**2) ;
assign circle6= (((v_cnt-circle6y)**2 + (h_cnt-circle6x)**2 )>15**2) && (((v_cnt-circle6y)**2 + (h_cnt-circle6x)**2 )<17**2) ;
assign borders = ((h_cnt>143 && h_cnt<150) || (h_cnt>778 && h_cnt<790)||(v_cnt>35 && v_cnt<42)||(v_cnt>508 && v_cnt<515) || (v_cnt>320 &&v_cnt<322));
//************************************************************************************************************************

///////////////////////////////////////////BLUDGER POSITIONING////////////////////////////////////////////////
// 
localparam L_BOUND = 10'd143;
localparam R_BOUND = 10'd768;
localparam U_BOUND = 10'd30;
localparam D_BOUND = 10'd480;
localparam BALL_V = 10'd1;
reg [9:0] ball_x_reg,ball_y_reg;
reg [9:0] ball_x,ball_y;
reg ball_move_x, ball_move_y;
reg [5:0] upscore, downscore;



//assign led_out[0]= playing_reg;
// initialization//////////////////////////////////////////////
initial begin
         ball_move_x=1;
         ball_move_y=1;
         ball_x = 10'd320;
         ball_y = 10'd240;
         upscore = 1'b0;
         downscore = 1'b0;
			count_x=17'd0;
			count_y=17'd0;
end
   // bludger move//////////////////////////////////////////////////////

 always@(posedge UpdateBallPosition) begin  
      if(playing_reg) begin 
				if (ball_move_x)
				ball_x = ball_x + BALL_V;
            else
				ball_x = ball_x - BALL_V;
				
            if (ball_move_y) 
				ball_y = ball_y + BALL_V;
            else
				ball_y = ball_y - BALL_V;
end

else begin
 
         ball_x = 10'd500;
         ball_y = 10'd240;


end
end
reg [16:0] count_x,count_y; 
//bludger collision detection//////////////////////////////////////////////
always@(posedge UpdateBallPosition) begin
 
            if ((ball_x <= L_BOUND +10 || ball_x >= R_BOUND +10) && count_x==0) begin 
                ball_move_x = ~ball_move_x;
					 count_x<=count_x+17'd1; 
					 end 
					else if(count_x<17'd25)
					count_x<=count_x+17'd1;
					else 
					count_x<=17'd0;

end     
always@(posedge UpdateBallPosition) begin
      
            if ((ball_y <= U_BOUND +10 || ball_y >= D_BOUND +10) && count_y==0) begin 
                ball_move_y = ~ball_move_y;
					 
				 count_y<=count_y+17'd1; end 
				 else if(count_y<17'd25)
				 count_y<=count_y+17'd1;
				 else
				 count_y<=17'd0;
            
					

end
//**********************************************************************************************************************************

//////////////////////////////////////////MAIN BALL POSITIONING////////////////////////////////////////////////



localparam main_Ball_V = 10'd1;
reg [9:0] main_x,main_y;
reg main_move_x, main_move_y;
reg [16:0] main_count_x,main_count_y; 

///*****************************************************************************************************////////
wire UpdateBallPosition;
assign	UpdateBallPosition = (v_cnt==514) & (h_cnt==784);


initial begin
         collision1=0; 
         collision2=0; 
         collision3=0; 
         collision4=0;
         main_move_x=0;
         main_move_y=1;
         main_x = 10'd320;
         main_y = 10'd240;
      
			main_count_x=17'd0;
			main_count_y=17'd0;
end
   // main ball movement//////////////////////////////////////////////////////
	
 always@(posedge UpdateBallPosition ) begin  
   if(playing_reg) begin 
				if ( main_move_x)
				main_x = main_x + main_Ball_V;
            else
				main_x = main_x - main_Ball_V;
				
            if ( main_move_y) 
				main_y = main_y + main_Ball_V;
            else
				main_y = main_y - main_Ball_V;
end
else begin
            main_x = 10'd320;
            main_y = 10'd240;
 
 end 
end

//main ball collision detection for x positioning //////////////////////////////////////////////
always@(posedge UpdateBallPosition) begin
    		 
        if ((main_x <= L_BOUND +10 ||main_x >= R_BOUND +10 || collision1 ||collision2||collision3||collision4) && main_count_x==0) begin 
                
					 main_move_x = ~main_move_x;
					 
					main_count_x<=main_count_x+17'd1; 
					 end 
					else if(main_count_x<17'd25)
					main_count_x<=main_count_x+17'd1;
					else 
					main_count_x<=17'd0;

end


always@(posedge UpdateBallPosition) begin
        
            if ((main_y<= U_BOUND +10 || main_y>= D_BOUND +10 || collision1 ||collision2||collision3||collision4) && main_count_y==0) begin 
              main_move_y = ~main_move_y;
					 
				 main_count_y<=main_count_y+17'd1; end 
				 else if(main_count_y<17'd25)
				 main_count_y<=main_count_y+17'd1;
				 else
				 main_count_y<=17'd0;
            
					
end
 //*******
 
 //////////////player positions//////////
 
assign player1=(v_cnt-player1y-82)**2 + (h_cnt-250)**2 <17**2; // player1y is taken from the debouncer_deneme module (will be changed)
assign player2=(v_cnt-250)**2 + (h_cnt-player2x-400)**2 <17**2;
assign player3=(v_cnt-380)**2 + (h_cnt-player3x-300)**2 <17**2;
assign player4=(v_cnt-player4y-330)**2 + (h_cnt-650)**2 <17**2;
////////////
// players collisions with main ball//
reg   collision1,collision2,collision3,collision4; 

always@(posedge clk) begin 
collision1<=0; 
collision2<=0; 
collision3<=0; 
collision4<=0;

if((main_x+10 >= 233) && (main_x+10 <= 275) &&(main_y+10 >= player1y+82-10)&&(main_y+10 <= player1y+82+25)) //player1 collision

collision1<=1; 

else if ((main_x+10 >= player2x+400-17) && (main_x+10 <= player2x+450-17) && (main_y+10 >= 260)&&(main_y+10<=285)) //player2 collision
collision2<=1;
else if ((main_x+10 >= player3x+165+100) &&(main_x +10<= player3x+255+90) && (main_y+10 >= 340)&&(main_y+10 <= 420)) //player3 collision
collision3<=1;
else if ((main_x >= 600) &&(main_x <= 650) &&(main_y >= player4y+300) && (main_y <= player4y+350)) //player4 collision
collision4<=1;
 
end







  	  
////////////////////////////////////////////////////////////
///////////                  SCOREs//////////////////////////
reg top_score,bottom_score;

initial begin

top_score=0;
bottom_score=0;
end 
reg clk1;

always@(posedge clk) 
begin 
top_score<=0;
 bottom_score<=0;

if((main_x >= 495) && (main_x <= 505) &&(main_y >= 95)&&(main_y <= 105)) 

bottom_score<=1; 

else if ((main_x >= 560) && (main_x <= 590)&&(main_y >= 140)&&(main_y<=160)) 
bottom_score<=1; 

else if ((main_x >= 410) &&(main_x <= 430)&&(main_y >=140)&&(main_y <= 160)) 
bottom_score<=1; 

else if ((main_x >= 490) &&(main_x <= 510) &&(main_y >= 430)&&(main_y <= 450)) 
top_score<=1;

else if ((main_x >= 570) &&(main_x <= 590) &&(main_y >= 480)&&(main_y <= 500)) 
top_score<=1;

else if ((main_x >=410) &&(main_x <= 430) &&(main_y >= 480)&&(main_y <= 500)) 
top_score<=1;


end



//////////////////////////////////////SCREEN /////////////////////////////////////
always@(posedge clk0) 
begin 

if(valid && (circle1 || circle2 || circle3 || circle4 || circle5 || circle6 || borders )) begin 
   rgb_r<=1;
   rgb_g<=1;
   rgb_b<=1;
	
	end else if(valid && bludger ) begin 
 rgb_r<=0;
   rgb_g<=1;
   rgb_b<=0;
		end else if(valid &&  main_ball) begin 
 rgb_r<=1;
   rgb_g<=1;
   rgb_b<=0;
	
	
	end else if(valid && (player1|| player2 || player3 || player4)) begin 
 rgb_r<=1;
   rgb_g<=1;
   rgb_b<=1;
	
	end else if(valid && (score_on_top || score_on_bottom || timing_on)) begin 
 rgb_r<=1;
   rgb_g<=0;
   rgb_b<=1;
	end else if(valid && gameover_on) begin 
   rgb_r<=1;
   rgb_g<=0;
   rgb_b<=0;
	
end else begin
 rgb_r<=0;
  rgb_g<=0;
  rgb_b<=0;
end
end



/////////////////////////////////////////////////////////////////////////////////////////////////////////






endmodule

