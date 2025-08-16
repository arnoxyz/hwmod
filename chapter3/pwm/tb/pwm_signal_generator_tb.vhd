library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity pwm_signal_generator_tb is
end entity;

architecture tb of pwm_signal_generator_tb is
  --clk
  constant CLK_FREQUENCY : integer := 1_000_000; -- 1MHz
  constant CLK_PERIOD : time := 1 sec / CLK_FREQUENCY;
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
    procedure basic_testcase is
    begin
      res_n <= '0';
      wait for 2*clk_period;
      res_n <= '1';
      wait for 10*clk_period;
      en <= '1';
      report "start cnt";
      wait for 2*clk_period;
      en <= '0';
      wait for 2*clk_period;
      en <= '1';
      wait for 2*clk_period;
      en <= '0';
      wait for 10*clk_period;
      en <= '1';
      wait for 2*clk_period;
      en <= '0';
      wait for 10*clk_period;
    end procedure;

		procedure check_pwm_signal(low_time, high_time: time) is
      --variable low : integer := (low_time / 1 us);
      --variable high : integer := (high_time / 1 us);
      --variable total : integer := 0;

		begin
      --report to_string(low/high);
      --report to_string(low_time / 1 us);
      --report to_string(high_time / 1 us);
      --report to_string((low_time / 1 ns) / (high_time / 1 ns));

      --total time
      report to_string((low_time / 1 us) + (high_time / 1 us));
      report "---";
		end procedure;

    procedure sophisticated_testcase is
	    constant MAX_VALUE : unsigned(COUNTER_WIDTH-1 downto 0) := (others=>'1');
      variable start_time : time;
      variable low_time : time;  --time from pwm_out is '0' until pwm_out is '1'
      variable high_time : time; --time pwm_out is '1' until '0' again (overflow)
    begin
      res_n <= '0';
      en <= '0';
      wait until rising_edge(clk);
      res_n <= '1';

      for idx in 1 to to_integer(MAX_VALUE) loop
        en <= '1';
        value <= std_logic_vector(to_unsigned(idx, COUNTER_WIDTH));
        wait for 2*clk_period;
        start_time := now;

        wait until rising_edge(pwm_out);
        low_time := (now-start_time);
        start_time := now;
        en <= '0';

        wait until falling_edge(pwm_out);
        high_time := now-start_time;
        check_pwm_signal(low_time,high_time);
      end loop;
    end procedure;

	begin
      report "sim start";
      --basic_testcase; --check en,cnt,
      sophisticated_testcase; --full check

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
