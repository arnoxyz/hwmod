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
    for j in 0 to 10 loop
      square_y := offset + j*(space+square_size);
      for i in 0 to 10 loop
        draw.drawSquare(square_x + i*(space+square_size), square_y, square_size);
      end loop;
      square_x := 0 + offset;
    end loop;

		draw.show("squarecircle.ppm");
		wait;
	end process;

end architecture;
