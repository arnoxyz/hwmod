use work.vhdldraw_pkg.all;

entity ouchi is
end entity;

architecture arch of ouchi is
begin
	process is
		constant window : natural := 800;
		constant window_height : natural := 800;
		constant window_width : natural := 800;

		variable draw : vhdldraw_t;

    constant rect_width : natural := 32;
    constant rect_height : natural := 8;
    variable rect_x,rect_y : natural := 0;

    constant window_center_width : natural := 200;
    constant window_center_height : natural := 224;

    constant rect_center_width : natural := 8;
    constant rect_center_height : natural := 32;
    variable rect_center_x : natural := (window_width/2)-window_center_width/2;
    variable rect_center_y : natural := (window_height/2)-window_center_height/2;

    procedure draw_rectangle_line(line : natural) is
      variable idx : natural := 0;
    begin
      draw.setColor(Red);
      if (line mod 2) = 1 then
        draw.setColor(Green);
        idx := idx+(1*rect_width);
      end if;


      while idx < window_width loop
        rect_x := idx;
        draw.fillRectangle(rect_x,rect_y,rect_width,rect_height);
        idx := idx+(2*rect_width);
      end loop;

      rect_y := rect_y + rect_height;
      rect_x := 0;
    end procedure;

    procedure draw_rectangle_line_center(line : natural) is
      variable idx : natural := 0;
      constant offset : natural := (window_width/2)-window_center_width/2;
    begin
      draw.setColor(Blue);
      if (line mod 2) = 1 then
        draw.setColor(Yellow);
        idx := idx+(1*rect_center_width);
      end if;

      while idx < window_center_width loop
        rect_center_x := offset + idx;
        draw.fillRectangle(rect_center_x,rect_center_y,rect_center_width,rect_center_height);
        idx := idx+(2*rect_center_width);
      end loop;

      rect_center_y := rect_center_y + rect_center_height;
      rect_center_x := (window_width/2)-window_center_width/2;
    end procedure;

	begin
		draw.init(window_width, window_height);

    -- draw full background
    rect_x := 0;
    rect_y := 0;
    for idx in 0 to (window_height/rect_height) loop
      draw_rectangle_line(idx);
    end loop;

    -- draw rectangle in the middle
    draw.setColor(White);
    draw.fillRectangle(rect_center_x,rect_center_y, window_center_width,window_center_height);

    -- draw rectangle line in the middle
    draw_rectangle_line_center(0);

		draw.show("ouchi.ppm");
		wait;
	end process;
end architecture;
