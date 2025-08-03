library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.sorting_network_pkg.all;
use work.util_pkg.all;

architecture top_arch_sorting_network of top is
  constant DATA_WIDTH : natural := 4;
  signal sorted_data : std_ulogic_vector(DATA_WIDTH*4-1 downto 0);

begin
  sorting_network_inst : sorting_network
  generic map( DATA_WIDTH => 4 )
  port map(
    clk      => clk,
    res_n    => keys(0),
    unsorted_data => switches(15 downto 0),
    start => keys(3),
    sorted_data  => sorted_data,
    done  => ledg(0)
  );

  hex7 <= to_segs(switches(DATA_WIDTH*4-1 downto DATA_WIDTH*3));
  hex6 <= to_segs(switches(DATA_WIDTH*3-1 downto DATA_WIDTH*2));
  hex5 <= to_segs(switches(DATA_WIDTH*2-1 downto DATA_WIDTH));
  hex4 <= to_segs(switches(DATA_WIDTH-1 downto 0));

  hex3 <= to_segs(sorted_data(DATA_WIDTH*4-1 downto DATA_WIDTH*3));
  hex2 <= to_segs(sorted_data(DATA_WIDTH*3-1 downto DATA_WIDTH*2));
  hex1 <= to_segs(sorted_data(DATA_WIDTH*2-1 downto DATA_WIDTH));
  hex0 <= to_segs(sorted_data(DATA_WIDTH-1 downto 0));

end architecture;
