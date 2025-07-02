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
    draw.setColor(Green);
    draw.fillRectangle(0,0, window_width, window_height);

    for j in 0 to rows-1 loop
      square_y := j*square_size;

      --draw square line
      draw.setColor(Blue);
      for i in 0 to cols-1 loop
        if j mod 2 = 1 then
          square_x := square_size;
        end if;
        draw.fillSquare(square_x + i*2*square_size, square_y, square_size);

      end loop;
      square_x := 0;
    end loop;


		draw.show("checkerboard.ppm");
		wait;
	end process;

end architecture;
