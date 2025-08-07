library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.math_pkg.all;

entity stopwatch is
	generic (
		CLK_PERIOD : time;
		DIGITS : integer
	);
	port (
		clk     : in std_ulogic;
		res_n   : in std_ulogic;
		start_n : in std_ulogic;
		stop_n  : in std_ulogic;
		seconds : out unsigned(log2c(10**DIGITS)-1 downto 0)
	);
end entity;

architecture arch of stopwatch is
begin
  sync : process(clk, res_n) is
  begin
    if res_n = '0' then
    elsif rising_edge(clk) then
    end if;
  end process;

  comb : process(all) is
  begin
  end process;
end architecture;
