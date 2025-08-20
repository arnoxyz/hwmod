library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

use work.util_pkg.all;

entity bcd_fsm is
	port(
		clk         : in std_ulogic;
		res_n       : in std_ulogic;

		input_data  : in std_ulogic_vector(15 downto 0);
		signed_mode : in std_ulogic;

		hex_digit1     : out std_ulogic_vector(6 downto 0);
		hex_digit10    : out std_ulogic_vector(6 downto 0);
		hex_digit100   : out std_ulogic_vector(6 downto 0);
		hex_digit1000  : out std_ulogic_vector(6 downto 0);
		hex_sign       : out std_ulogic_vector(6 downto 0)
	);
end entity;

architecture beh of bcd_fsm is
	constant DATA_WIDTH : integer := 16;
	-- TODO: Declare a state register record type
  type fsm_state is (IDLE, GET_DIGIT_1000, GET_DIGIT_100, GET_DIGIT_10, GET_DIGIT_1);
  signal state : fsm_state;
  signal state_nxt : fsm_state;
  signal cnt : unsigned(6 downto 0);
  signal cnt_nxt : unsigned(6 downto 0);

  signal input_data_internal : unsigned(DATA_WIDTH-1 downto 0);
  signal input_data_internal_nxt : unsigned(DATA_WIDTH-1 downto 0);
  signal signed_mode_internal : std_ulogic;
  signal signed_mode_internal_nxt : std_ulogic;

  signal hex_digit1000_internal : unsigned(6 downto 0);
  signal hex_digit1000_internal_nxt : unsigned(6 downto 0);
  signal hex_digit100_internal  : unsigned(6 downto 0);
  signal hex_digit100_internal_nxt  : unsigned(6 downto 0);
  signal hex_digit10_internal   : unsigned(6 downto 0);
  signal hex_digit10_internal_nxt   : unsigned(6 downto 0);
  signal hex_digit1_internal   : unsigned(6 downto 0);
  signal hex_digit1_internal_nxt   : unsigned(6 downto 0);
begin

	sync : process(clk, res_n)
	begin
    if res_n = '0' then
      state <= IDLE;
      input_data_internal <= (others => '0');
      signed_mode_internal <= '0';
      cnt <= (others => '0');
      hex_digit1000_internal <= (others => '0');
      hex_digit100_internal <= (others => '0');
      hex_digit10_internal <= (others => '0');
      hex_digit1_internal <= (others => '0');
    elsif rising_edge(clk) then
      state <= state_nxt;
      input_data_internal <= input_data_internal_nxt;
      signed_mode_internal <= signed_mode_internal_nxt;
      cnt <= cnt_nxt;
      hex_digit1000_internal <= hex_digit1000_internal_nxt;
      hex_digit100_internal <= hex_digit100_internal_nxt;
      hex_digit10_internal <= hex_digit10_internal_nxt;
      hex_digit1_internal <= hex_digit1_internal_nxt;
    end if;
	end process;


	comb : process(all)
	begin
      input_data_internal_nxt <= input_data_internal;
      signed_mode_internal_nxt <= signed_mode_internal;
      state_nxt <= state;
      cnt_nxt <= cnt;
      hex_digit1000_internal_nxt  <= hex_digit1000_internal;
      hex_digit100_internal_nxt  <= hex_digit100_internal;
      hex_digit10_internal_nxt  <= hex_digit10_internal;
      hex_digit1_internal_nxt  <= hex_digit1_internal;

      hex_digit1000  <= std_ulogic_vector(hex_digit1000_internal);
      hex_digit100   <= std_ulogic_vector(hex_digit100_internal);
      hex_digit10    <= std_ulogic_vector(hex_digit10_internal);
      hex_digit1     <= std_ulogic_vector(hex_digit1_internal);

      hex_sign       <= (others=>'0');

      --CONVERSION-PROCESS:
      --(INPUT_NUMBER - 1000),  1k_cnt++,   until INPUT_NUMBER < 1000
      --(INPUT_NUMBER - 100),   100_cnt++,  until INPUT_NUMBER < 100
      --(INPUT_NUMBER - 10),    10_cnt++,   until INPUT_NUMBER < 10
      --(INPUT_NUMBER - 1),     1_cnt++,    until INPUT_NUMBER <= 0

      case state is
        when IDLE =>
          input_data_internal_nxt <= unsigned(input_data);
          signed_mode_internal_nxt <= signed_mode;
          if ((signed_mode_internal = '1' and signed_mode = '0') or
             (signed_mode_internal = '0' and signed_mode = '1')  or
             (to_integer(input_data_internal) /= to_integer(unsigned(input_data)))) then
            state_nxt <= GET_DIGIT_1000;
          end if;
        when GET_DIGIT_1000 =>
          --Now implementing the signed_mode='0' case so the input_data is interpreted as unsigned
          if to_integer(input_data_internal) > 1000 then
            input_data_internal_nxt <= to_unsigned(to_integer(input_data_internal)-1000, DATA_WIDTH);
            cnt_nxt <= cnt+1; --cnt++
            --stay in same state, omit => because of default assignment at the start
          else
            hex_digit1000_internal_nxt  <= cnt; --cnt yields the hex_digit1000
            cnt_nxt <= (others=>'0'); --reset cnt
            state_nxt <= GET_DIGIT_100; --go to the next state -> GET_DIGIT_100
          end if;
        when GET_DIGIT_100 =>
          if to_integer(input_data_internal) > 100 then
            input_data_internal_nxt <= to_unsigned(to_integer(input_data_internal)-100, DATA_WIDTH);
            cnt_nxt <= cnt+1; --cnt++
            --stay in same state, omit => because of default assignment at the start
          else
            hex_digit100_internal_nxt  <= cnt; --cnt yields the hex_digit1000
            cnt_nxt <= (others=>'0'); --reset cnt
            state_nxt <= GET_DIGIT_10; --go to the next state -> GET_DIGIT_100
          end if;
        when GET_DIGIT_10 =>
          if to_integer(input_data_internal) > 10 then
            input_data_internal_nxt <= to_unsigned(to_integer(input_data_internal)-10, DATA_WIDTH);
            cnt_nxt <= cnt+1; --cnt++
            --stay in same state, omit => because of default assignment at the start
          else
            hex_digit10_internal_nxt  <= cnt; --cnt yields the hex_digit1000
            cnt_nxt <= (others=>'0'); --reset cnt
            state_nxt <= GET_DIGIT_1; --go to the next state -> GET_DIGIT_100
          end if;
        when GET_DIGIT_1 =>
          if to_integer(input_data_internal) > 0 then
            input_data_internal_nxt <= to_unsigned(to_integer(input_data_internal)-1, DATA_WIDTH);
            cnt_nxt <= cnt+1; --cnt++
            --stay in same state, omit => because of default assignment at the start
          else
            hex_digit1_internal_nxt  <= cnt;
            cnt_nxt <= (others=>'0'); --reset cnt
            state_nxt <= IDLE; --go to the next state
          end if;
        end case;
	end process;
end architecture;
