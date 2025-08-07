library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.math_pkg.all;

entity stopwatch is
	generic (
		CLK_PERIOD : time;
		DIGITS : integer
	);
	port (
		clk     : in std_ulogic;
		res_n   : in std_ulogic;
		start_n : in std_ulogic;
		stop_n  : in std_ulogic;
		seconds : out unsigned(log2c(10**DIGITS)-1 downto 0)
	);
end entity;

architecture arch of stopwatch is
  constant CLK_FREQUENCY : integer := integer(1 sec / CLK_PERIOD);
  signal cnt : unsigned(31 downto 0);
  signal cnt_nxt : unsigned(31 downto 0);
	signal cnt_sec  : unsigned(log2c(10**DIGITS)-1 downto 0);
	signal cnt_sec_nxt  : unsigned(log2c(10**DIGITS)-1 downto 0);
  signal last_start_n : std_ulogic;
  signal last_stop_n : std_ulogic;
  signal btn_pressed : std_ulogic;
  signal last_btn_pressed : std_ulogic;

begin
  sync : process(clk, res_n) is
  begin
    if res_n = '0' then
      seconds <= (others=>'0');
      cnt <= (others=>'0');
      cnt_sec <= (others=>'0');
      last_start_n <= '1';
      last_stop_n <= '1';
      last_btn_pressed <= '0';
      btn_pressed <= '0';

    elsif rising_edge(clk) then
      cnt <= cnt_nxt;
      cnt_sec <= cnt_sec_nxt;
      last_start_n <= start_n;
      last_stop_n <= stop_n;
      last_btn_pressed <= btn_pressed;

      --detect low active button press
      if (last_start_n = '1' and start_n = '0') then
        btn_pressed <= '1';
      end if;
      if (last_stop_n = '1' and stop_n = '0') then
        --reset the counter if stop pressed again in stop mode
        if last_btn_pressed = '0' then
          cnt <= (others=>'0');
        end if;
        btn_pressed <= '0';
      end if;
    end if;
  end process;

  comb : process(all) is
  begin
      if btn_pressed = '1' then
        cnt_nxt <= cnt + 1;
      end if;
      if btn_pressed = '0' then
        cnt_nxt <= cnt;
      end if;

      if cnt >= CLK_FREQUENCY then
        cnt_sec_nxt <= cnt_sec + 1;
        cnt_nxt <= (others=>'0');
      else
        cnt_sec_nxt <= cnt_sec;
      end if;
  end process;
end architecture;
