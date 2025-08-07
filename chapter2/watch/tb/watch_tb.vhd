library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

use work.math_pkg.all;

entity watch_tb is
end entity;

architecture tb of watch_tb is
	constant CLK_PERIOD : time := 20 ns;  -- Change as required
  signal clk_stop : std_ulogic := '0';

	constant DIGITS : integer := 2;
  component stopwatch is
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
  end component;

  --in
	signal clk : std_ulogic := '0';
  signal res_n : std_ulogic := '0';
  signal start_n : std_ulogic;
  signal stop_n  : std_ulogic;
  --out
  signal seconds : unsigned(log2c(10**DIGITS)-1 downto 0);

begin

	stimulus : process begin
    report "start sim";
    res_n <= '0';
    wait until rising_edge(clk);
    res_n <= '1';
    wait for 10*clk_period;

    clk_stop <= '1';
    report "sim done";
		wait;
	end process;

  uut_stopwatch : stopwatch
   generic map(
      CLK_PERIOD => CLK_PERIOD,
      DIGITS => DIGITS
    )
    port map(
      clk     => clk,
      res_n   => res_n,
      start_n => start_n,
      stop_n  => stop_n,
      seconds => seconds
    );

	clk_gen : process begin
    clk <= '0';
    wait for CLK_PERIOD / 2;
    clk <= '1';
    wait for CLK_PERIOD / 2;

    if clk_stop = '1' then
      wait;
    end if;
	end process;
end architecture;
