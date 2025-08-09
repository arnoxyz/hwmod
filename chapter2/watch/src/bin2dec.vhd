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
  constant DIGITS : integer := SSD_DIGITS;
  signal bin_in_sampled : unsigned(log2c(10**SSD_DIGITS)-1 downto 0);
  signal bin_in_sampled_nxt : unsigned(log2c(10**SSD_DIGITS)-1 downto 0);
  signal cnt : unsigned(31 downto 0);
  signal cnt_nxt : unsigned(31 downto 0);
  signal start_cnt : std_ulogic := '0';

begin
  sync : process(clk, res_n) is
  begin
    if res_n = '0' then
      bin_in_sampled <= (others=>'0');
      cnt <= (others=>'0');
    elsif rising_edge(clk) then
      cnt <= cnt_nxt;

      if cnt = 0 then
        bin_in_sampled <= binary;
        start_cnt <= '1';
      elsif cnt < SSD_DIGITS then
        bin_in_sampled <= bin_in_sampled_nxt;
      else
        start_cnt <= '0';
      end if;
    end if;
  end process;

  comb : process(all) is
  begin
    bin_in_sampled_nxt <= bin_in_sampled;
    cnt_nxt <= cnt;

    if start_cnt = '0' then
      cnt_nxt <= (others=>'0');
      decimal <= (others=> (others=>'0'));
    end if;

    --conversion
    if start_cnt = '1' then
      cnt_nxt <= cnt + 1;
      if cnt >= 1 then
        bin_in_sampled_nxt <= to_unsigned(to_integer(bin_in_sampled / 10),bin_in_sampled'length);
        decimal(to_integer(cnt-1)) <= to_unsigned(to_integer(bin_in_sampled mod 10),4);
      end if;
    end if;

  end process;
end architecture;
