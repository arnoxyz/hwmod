use work.vhdldraw_pkg.all;

entity squarecircle is
end entity;

architecture arch of squarecircle is
begin
	process is
		constant window_size : natural := 600;
		variable draw: vhdldraw_t;


	begin
		draw.init(window_size);
		-- draw the illusion here
		draw.show("squarecircle.ppm");
		wait;
	end process;

end architecture;
