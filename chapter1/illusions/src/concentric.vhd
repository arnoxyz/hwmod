use work.vhdldraw_pkg.all;

entity concentric is
end entity;

architecture arch of concentric is
begin
	process is
		constant window_width : natural := 840;
		constant window_height : natural := 480;
		variable draw : vhdldraw_t;

	begin
		draw.init(window_width, window_height);
		-- draw the illusion here
    draw.setColor(220-40*0, 220-40*0, 220-40*0);
    draw.fillCircle(window_width/2,window_height/2, 60-10*0);
    draw.setColor(220-40*1, 220-40*1, 220-40*1);
    draw.fillCircle(window_width/2,window_height/2, 60-10*1);
    draw.setColor(220-40*2, 220-40*2, 220-40*2);
    draw.fillCircle(window_width/2,window_height/2, 60-10*2);
    draw.setColor(220-40*3, 220-40*3, 220-40*3);
    draw.fillCircle(window_width/2,window_height/2, 60-10*3);
    draw.setColor(220-40*4, 220-40*4, 220-40*4);
    draw.fillCircle(window_width/2,window_height/2, 60-10*4);
    draw.setColor(220-40*5, 220-40*5, 220-40*5);
    draw.fillCircle(window_width/2,window_height/2, 60-10*5);
		draw.show("concentric.ppm");

		wait;
	end process;

end architecture;
