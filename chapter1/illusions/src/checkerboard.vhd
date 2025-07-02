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
      draw.show("chessboard.ppm");
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
      draw.fillRectangle(rect_x, rect_y, rect_width, rect_height);
    end procedure;

    procedure draw_vertical_rectangle(x : natural; y : natural) is
     constant rect_width  : natural := 20;
     constant rect_height : natural := 4;
     constant offset : natural := square_size;

      variable rect_x : natural := x + offset-(rect_width/2);
      variable rect_y : natural := y + offset-(rect_height/2);

    begin
      draw.fillRectangle(rect_x, rect_y, rect_width, rect_height);
    end procedure;


	begin
    --draw_chessboard;

    draw_background;

    -- draw full board with white rectangles
    for j in 0 to rows-2 loop
      for i in 0 to cols-2 loop
        draw.setColor(White);
        if (j mod 2) = 0 then
          if (i mod 2) = 0 then
            draw_vertical_rectangle(square_size*i,square_size*j);
          else
            draw_horizontal_rectangle(square_size*i,square_size*j);
          end if;
        else
          if (i mod 2) = 0 then
            draw_horizontal_rectangle(square_size*i,square_size*j);
          else
            draw_vertical_rectangle(square_size*i,square_size*j);
          end if;
        end if;
      end loop;
    end loop;

    -- draw full board with black rectangles
    for j in 0 to rows-2 loop
      for i in 0 to cols-2 loop
        draw.setColor(Black);
        if (j mod 2) = 0 then
          if (i mod 2) = 0 then
            draw_horizontal_rectangle(square_size*i,square_size*j);
          else
            draw_vertical_rectangle(square_size*i,square_size*j);
          end if;
        else
          if (i mod 2) = 0 then
            draw_vertical_rectangle(square_size*i,square_size*j);
          else
            draw_horizontal_rectangle(square_size*i,square_size*j);
          end if;
        end if;
      end loop;
    end loop;


		draw.show("checkerboard.ppm");
		wait;
	end process;

end architecture;
