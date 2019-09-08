module updown1 (up, down, reset, out);
input        up, down, reset;
output [13:0] out;


wire up, down, reset;
reg [13:0] out ;

reg count_up, count_down;

always @(negedge up or negedge down)
  if (!down) count_up <= 1'b0;
  else       count_up <= 1'b1;

always @(negedge up or negedge down)
  if (!up)   count_down <= 1'b0;
  else       count_down <= 1'b1;


wire count_pulse = up & down;

always @ (posedge count_pulse or negedge reset) 
  begin
    if      (!reset)  out <= 14'b00000000000000;

    else if (count_up)     out <= out + 14'b00000000000001;
    else if (count_down)   out <= out - 14'b00000000000001;
    else                   out <= out;
end
endmodule
