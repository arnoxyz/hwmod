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

    procedure draw_chessboard is
      constant cols : natural := 8;
      constant rows : natural := 8;
      constant window_width : natural := cols*size;
      constant window_height : natural := rows*size;
    begin
      draw.init(window_width, window_height);
      draw.setColor(Black);
      draw.fillRectangle(0,0, window_width, window_height);

      for j in 0 to rows-1 loop
        square_y := j*square_size;

        draw.setColor(White);
        for i in 0 to cols-1 loop
          if j mod 2 = 1 then
            square_x := square_size;
          end if;
          draw.fillSquare(square_x + i*2*square_size, square_y, square_size);
        end loop;
        square_x := 0;
      end loop;
      draw.show("chessboad.ppm");
    end procedure;

    procedure draw_background is
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
    end procedure;

    procedure draw_horizontal_rectangle(x : natural; y : natural) is
     constant rect_width  : natural := 4;
     constant rect_height : natural := 20;
     constant offset : natural := square_size;

      variable rect_x : natural := x + offset-(rect_width/2);
      variable rect_y : natural := y + offset-(rect_height/2);

    begin
      draw.setColor(Black);
      draw.fillRectangle(rect_x, rect_y, rect_width, rect_height);
    end procedure;


	begin
    --draw_chessboard;

    draw_background;
    draw_horizontal_rectangle(0,0);

		draw.show("checkerboard.ppm");
		wait;
	end process;

end architecture;
