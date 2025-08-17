use ieee.std_logic_1164.all;

architecture top_arch of top is
	constant COUNTER_WIDTH : integer := 8;
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

	pwm_signal_generator_inst : pwm_signal_generator
		generic map (
			COUNTER_WIDTH => COUNTER_WIDTH
		)
		port map (
			clk     => clk,
			res_n   => keys(0),
			en      => switches(17),
			value   => switches(7 downto 0),
			pwm_out => pwm_out
		);

	ledg(0) <= pwm_out;

	-- top-right GPIO pin (GPIO[1] in datasheet/task description)
	aux(0) <= pwm_out;
end architecture;
