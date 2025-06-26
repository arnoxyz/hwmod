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

    procedure draw_rectangle_line(line : natural) is
      variable idx : natural := 0;
    begin
      draw.setColor(Red);
      if (line mod 2) = 1 then
        draw.setColor(Green);
        idx := idx+(1*rect_width);
      end if;

      rect_y := rect_y + rect_height;

      while idx < window_width loop
        rect_x := idx;
        draw.fillRectangle(rect_x,rect_y,rect_width,rect_height);
        idx := idx+(2*rect_width);
      end loop;

      rect_x := 0;
    end procedure;

	begin
		draw.init(window_width, window_height);

    -- draw full background
    rect_x := 0;
    rect_y := 0;
    for idx in 0 to (window_height/rect_height) loop
      draw_rectangle_line(idx);
    end loop;

		draw.show("ouchi.ppm");
		wait;
	end process;

end architecture;
