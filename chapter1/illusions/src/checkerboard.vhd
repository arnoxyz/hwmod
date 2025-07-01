use work.vhdldraw_pkg.all;

entity checkerboard is
end entity;

architecture arch of checkerboard is
begin
	process is
		variable draw : vhdldraw_t;
		variable color : color_t := GREEN;

		constant size : natural := 40;
		constant cols : natural := 10;
		constant rows : natural := 11;

    constant window_width : natural := cols*size;
    constant window_height : natural := rows*size;

    constant square_size : natural := 40;
    variable square_x : natural := 0;
    variable square_y : natural := 0;


	begin
		draw.init(window_width, window_height);

		-- draw the illusion here
    draw.setColor(Blue);
    draw.fillSquare(square_x, square_y, square_size);


		draw.show("checkerboard.ppm");
		wait;
	end process;

end architecture;
