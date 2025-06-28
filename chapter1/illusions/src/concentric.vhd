use work.vhdldraw_pkg.all;

entity concentric is
end entity;

architecture arch of concentric is
begin
	process is
		constant window_width : natural := 840;
		constant window_height : natural := 480;
		variable draw : vhdldraw_t;

    procedure draw_circle(x : natural; y : natural) is 
      constant SIZE_CHANGE : natural := 10;
      constant COLOR_CHANGE : natural := 40;
    begin 
      for i in 0 to 5 loop
        -- draw the filled circles
        draw.setColor(220-COLOR_CHANGE*i, 220-COLOR_CHANGE*i, 220-COLOR_CHANGE*i);
        draw.fillCircle(x,y, 60-SIZE_CHANGE*i);
        -- draw the outlines
        draw.setColor(Black);
        draw.drawCircle(x,y, 60-SIZE_CHANGE*i);
      end loop;
    end procedure;
	begin
		draw.init(window_width, window_height);

    draw_circle(window_width/2, window_height/2);

		draw.show("concentric.ppm");
		wait;
	end process;

end architecture;
