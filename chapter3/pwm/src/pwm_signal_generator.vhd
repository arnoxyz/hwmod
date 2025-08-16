library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity pwm_signal_generator is
	generic (
		COUNTER_WIDTH : integer := 8
	);
	port (
		clk        : in std_ulogic;
		res_n      : in std_ulogic;
		en         : in std_ulogic;
		value      : in std_ulogic_vector(COUNTER_WIDTH-1 downto 0);
		pwm_out    : out std_ulogic
	);
end entity;


architecture arch of pwm_signal_generator is
  signal internal_pwm : std_ulogic;
  signal counter : unsigned(COUNTER_WIDTH-1 downto 0);
  signal counter_nxt  : unsigned(COUNTER_WIDTH-1 downto 0);
  signal counter_en : std_ulogic;

begin
  pwm_out <= internal_pwm;

  sync : process(clk, res_n) is
  begin
    if res_n = '0' then
      internal_pwm <= '0';
      counter <= (others=>'0');
      counter_en <= '0';
    elsif rising_edge(clk) then
      internal_pwm <= '1';
      counter <= counter_nxt;
      if counter = 0 then
        if en = '1' then
          counter_en <= '1';
        else
          counter_en <= '0';
        end if;
      end if;
    end if;
  end process;

  comb : process(all) is
  begin
    if counter_en = '1' then
      counter_nxt <= counter + 1;
    else
      counter_nxt <= (others=>'0');
    end if;
  end process;
end architecture;
