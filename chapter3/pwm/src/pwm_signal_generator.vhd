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
  signal counter : unsigned(COUNTER_WIDTH-1 downto 0);
  signal counter_nxt  : unsigned(COUNTER_WIDTH-1 downto 0);
  signal counter_en : std_ulogic;
  signal sample_val: std_ulogic_vector(COUNTER_WIDTH-1 downto 0);
  signal sample_val_nxt: std_ulogic_vector(COUNTER_WIDTH-1 downto 0);

begin
  sync : process(clk, res_n) is
  begin
    if res_n = '0' then
      counter <= (others=>'0');
      counter_en <= '0';
      sample_val <= (others=>'0');
    elsif rising_edge(clk) then
      counter <= counter_nxt;
      sample_val <= sample_val_nxt;

      if counter_nxt = 0 then
        if en = '1' then
          counter_en <= '1';
          sample_val <= value;
        else
          counter_en <= '0';
        end if;
      end if;
    end if;
  end process;

  comb : process(all) is
  begin
		pwm_out <= '0';
    counter_nxt <= (others=>'0');
    sample_val_nxt <= sample_val;

    if counter_en = '1' then
      counter_nxt <= counter + 1;
      if counter >= unsigned(sample_val) then
		    pwm_out <= '1';
      end if;
    end if;
  end process;
end architecture;
