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

      --IDLE-MODE:
      input_data_internal_nxt <= unsigned(input_data);
      signed_mode_internal_nxt <= signed_mode;

      --START-CONVERSION-PROCESS:
      if ((signed_mode_internal = '1' and signed_mode = '0') or
         (signed_mode_internal = '0' and signed_mode = '1')  or
         (to_integer(input_data_internal) /= to_integer(unsigned(input_data)))) then

        report "start process";
        report to_string(signed_mode_internal) & " " & to_string(signed_mode);
        report to_string(input_data_internal) & " " & to_string(input_data);
      end if;
	end process;


  --just output this for now
  hex_digit1     <= (others=>'0');
  hex_digit10    <= (others=>'0');
  hex_digit100   <= (others=>'0');
  hex_digit1000  <= (others=>'0');
  hex_sign       <= (others=>'0');
end architecture;
