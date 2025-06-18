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
  begin
    for i in bin_in'range loop
      if bin_in(i) = '1' then
        int_local := int_local + 2**(i);
      end if;
    end loop;
    dec_out <= int_local;

    -- dummy values for now
    bcd_out <= (others=>'0');
  end process;
end architecture;
