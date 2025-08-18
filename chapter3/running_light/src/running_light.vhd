library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

use work.math_pkg.all;

entity running_light is
	generic (
		STEP_TIME  : time := 1 sec
	);
	port (
		clk      : in std_ulogic;
		res_n    : in std_ulogic;
		leds     : out std_ulogic_vector(7 downto 0)
	);
end entity;

architecture beh of running_light is
  signal counter : unsigned(31 downto 0);
  signal counter_nxt : unsigned(31 downto 0);

begin
  leds <= (others=>'1');

  sync : process(clk, res_n) is
  begin
    if res_n = '0' then
      counter <= (others=>'0');
    elsif rising_edge(clk) then
      counter <= counter_nxt;
    end if;
  end process;

  comb : process(all) is
  begin
    counter_nxt <= counter + 1;
  end process;
end architecture;
