library ieee;
use ieee.std_logic_1164.all;

entity running_light_tb is
end entity;

architecture arch of running_light_tb is
	constant CLK_PERIOD : time := 20 ns;
	constant STEP_TIME: time := 100 ns;

  --in
	signal clk_stop : std_ulogic := '0';
	signal clk : std_ulogic;
  signal res_n : std_ulogic;

  --out
	signal leds : std_ulogic_vector(7 downto 0);

  component running_light is
    generic (
      STEP_TIME  : time := 1 sec
    );
    port (
      clk      : in std_ulogic;
      res_n    : in std_ulogic;
		  leds     : out std_ulogic_vector(7 downto 0)
    );
  end component;
begin

  stimulus : process is
  begin
    report "start sim";
    res_n <= '0';
    wait until rising_edge(clk);
    res_n <= '1';
    wait for 100*clk_period;

    clk_stop <= '1';
    report "done sim";
    wait;
  end process;

	uut : running_light
	generic map (
		STEP_TIME => STEP_TIME
	)
	port map (
		clk => clk,
		res_n => res_n,
		leds => leds
	);

	clk_gen : process is
	begin
    clk <= '0';
    wait for clk_period/2;
    clk <= '1';
    wait for clk_period/2;

    if clk_stop = '1' then
      wait;
    end if;
	end process;
end architecture;
