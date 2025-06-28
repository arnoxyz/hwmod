use work.vhdldraw_pkg.all;

entity concentric is
end entity;

architecture arch of concentric is
begin
	process is
		constant window_width : natural := 840;
		constant window_height : natural := 480;
		variable vhdldraw : vhdldraw_t;

	begin
		vhdldraw.init(window_width, window_height);
		-- draw the illusion here
		vhdldraw.show("concentric.ppm");
		wait;
	end process;

end architecture;
