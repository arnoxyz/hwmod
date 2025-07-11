library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

use work.sram_pkg.all;

entity sram_tb is
end entity;

architecture tb of sram_tb is
	signal A : addr_t;
	signal IO : word_t;
	signal CE_N, OE_N, WE_N, LB_N, UB_N : std_ulogic := '1';

  function max(x, y : time) return time is
  begin
    if x < y then
      return y;
    end if;
    return x;
  end function;

begin

	stimulus : process is

		procedure read(addr : integer; variable data : out word_t) is
		begin
      report "read Data from Addr=" & to_string(addr);
      -- set address
      A <= std_ulogic_vector(to_unsigned(addr, A'length));
      wait for TAA;
      wait for (TRC-TAA)/2;
      data := IO;
      wait for (TRC-TAA)/2;
		end procedure;

		procedure write(addr : integer; data : word_t) is
		begin
      -- Implementing Write Cycle 1
      --report "write: Data=" & to_hstring(data) & " to Addr=" & to_string(addr);
      A <= std_ulogic_vector(to_unsigned(addr, A'length));
      wait for TSA; -- TSA (setup address)
      CE_N <= '0';
      WE_N <= '0';
      wait for THZWE;
      IO <= data;
      wait for max(TSCE, TPWE2) - THZWE;
      CE_N <= '1';
      WE_N <= '1';
      wait for THD;
      IO <= (others => 'Z');
      wait for max(TLZWE, THZCE);
		end procedure;

    -- read
		variable read_data : word_t;
		variable read_data0 : word_t := x"0000";
		variable read_data1 : word_t := x"0000";
		variable read_data2 : word_t := x"0000";
		variable read_data3 : word_t := x"0000";
    -- write
		constant testdata : std_ulogic_vector := x"BADC0DEDC0DEBA5E";

		constant write_data0 : std_ulogic_vector := x"BADC";
		constant write_data1 : std_ulogic_vector := x"0DED";
		constant write_data2 : std_ulogic_vector := x"C0DE";
		constant write_data3 : std_ulogic_vector := x"BA5E";

	begin
		-- Initialization
		A <= (others => '0');
		CE_N <= '1';
		WE_N <= '1';
		OE_N <= '1';
		IO <= (others => 'Z');
		-- This enables reading and writing of both bytes -> you can always keep this low
    -- meaning that we always write/read the whole 16 bit data word
		LB_N <= '0';
		UB_N <= '0';
		wait for 20 ns;

		-- write
    CE_N <= '1';
    OE_N <= '0';
		LB_N <= '0';
		UB_N <= '0';
    wait for 4 ns;
		write(0, write_data0);
		write(1, write_data1);
		write(2, write_data2);
		write(3, write_data3);

    wait for 10 ns;

    -- read
    CE_N <= '0';
    OE_N <= '0';
    wait for max(THZOE, THZCE);
		--read(1, read_data1);
		--read(0, read_data0);
		--read(2, read_data2);
		--read(3, read_data3);

    -- Check if
    --assert write_data0 = read_data0 report "write data /= read data " & to_string(write_data0) & " " & to_string(read_data0);
    --assert write_data1 = read_data1 report "write data /= read data " & to_string(write_data1) & " " & to_string(read_data1);
    --assert write_data2 = read_data2 report "write data /= read data " & to_string(write_data2) & " " & to_string(read_data2);
    --assert write_data3 = read_data3 report "write data /= read data " & to_string(write_data3) & " " & to_string(read_data3);
		wait;
	end process;

	dut : entity work.sram
	port map(
		A => A,
		IO => IO,
		CE_N => CE_N,
		OE_N => OE_N,
		WE_N => WE_N,
		LB_N => LB_N,
		UB_N => UB_N
	);
end architecture;
