library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.math_real.all;

use work.math_pkg.all;
use work.bin2dec_pkg.all;

entity bin2dec_tb is
end entity;

architecture tb of bin2dec_tb is
  signal bin_in : std_ulogic_vector(3 downto 0) := (others=>'0');
  signal dec_out : integer;
  signal bcd_out : std_ulogic_vector(0 downto 0);
begin

	stimuli : process
	begin
		-- apply your stimulus here
    bin_in <= "0001";
    wait for 1 ns;
    bin_in <= "1101";
    wait for 1 ns;
		report to_string(bin_in) & " is decimal: " & to_string(dec_out) & " is BCD: " & to_string(bcd_out);
		wait;
	end process;

  UUT : bin2dec
    port map (
      bin_in => bin_in, 
      dec_out => dec_out, 
      bcd_out => bcd_out
    );
end architecture;

