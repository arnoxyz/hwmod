library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.math_pkg.all;
use work.util_pkg.all;
use work.bin2dec_pkg.all;

architecture top_arch of top is
  constant CLK_PERIOD_BOARD : time := 20 ns; --50 MHz => 20 ns
  constant CLK_PERIOD_PLL : time := 50 ns; --20 MHz => 50 ns
	constant CLK_PERIOD : time := CLK_PERIOD_BOARD; -- make sure this is set according to the clock you use!

	constant SSD_DIGITS : integer := 4;
  signal seconds_u : unsigned(log2c(10**SSD_DIGITS)-1 downto 0);

	signal clk_20 : std_ulogic;  -- 20 MHz clock
	signal res_n  : std_ulogic;
	signal dec_digits : dec_digits_t(7 downto 0) := (others => (others => '0'));

	component pll_20MHz is
		port (
			inclk0 : in std_logic := '0';
			c0     : out std_logic
		);
	end component;

	component bin2dec is
		generic(
			SSD_DIGITS : integer
		);
		port(
			clk     : in std_ulogic;
			res_n   : in std_ulogic;
			binary  : in unsigned;
			decimal : out dec_digits_t
		);
	end component;

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

begin

	res_n <= keys(0);

	pll_inst : pll_20MHz
	port map(
		inclk0 => clk,
		c0     => clk_20
	);

  stopwatch_inst : stopwatch
  generic map(
    CLK_PERIOD => CLK_PERIOD,
    DIGITS => SSD_DIGITS
  )
  port map(
    clk     => clk,
    res_n   => res_n,
    start_n => keys(1),
    stop_n  => keys(2),
    seconds => seconds_u
  );

  ledr(log2c(10**SSD_DIGITS)-1 downto 0) <= std_ulogic_vector(seconds_u);

	bin2dec_inst : bin2dec
  generic map(
    SSD_DIGITS => SSD_DIGITS
  )
  port map(
    clk     => clk,
    res_n   => res_n,
    binary  => seconds_u,
    decimal => dec_digits(SSD_DIGITS-1 downto 0)
  );

	hex0 <= to_segs(std_ulogic_vector(dec_digits(0)));
	hex1 <= to_segs(std_ulogic_vector(dec_digits(1)));
	hex2 <= to_segs(std_ulogic_vector(dec_digits(2)));
	hex3 <= to_segs(std_ulogic_vector(dec_digits(3)));

	hex4 <= to_segs(std_ulogic_vector(dec_digits(4)));
	hex5 <= to_segs(std_ulogic_vector(dec_digits(5)));
	hex6 <= to_segs(std_ulogic_vector(dec_digits(6)));
	hex7 <= to_segs(std_ulogic_vector(dec_digits(7)));

end architecture;
