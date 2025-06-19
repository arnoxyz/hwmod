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
    variable int_local2 : integer := 0;
  begin
    -- convert bin_in into integer for dec_out
    for i in bin_in'range loop
      if bin_in(i) = '1' then
        int_local := int_local + 2**(i);
      end if;
    end loop;
    dec_out <= int_local;

    int_local2 := int_local;
    -- decode the dec_out to bcd format
    -- report to_string(log10c(int_local));
    for i in log10c(int_local) downto 0  loop
        if i/=0 then 
          -- split int_local in all: 219 -> /100 gets 2, /10 = 1 ...
          report to_string(i);
          report to_string(10**(i-1));
          report to_string(int_local/(10**(i-1)));
          -- add procedure: decoder of bcd format 
        else 
          report to_string(int_local mod 10);

        end if;
    end loop;
    bcd_out <= (others=>'0');
  end process;
end architecture;
