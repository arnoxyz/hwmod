library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

use work.sorting_network_pkg.all;

entity sorting_network_tb is
end entity;

architecture arch of sorting_network_tb is
  constant DATA_WIDTH : natural := 32;

  --clk_gen
  constant clk_period : time := 2 ns;
  signal clk_stop : std_ulogic := '0';

  --in
  signal clk      : std_ulogic := '0';
  signal res_n    : std_ulogic := '1';
  signal unsorted_data : std_ulogic_vector(DATA_WIDTH*4-1 downto 0) := (others=>'0');
  signal start : std_ulogic := '0';
  --out
  signal sorted_data   : std_ulogic_vector(DATA_WIDTH*4-1 downto 0);
  signal done  : std_ulogic;

begin
  stimulus : process is
  begin
    report "start sim";
    unsorted_data <= x"00000001_00000010_00000100_00001000";
    -- set values:
    --32 bit = in hex => x"FFFF_FFFF" per line
    res_n <= '0';
    start <= '1';
    wait for 10*clk_period;
    res_n <= '1';
    wait until done = '1';
    unsorted_data <= x"0F00F0F1_0FFF0010_FF00F100_0F0F1F0F";
    wait until done = '1';

    clk_stop <= '1';
    report "end sim";
    wait;
  end process;

  UUT : sorting_network
  generic map( DATA_WIDTH => DATA_WIDTH )
  port map(
    clk      => clk,
    res_n    => res_n,
    unsorted_data => unsorted_data,
    start => start,
    sorted_data  => sorted_data,
    done  => done
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
