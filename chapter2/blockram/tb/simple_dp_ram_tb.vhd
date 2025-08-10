library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use std.textio.all;

entity simple_dp_ram_tb is
end entity;

architecture tb of simple_dp_ram_tb is
  --clk stuff
	constant CLK_PERIOD : time := 20 ns;
	signal clk_stop : std_ulogic := '0';
	signal clk : std_ulogic := '0';
  signal res_n : std_ulogic := '0';

  --generics
  constant ADDR_WIDTH : positive := 8;
  constant DATA_WIDTH : positive := 32;

  --in
  signal rd_addr : std_ulogic_vector(ADDR_WIDTH - 1 downto 0);
  signal wr_en   : std_ulogic;
  signal wr_addr : std_ulogic_vector(ADDR_WIDTH - 1 downto 0);
  signal wr_data : std_ulogic_vector(DATA_WIDTH - 1 downto 0);

  --out
  signal rd_data : std_ulogic_vector(DATA_WIDTH - 1 downto 0);

  component simple_dp_ram is
    generic (
      ADDR_WIDTH : positive := 8;
      DATA_WIDTH : positive := 32
    );
    port (
      clk   : in std_ulogic;
      res_n : in std_ulogic;

      rd_addr : in std_ulogic_vector(ADDR_WIDTH - 1 downto 0);
      rd_data : out std_ulogic_vector(DATA_WIDTH - 1 downto 0);

      wr_en   : in std_ulogic;
      wr_addr : in std_ulogic_vector(ADDR_WIDTH - 1 downto 0);
      wr_data : in std_ulogic_vector(DATA_WIDTH - 1 downto 0)
    );
  end component;

begin
	-- Stimulus process to handle file I/O and write to RAM
	stimulus : process
	begin
		res_n <= '0';
		wait for 10 ns;
		-- End simulation
		std.env.stop;

	  clk_stop <= '1';
    wait;
	end process;

	-- instantiate uut
  UUT : simple_dp_ram
  generic map(
    ADDR_WIDTH => ADDR_WIDTH,
    DATA_WIDTH => DATA_WIDTH
  )
  port map(
    clk   => clk,
    res_n => res_n,
    rd_addr => rd_addr,
    rd_data => rd_data,
    wr_en   => wr_en,
    wr_addr => wr_addr,
    wr_data => wr_data
  );

	-- Clock generation process
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
