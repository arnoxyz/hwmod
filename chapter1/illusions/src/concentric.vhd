use work.vhdldraw_pkg.all;

entity concentric is
end entity;

architecture arch of concentric is
begin
	process is
		constant window_width : natural := 840;
		constant window_height : natural := 480;
		variable draw : vhdldraw_t;

    variable x_pos : natural := 0;
    variable y_pos : natural := 0;
    constant SYMBOL_SIZE : natural := 60;
    constant Offset_x : natural := 60;
    constant Offset_y : natural := 60;

    -- draws the symbol (circles, black diamond outline) at the (x,y) position
    procedure draw_symbol(x : natural; y : natural) is 
      constant COLOR_INIT : natural := 220;
      constant COLOR_CHANGE : natural := 40;

      constant SIZE_CHANGE : natural := 10;
      constant CIRCLE_SIZE : natural := 60;

      constant SHIFT: natural := CIRCLE_SIZE;
    begin 
      for i in 0 to 5 loop
        -- draw the filled circles
        draw.setColor(COLOR_INIT-COLOR_CHANGE*i, COLOR_INIT-COLOR_CHANGE*i, COLOR_INIT-COLOR_CHANGE*i);
        draw.fillCircle(x,y, CIRCLE_SIZE-SIZE_CHANGE*i);
        -- draw the outlines
        draw.setColor(Black);
        draw.drawCircle(x,y, CIRCLE_SIZE-SIZE_CHANGE*i);
      end loop;

      --draw the black diamond outline
        --top_position    [x,y-CIRCLE_SIZE/2]
        --bottom_position [x,y+CIRCLE_SIZE/2]
        --left_position   [x-CIRCLE_SIZE/2,y]
        --right_position  [x+CIRCLE_SIZE/2,y]

      draw.drawLine(x,y-SHIFT,x-SHIFT,y); --from top position to left
      draw.drawLine(x,y-SHIFT,x+SHIFT,y); --from top position to right
      draw.drawLine(x,y+SHIFT,x-SHIFT,y); --from bottom to left
      draw.drawLine(x,y+SHIFT,x+SHIFT,y); --from bottom to right
    end procedure;
	begin
		draw.init(window_width, window_height);

    for j in 0 to 4 loop
      y_pos := Offset_y + j*(2*SYMBOL_SIZE);
      -- draw line
      for i in 0 to 7 loop
        x_pos := Offset_x + i*(2*SYMBOL_SIZE);
        draw_symbol(x_pos, y_pos);
      end loop;
      x_pos := 0;
    end loop;

		draw.show("concentric.ppm");
		wait;
	end process;

end architecture;
