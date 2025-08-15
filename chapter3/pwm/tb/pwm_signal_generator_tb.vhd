library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity pwm_signal_generator_tb is
end entity;

architecture tb of pwm_signal_generator_tb is
  --clk
  constant CLK_PERIOD : time := 2 ns; --50 MHz => 20 ns
  signal clk_stop : std_ulogic := '0';
	signal clk : std_ulogic;
 signal  res_n : std_ulogic := '0';

  --generics
	constant COUNTER_WIDTH : integer := 8;
  --in
  signal en : std_ulogic := '0';
	signal value : std_ulogic_vector(COUNTER_WIDTH-1 downto 0) := (others=>'0');
  --out
	signal pwm_out : std_ulogic;

  component pwm_signal_generator is
    generic (
      COUNTER_WIDTH : integer := 8
    );
    port (
      clk        : in std_ulogic;
      res_n      : in std_ulogic;
      en         : in std_ulogic;
      value      : in std_ulogic_vector(COUNTER_WIDTH-1 downto 0);
      pwm_out    : out std_ulogic
    );
  end component;

begin

	stimulus : process
		procedure check_pwm_signal(low_time, high_time: time) is
		begin
      --TODO: implement procedure
		end procedure;

	begin
      report "sim start";
      res_n <= '0';
      wait for 2*clk_period;
      res_n <= '1';
      wait for 10*clk_period;


      clk_stop <= '1';
      report "sim done";
      wait;
	end process;

	uut : pwm_signal_generator
		generic map (
			COUNTER_WIDTH => COUNTER_WIDTH
		)
		port map (
			clk     => clk,
			res_n   => res_n,
			en      => en,
			value   => value,
			pwm_out => pwm_out
		);

	clk_gen: process
	begin
    clk <= '0';
    wait for CLK_PERIOD / 2;
    clk <= '1';
    wait for CLK_PERIOD / 2;

    if clk_stop = '1' then
      wait;
    end if;
	end process;
end architecture;
