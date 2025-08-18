library ieee;
use ieee.std_logic_1164.all;

architecture top_arch of top is
  constant STEP_TIME  : time := 1 sec;
  constant CLK_PERIOD: time := 20 ns; -- f = 50 MHz
begin

	no_fsm_no_problem_inst : entity work.running_light(beh_no_fsm)
	generic map(
		STEP_TIME => STEP_TIME,
    CLK_PERIOD => CLK_PERIOD
	)
	port map (
		clk => clk,
		res_n => keys(0),
		leds => ledr(7 downto 0)
	);

	fsm_inst : entity work.running_light(beh_fsm)
	generic map(
		STEP_TIME => STEP_TIME,
    CLK_PERIOD => CLK_PERIOD
	)
	port map (
		clk => clk,
		res_n => keys(0),
		leds => ledr(15 downto 8)
	);
end architecture;

