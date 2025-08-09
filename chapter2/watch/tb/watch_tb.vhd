library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

use work.math_pkg.all;
use work.bin2dec_pkg.all;

entity watch_tb is
end entity;

architecture tb of watch_tb is
	constant DIGITS : integer := 4;

	constant CLK_PERIOD : time := 10 ms;
  signal clk_stop : std_ulogic := '0';

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

  --stopwatch
  --in
	signal clk : std_ulogic := '0';
  signal res_n : std_ulogic := '1';
  signal start_n : std_ulogic := '1';
  signal stop_n  : std_ulogic := '1';
  --out
  signal seconds : unsigned(log2c(10**DIGITS)-1 downto 0);

	--bin2dec
	constant SSD_DIGITS : integer := DIGITS;
  --in
  signal binary : unsigned(log2c(10**SSD_DIGITS)-1 downto 0) := (others=>'0');

  --out
    --dec_digit_t = 4 bit unsigned to store 1 digit,
    --dec_digits_t = array of digits
	signal decimal : dec_digits_t(SSD_DIGITS-1 downto 0) := (others => (others=>'0'));



begin

	stimulus : process
    procedure press_btn(signal btn_name_n : out std_ulogic; pulse_width : integer) is
    begin
      btn_name_n <= '1';
      wait for 2*clk_period;
      btn_name_n <= '0';
      wait for pulse_width*clk_period;
      btn_name_n <= '1';
      wait for 2*clk_period;
    end procedure;

    procedure test_stopwatch is
    begin
      res_n <= '0';
      wait until rising_edge(clk);
      res_n <= '1';

      --start clk-counter
      press_btn(start_n, 15);
      wait until to_integer(seconds) = 5;
      --wait for 1000*clk_period;

      --stop clk-counter
      press_btn(stop_n, 5);
      wait for 10*clk_period;

      --restart clk-counter (continues to count)
      press_btn(start_n, 15);
      wait until to_integer(seconds) = 9; --max value for 1 digit

      --continue counting should just let display the max value
      wait for 10*clk_period;

      --stop clk-counter
      press_btn(stop_n, 5);
      wait for 10*clk_period;

      --stop clk-counter (stop again while in stop resets the clk to 0)
      press_btn(stop_n, 5);
      wait for 10*clk_period;
    end procedure;


    procedure set_binary_input(value : integer) is
    begin
			binary  <= to_unsigned(value,binary'length);
      wait for 10*clk_period;
    end procedure;

    procedure test_bin2dec is
    begin
      res_n <= '0';
      wait until rising_edge(clk);
      res_n <= '1';
      set_binary_input(1);
      set_binary_input(432);
      set_binary_input(891);
      set_binary_input(1891);
      set_binary_input(0);
      set_binary_input(5);
      wait;
    end procedure;

  begin
    report "start sim";
    test_stopwatch;
    test_bin2dec;

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

  uut_bin2dec : bin2dec
  generic map(
	  SSD_DIGITS => SSD_DIGITS
  )
  port map(
			clk     => clk,
			res_n   => res_n,
			binary  => binary,
			decimal => decimal
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
