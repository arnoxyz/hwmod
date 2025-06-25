use work.vhdldraw_pkg.all;

entity ouchi is
end entity;

architecture arch of ouchi is
begin
	process is
		constant window_size : natural := 800;
		constant width : natural := 32;
		constant height : natural := 8;
		variable draw : vhdldraw_t;

    constant rect_width : natural := 32;
    constant rect_height : natural := 8;
    variable rect_x,rect_y : natural := 0;

		-- you might want to add some auxiliary subprograms or constants / variables in here
	begin
		draw.init(window_size);
		-- draw the illusion here

    draw.setColor(Black);
    draw.fillRectangle(rect_x,rect_y,rect_width,rect_height);

    draw.setColor(White);
    rect_x := rect_x + rect_width;
    draw.fillRectangle(rect_x,rect_y,rect_width,rect_height);

    draw.setColor(Black);
    rect_x := rect_x + rect_width;
    draw.fillRectangle(rect_x,rect_y,rect_width,rect_height);


    report "Hello World!";

		draw.show("ouchi.ppm");
		wait;
	end process;

end architecture;
