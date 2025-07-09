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
begin

	stimulus : process is
		procedure read(addr : integer; variable data : out word_t) is
		begin
			-- Implement your read procedure that reads from address "addr" and writes the read data into "data"
		end procedure;

		procedure write(addr : integer; data : word_t) is
		begin
      -- Implementing Write Cycle 1
      report "write: Data=" & to_hstring(data) & " to Addr=" & to_string(addr);

      OE_N <= '1'; -- high or low (just set it to high (deacivated) for the whole write cycle)
      -- set address
      CE_N <= '1';
      WE_N <= '1';
      A <= std_ulogic_vector(to_unsigned(addr, A'length));
      wait for TSA; -- TSA (setup address)

      CE_N <= '0';
      WE_N <= '0';
      wait for THZWE;

      IO <= data;
		end procedure;

    -- read
		variable read_data : word_t;
    -- write
		constant testdata : std_ulogic_vector := x"BADC0DEDC0DEBA5E";

		constant testdata0 : std_ulogic_vector := x"BADC";
		constant testdata1 : std_ulogic_vector := x"0DED";
		constant testdata2 : std_ulogic_vector := x"C0DE";
		constant testdata3 : std_ulogic_vector := x"BA5E";

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
		write(0, testdata0);
		--write(1, testdata1);
		--write(2, testdata2);
		--write(3, testdata3);

    -- read
		--read(0, read_data);
		--read(1, read_data);
		--read(2, read_data);
		--read(3, read_data);
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
