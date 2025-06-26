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

    procedure draw_rectangle_line(y : natural) is
      variable idx : natural := 0;
    begin
      draw.setColor(Black);
      while idx < window_width loop
        draw.fillRectangle(idx,y,rect_width,rect_height);
        idx := idx+(2*rect_width);
      end loop;
    end procedure;

    variable idx : integer := 0;
	begin

		draw.init(window_width, window_height);

    while idx < window_height loop
      draw_rectangle_line(idx);
      idx := idx+rect_height;
    end loop;

		draw.show("ouchi.ppm");
		wait;
	end process;

end architecture;
