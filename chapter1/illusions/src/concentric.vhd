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
    begin 
      report "Hello";
    end procedure;
	begin
		draw.init(window_width, window_height);
		-- draw the illusion here
    --draw_circle(window_width/2, window/height/2);

    for i in 0 to 5 loop
      -- draw the filled circles
      draw.setColor(220-40*i, 220-40*i, 220-40*i);
      draw.fillCircle(window_width/2,window_height/2, 60-10*i);
      -- draw the outlines 
      draw.setColor(Black);
      draw.drawCircle(window_width/2,window_height/2, 60-10*i);
    end loop;


		draw.show("concentric.ppm");
		wait;
	end process;

end architecture;
