library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity simplecalc_tb is
end entity;

architecture bench of simplecalc_tb is
    -- for clk gen
    constant clk_period : time := 1 ns;
    signal clk_stop    : std_ulogic := '0';

    constant DATA_WIDTH : natural := 8;
    --in
    signal clk    : std_ulogic;
    signal res_n  : std_ulogic := '0';
    signal operand_data_in : std_ulogic_vector(DATA_WIDTH-1 downto 0) := (others=>'0');
    signal store_operand1  : std_ulogic := '1';
    signal store_operand2  : std_ulogic := '1';
    signal sub : std_ulogic := '0';
    --out
    signal operand1 : std_ulogic_vector(DATA_WIDTH-1 downto 0);
    signal operand2 : std_ulogic_vector(DATA_WIDTH-1 downto 0);
    signal result   : std_ulogic_vector(DATA_WIDTH-1 downto 0);

  component simplecalc is
    generic (
      DATA_WIDTH : natural := 8
    );
    port(
      clk    : in std_ulogic;
      res_n  : in std_ulogic;

      operand_data_in : in std_ulogic_vector(DATA_WIDTH-1 downto 0);
      store_operand1  : in std_ulogic;
      store_operand2  : in std_ulogic;

      sub : in std_ulogic;

      operand1 : out std_ulogic_vector(DATA_WIDTH-1 downto 0);
      operand2 : out std_ulogic_vector(DATA_WIDTH-1 downto 0);
      result   : out std_ulogic_vector(DATA_WIDTH-1 downto 0)
    );
  end component;
begin
	-- Instantiate the unit under test
  UUT : simplecalc
  generic map( DATA_WIDTH  => DATA_WIDTH )
  port map(
      clk    => clk,
      res_n  => res_n,
      operand_data_in => operand_data_in,
      store_operand1  => store_operand1,
      store_operand2  => store_operand2,
      sub => sub,
      operand1 => operand1,
      operand2 => operand2,
      result   => result
  );

	-- Stimulus process
	stimulus: process
	begin
		report "simulation start";
		-- Apply test stimuli
    res_n <= '0';
		wait for 10 ns;
    res_n <= '1';
    wait until rising_edge(clk);
    sub <= '0';
    store_operand1 <= '0';
    operand_data_in <= (0 => '1', others=>'0');
		wait for 2*clk_period;
    store_operand2 <= '0';
    operand_data_in <= (0 => '1', others=>'0');
    report "operation 1";
		wait for 2*clk_period;
    store_operand1 <= '1';
    store_operand2 <= '1';

    --add 1+1 = 2
    assert unsigned(result) = (unsigned(operand1)+unsigned(operand2));
    sub <= '1';
    report "operation 2";
		wait for 2*clk_period;
    --sub 1-1 = 0
    assert unsigned(result) = (unsigned(operand1)-unsigned(operand2));

		wait for 2*clk_period;
    sub <= '0';
    store_operand1 <= '0';
    operand_data_in <= (0 => '1', 1 => '1', others=>'0');
    report "operation 3";
		wait for 2*clk_period;
    --add 1+3 = 4
    assert unsigned(result) = (unsigned(operand1)+unsigned(operand2));

    sub <= '1';
    store_operand2 <= '0';
    operand_data_in <= (0 => '1', 1 => '1', others=>'0');
    report "operation 4";
		wait for 10 ns;
    --sub 3-3 = 0
    assert unsigned(result) = (unsigned(operand1)-unsigned(operand2));

		report "simulation end";
		-- End simulation
    clk_stop <= '1';
		wait;
	end process;

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
