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
    for i in 0 to 9 loop
      if i mod 2 = 0 then
        draw.setColor(Blue);
      else
        draw.setColor(Green);
      end if;

      draw.fillSquare(square_x + i*square_size, square_y, square_size);
    end loop;


		draw.show("checkerboard.ppm");
		wait;
	end process;

end architecture;
