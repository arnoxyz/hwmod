use work.vhdldraw_pkg.all;

entity creative is
end entity;

architecture arch of creative is
begin
	main : process is
		variable draw : vhdldraw_t;
    constant WIDTH : integer := 800;
    constant HEIGHT : integer := 800;

    constant bar_height : integer := 20;
    constant bar_width : integer := 20;

    constant marging : integer := 20;
    constant offset : integer := 60;

    constant gold : color_t := create_color(255,215,0);
    constant ghost_white : color_t := create_color(248, 248, 255);
    variable idx : integer := 30;
	begin
		draw.init(width, height);
    draw.clear(ghost_white);


    -- blue bars
    draw.setColor(blue);
    draw.fillRectangle(marging,65,(WIDTH-2*marging),bar_height);
    draw.fillRectangle(marging,width-70,(WIDTH-2*marging),bar_height);
    draw.fillRectangle(60,marging,bar_width,height);


    -- draw horizontal bars
    draw.setColor(red);
    draw.fillRectangle(marging,offset-20,(WIDTH-2*marging),bar_height);

    draw.setColor(gold);
    while idx <= HEIGHT loop
      draw.fillRectangle(marging,idx+offset,(WIDTH-2*marging),bar_height);
      idx := idx+idx;


    end loop;
    idx := 0;

    draw.fillRectangle(marging,height-180,(WIDTH-2*marging),bar_height);
    draw.fillRectangle(marging,height-120,(WIDTH-2*marging),bar_height);
    draw.fillRectangle(marging,height-40,(WIDTH-2*marging),bar_height);

    -- draw vertical bars
    for i in 0 to 10 loop
      if (i mod 2) = 1 then
        draw.setColor(gold);
      else
        draw.setColor(red);
      end if;
      
      if i = 4 then 
        draw.setColor(red);
        draw.fillRectangle(marging,width-230,(WIDTH-2*marging),bar_height);
      elsif i = 3 then 
        draw.setColor(blue);
        draw.fillRectangle(marging,width-530,(WIDTH-2*marging),bar_height);
      end if;

        draw.fillRectangle(width-i*offset,marging,bar_width,height);
    end loop;




		draw.show("creative.ppm");
		wait;
	end process;
end architecture;
