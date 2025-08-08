library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.math_pkg.all;
use work.bin2dec_pkg.all;

entity bin2dec is
	generic(
		SSD_DIGITS : integer
	);
	port(
		clk     : in std_ulogic;
		res_n   : in std_ulogic;
		binary  : in unsigned(log2c(10**SSD_DIGITS)-1 downto 0);
		decimal : out dec_digits_t(SSD_DIGITS-1 downto 0)
	);
end entity;

architecture arch of bin2dec is
  signal bin_in_sampled : unsigned(log2c(10**SSD_DIGITS)-1 downto 0);
  signal bin_in_sampled_nxt : unsigned(log2c(10**SSD_DIGITS)-1 downto 0);
begin
  sync : process(clk, res_n) is
  begin
    if res_n = '0' then
      bin_in_sampled <= (others=>'0');
    elsif rising_edge(clk) then
      --sample input
      bin_in_sampled <= binary;
    end if;
  end process;

  comb : process(all) is
  begin
    bin_in_sampled_nxt <= bin_in_sampled;

    --conversion
    if to_integer(bin_in_sampled) <= 9 then
      bin_in_sampled_nxt <= to_unsigned(to_integer(bin_in_sampled mod 10),bin_in_sampled'length);
      decimal(0) <= to_unsigned(to_integer(bin_in_sampled mod 10),4);
    else
      bin_in_sampled_nxt <= to_unsigned(to_integer(bin_in_sampled/10 mod 10),bin_in_sampled'length);
      decimal(1) <= to_unsigned(to_integer(bin_in_sampled/10 mod 10),4);
    end if;

  end process;
end architecture;
