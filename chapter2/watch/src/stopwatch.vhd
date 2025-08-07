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
  signal cnt : unsigned(31 downto 0);
  signal cnt_nxt : unsigned(31 downto 0);

begin
  sync : process(clk, res_n) is
  begin
    if res_n = '0' then
      seconds <= (others=>'0');
      cnt <= (others=>'0');
    elsif rising_edge(clk) then
      cnt <= cnt_nxt;
    end if;
  end process;

  comb : process(all) is
  begin
      cnt_nxt <= cnt + 1;
  end process;
end architecture;
