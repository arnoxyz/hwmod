use work.vhdldraw_pkg.all;

entity illusions is
end entity;


architecture arch of illusions is
begin
	ouchi : entity work.ouchi;
	concentric : entity work.concentric;
	squarecircle : entity work.squarecircle;
	checkerboard : entity work.checkerboard;
end architecture;
