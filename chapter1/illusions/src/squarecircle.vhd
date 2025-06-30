use work.vhdldraw_pkg.all;

entity squarecircle is
end entity;

architecture arch of squarecircle is
begin
	process is
		constant window_size : natural := 600;
		variable draw: vhdldraw_t;

    constant square_size : natural := 50;
    constant square_line_width : natural := 2; 
    constant space : natural := 10;
    constant offset : natural := 5;

    variable square_x : natural := 0 + offset;
    variable square_y : natural := 0 + offset;

	begin
		draw.init(window_size);
		-- draw the illusion here
    draw.setLineWidth(square_line_width);
    draw.drawSquare(square_x, square_y, square_size);

		draw.show("squarecircle.ppm");
		wait;
	end process;

end architecture;
