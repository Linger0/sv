module tb;
  typedef enum {GREEN, YELLOW, RED, BLUE} color_set_1;
  typedef enum {MAGENTA=2, VIOLET=7, PURPLE, PINK} color_set_2;
  typedef enum {BLACK[4]} color_set_3;
  typedef enum {RED[3] = 5} color_set_4;
  typedef enum {YELLOW[3:5]} color_set_5;
  typedef enum {WHITE[3:5] = 4} color_set_6;

  initial begin
    color_set_1 color1;
    color_set_2 color2;
    color_set_3 color3;
    color_set_4 color4;
    color_set_5 color5;
    color_set_6 color6;

    color1 = YELLOW; $display("color1 = %0d, name = %s", color1, color1.name());
    color2 = PURPLE; $display("color2 = %0d, name = %s", color2, color2.name());
    color3 = BLACK3; $display("color3 = %0d, name = %s", color3, color3.name());
    color4 = RED1;   $display("color4 = %0d, name = %s", color4, color4.name());
    color5 = YELLOW3;$display("color5 = %0d, name = %s", color5, color5.name());
    color6 = WHITE4; $display("color6 = %0d, name = %s", color6, color6.name());
  end
endmodule