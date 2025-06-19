library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

use work.math_pkg.all;
use work.bin2dec_pkg.all;

entity bin2dec is
	port (
		bin_in   : in  std_ulogic_vector;
		dec_out  : out integer;
		bcd_out  : out std_ulogic_vector
	);
end entity;

-- put your architecture here
architecture beh of bin2dec is
begin
  main : process(bin_in) is
    variable int_local : integer := 0;
    variable current_digit: integer := 0;

    function digit2bcd(digit : integer) return std_ulogic_vector is 
      variable bcd : std_ulogic_vector(3 downto 0);
    begin
      case digit is
          when 0 => bcd := "0000";
          when 1 => bcd := "0001";
          when 2 => bcd := "0010";
          when 3 => bcd := "0011";
          when 4 => bcd := "0100";
          when 5 => bcd := "0101";
          when 6 => bcd := "0110";
          when 7 => bcd := "0111";
          when 8 => bcd := "1000";
          when 9 => bcd := "1001";
          when others => bcd := "XXXX";  -- invalid digit
      end case;

      return bcd;
    end function;

  begin
    -- convert bin_in into integer for dec_out
    for i in bin_in'range loop
      if bin_in(i) = '1' then
        int_local := int_local + 2**(i);
      end if;
    end loop;
    dec_out <= int_local;

    -- decode the dec_out to bcd format
    -- report to_string(log10c(int_local));
    for i in log10c(int_local) downto 0  loop
        -- get current_digit
        if i/=0 then 
          current_digit := int_local/(10**(i-1)) mod 10;
        else 
          current_digit := int_local mod 10;
        end if;

        -- decode and output current_digit in bcd format
        if i/=0 then 
          -- upper bound, lower bound
          report "upper bound: from" & to_string((i*4)-1) & " lower bound to:" & to_string((i-1)*4);
          --digit2bcd(digit : integer) return std_ulogic_vector is 
          --bcd_out((i*4)-1 downto (i-1)*4) <= digit2bcd(current_digit);
        end if;

    end loop;
    bcd_out <= (others=>'0');
  end process;
end architecture;
