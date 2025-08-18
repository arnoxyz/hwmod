library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.math_pkg.all;

entity running_light is
	generic (
		STEP_TIME  : time := 1 sec;
    CLK_PERIOD: time := 20 ns
	);
	port (
		clk      : in std_ulogic;
		res_n    : in std_ulogic;
		leds     : out std_ulogic_vector(7 downto 0)
	);
end entity;

architecture beh_no_fsm of running_light is
  constant cc_for_step_time : integer := (STEP_TIME / CLK_PERIOD);
  signal counter : unsigned(31 downto 0);
  signal counter_nxt : unsigned(31 downto 0);
  signal leds_internal : unsigned(7 downto 0);
  signal leds_internal_nxt : unsigned(7 downto 0);

begin
  leds <= std_ulogic_vector(leds_internal);

  sync : process(clk, res_n) is
  begin
    if res_n = '0' then
      counter <= (others=>'0');
      leds_internal <= (7=>'1', others=>'0');
    elsif rising_edge(clk) then
      counter <= counter_nxt;
      leds_internal <= leds_internal_nxt;
    end if;
  end process;

  comb : process(all) is
  begin
    counter_nxt <= counter + 1;
    leds_internal_nxt <= leds_internal;

    if counter >= cc_for_step_time then
      counter_nxt <= (others=>'0');
      if leds_internal = 1 then
        leds_internal_nxt <= (7=>'1', others=>'0');
      else
        leds_internal_nxt <= shift_right(leds_internal, 1);
      end if;
    end if;
  end process;
end architecture;



architecture fsm of running_light is
  constant cc_for_step_time : integer := (STEP_TIME / CLK_PERIOD);

  type fsm_state_t is (OUTPUT_PATTERN);

  type state_reg_t is record
    --state : fsm_state_t; always in state OUTPUT_PATTERN so omit it for now
    counter : unsigned(31 downto 0);
    leds_internal : unsigned(7 downto 0);
  end record;

  signal s, s_nxt : state_reg_t;
  constant RESET_VAL : state_reg_t := (counter => (others=>'0'), leds_internal => (7=>'1', others=>'0'));

begin
  leds <= std_ulogic_vector(s.leds_internal);

  sync : process(clk, res_n) is
  begin
    if res_n = '0' then
      s <= RESET_VAL;
    elsif rising_edge(clk) then
      s <= s_nxt;
    end if;
  end process;

  comb : process(all) is
  begin
    s_nxt <= s;
    s_nxt.counter <= s.counter + 1;

    if s.counter >= cc_for_step_time then
      s_nxt.counter <= (others=>'0');
      if s.leds_internal = 1 then
        s_nxt.leds_internal <= (7=>'1', others=>'0');
      else
        s_nxt.leds_internal <= shift_right(s.leds_internal, 1);
      end if;
    end if;
  end process;
end architecture;
