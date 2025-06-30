use work.vhdldraw_pkg.all;

entity squarecircle is
end entity;

architecture arch of squarecircle is
begin
	process is
		constant window_size : natural := 600;
		variable draw: vhdldraw_t;

    -- for square
    constant square_size : natural := 50;
    constant square_line_width : natural := 2; 
    constant square_space_between : natural := 10;
    constant square_offset : natural := 5;
    variable square_x : natural := 0 + square_offset;
    variable square_y : natural := 0 + square_offset;

    -- for circle
    constant circle_size : natural := 30;
    constant circle_line_width : natural := 4; 
    constant circle_offset : natural := 60;
    variable circle_x : natural := 0 + circle_offset;
    variable circle_y : natural := 0 + circle_offset;

	begin
		draw.init(window_size);
		-- draw the squares grid
    draw.setLineWidth(square_line_width);
    for j in 0 to 10 loop
      square_y := square_offset + j*(square_space_between+square_size);
      for i in 0 to 10 loop
        draw.drawSquare(square_x + i*(square_space_between+square_size), square_y, square_size);
      end loop;
      square_x := 0 + square_offset;
    end loop;

		-- draw the circles grid
    draw.setLineWidth(circle_line_width);
    draw.drawCircle(circle_x, circle_y, circle_size);

		draw.show("squarecircle.ppm");
		wait;
	end process;
end architecture;
