library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity lfsr_tb is
end entity;

architecture tb of lfsr_tb is
  --for testcases
	constant MAX_POLY_8  : std_ulogic_vector(7 downto 0)  := "10111000";
	--constant POLY_8      : std_ulogic_vector(7 downto 0)  := "10100100";
	--constant MAX_POLY_16 : std_ulogic_vector(15 downto 0) := "1101000000001000";
	--constant POLY_16     : std_ulogic_vector(15 downto 0) := "1101001100001000";

  --generics
	constant POLYNOMIAL : std_ulogic_vector := MAX_POLY_8;
	constant LFSR_WIDTH : integer := POLYNOMIAL'LENGTH;

  -- local shift reg to save output data (prdata)
  signal shift_reg : std_ulogic_vector(LFSR_WIDTH-1 downto 0);

  --clk gen
  constant clk_period : time := 2 ns; --50Mhz => 20ns but for sim i just take 2 ns for now
  signal clk_stop : std_ulogic := '0';
	signal clk, res_n : std_ulogic := '0';


  --in
	signal load_seed_n  : std_ulogic := '1';
	signal seed : std_ulogic_vector(LFSR_WIDTH-1 downto 0) := (others => '0');
	constant seed_val : std_ulogic_vector(LFSR_WIDTH-1 downto 0) := (0 => '1', others => '0');
  --out
	signal prdata : std_ulogic;
begin

	stimulus : process is
	begin
    report "start sim";
    res_n <= '0';
    wait for 2 * clk_period;
    res_n <= '1';
    load_seed_n <= '0';
    seed <= seed_val;
    wait for 2 * clk_period;
    res_n <= '0';
    load_seed_n <= '1';
    wait for clk_period;
    res_n <= '1';
    --wait until prdata = '1';
    wait for 100*clk_period;

    clk_stop <= '1';
		wait;
    report "sim done";
	end process;

	uut : entity work.lfsr
	generic map (
		LFSR_WIDTH => LFSR_WIDTH,
		POLYNOMIAL => POLYNOMIAL
	)
	port map (
		clk => clk,
		res_n => res_n,
		load_seed_n => load_seed_n,
		seed => seed,
		prdata => prdata
	);

  sync : process(clk, res_n) is
  begin
    if res_n = '0' then
      shift_reg <= (others=>'0');
    elsif rising_edge(clk) then

      if load_seed_n = '1' then
        shift_reg(0) <= prdata;
        for i in 1 to LFSR_WIDTH-1 loop
          shift_reg(i) <= shift_reg(i-1);
        end loop;
      end if;
    end if;
  end process;

	clk_gen : process is
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
