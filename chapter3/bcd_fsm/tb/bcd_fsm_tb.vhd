library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

use work.util_pkg.all;

entity bcd_fsm_tb is
end entity;

architecture tb of bcd_fsm_tb is
  --clk
  constant CLK_PERIOD : time := 2 ns;

  signal clk         : std_ulogic;
  signal res_n       : std_ulogic := '0';
  signal clk_stop    : std_ulogic := '0';

  --in
	signal input_data : std_ulogic_vector(15 downto 0);
	signal signed_mode : std_ulogic;

  --out
	signal hex_digit1000, hex_digit100, hex_digit10, hex_digit1, hex_sign: std_ulogic_vector(6 downto 0);

  component bcd_fsm is
    port(
      clk         : in std_ulogic;
      res_n       : in std_ulogic;

      input_data  : in std_ulogic_vector(15 downto 0);
      signed_mode : in std_ulogic;

      hex_digit1     : out std_ulogic_vector(6 downto 0);
      hex_digit10    : out std_ulogic_vector(6 downto 0);
      hex_digit100   : out std_ulogic_vector(6 downto 0);
      hex_digit1000  : out std_ulogic_vector(6 downto 0);
      hex_sign       : out std_ulogic_vector(6 downto 0)
    );
  end component;

begin
	stimulus : process
	begin
    report "sim start";
    res_n <= '0';
    wait until rising_edge(clk);
    res_n <= '1';
    wait for 100*clk_period;

    clk_stop <= '1';
    wait;
    report "done sim ";
	end process;

	uut : entity work.bcd_fsm
		port map (
			clk           => clk,
			res_n         => res_n,
			input_data    => input_data,
			signed_mode   => signed_mode,
			hex_digit1000 => hex_digit1000,
			hex_digit100  => hex_digit100,
			hex_digit10   => hex_digit10,
			hex_digit1    => hex_digit1,
			hex_sign      => hex_sign
		);

	clk_gen : process
	begin
    clk <= '0';
    wait for clk_period / 2;
    clk <= '1';
    wait for clk_period / 2;

    if clk_stop = '1' then
      wait;
    end if;
	end process;
end architecture;
