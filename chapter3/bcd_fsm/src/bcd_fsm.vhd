library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

use work.util_pkg.all;

entity bcd_fsm is
	port(
		clk         : in std_ulogic;
		res_n       : in std_ulogic;

		input_data  : in std_ulogic_vector(15 downto 0);
		signed_mode : in std_ulogic;

		hex_digit1     : out std_ulogic_vector(6 downto 0);
		hex_digit10    : out std_ulogic_vector(6 downto 0);
		hex_digit100   : out std_ulogic_vector(6 downto 0);
		hex_digit1000  : out std_ulogic_vector(6 downto 0);
		hex_sign       : out std_ulogic_vector(6 downto 0)
	);
end entity;

architecture beh of bcd_fsm is
	-- TODO: Declare an fsm state enum type
	-- TODO: Declare a state register record type

  signal input_data_internal : unsigned(15 downto 0);
  signal input_data_internal_nxt : unsigned(15 downto 0);
  signal signed_mode_internal : std_ulogic;
  signal signed_mode_internal_nxt : std_ulogic;
begin

	sync : process(clk, res_n)
	begin
    if res_n = '0' then
      input_data_internal <= (others => '0');
      signed_mode_internal <= '0';
    elsif rising_edge(clk) then
      input_data_internal <= input_data_internal_nxt;
      signed_mode_internal <= signed_mode_internal_nxt;
    end if;
	end process;


	comb : process(all)
	begin
      input_data_internal_nxt <= input_data_internal;
      signed_mode_internal_nxt <= signed_mode_internal;
	end process;
end architecture;
