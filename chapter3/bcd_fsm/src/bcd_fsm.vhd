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
  type fsm_state_t is (IDLE, GET_DIGIT_1000, GET_DIGIT_100, GET_DIGIT_10, GET_DIGIT_1);

  type state_reg_t is record
    state : fsm_state_t;
    signed_mode_internal : std_ulogic;
    cnt : unsigned(3 downto 0);
    input_data_internal : unsigned(DATA_WIDTH-1 downto 0);
    input_data_sampled : unsigned(DATA_WIDTH-1 downto 0);
    hex_digit1000_internal : unsigned(6 downto 0);
    hex_digit100_internal  : unsigned(6 downto 0);
    hex_digit10_internal   : unsigned(6 downto 0);
    hex_digit1_internal   : unsigned(6 downto 0);
  end record;

  constant RESET_VAL : state_reg_t := (state=>IDLE, signed_mode_internal=> '0', others=> (others=>'0'));
  signal s, s_nxt : state_reg_t;

begin

	sync : process(clk, res_n)
	begin
    if res_n = '0' then
      s <= RESET_VAL;
    elsif rising_edge(clk) then
      s <= s_nxt;
    end if;
	end process;


	comb : process(all)
	begin
      s_nxt <= s;
      s_nxt.input_data_sampled <= unsigned(input_data);

      hex_digit1000  <= std_ulogic_vector(s.hex_digit1000_internal);
      hex_digit100   <= std_ulogic_vector(s.hex_digit100_internal);
      hex_digit10    <= std_ulogic_vector(s.hex_digit10_internal);
      hex_digit1     <= std_ulogic_vector(s.hex_digit1_internal);
      hex_sign       <= (others=>'0');

      --CONVERSION-PROCESS:
      --(INPUT_NUMBER - 1000),  1k_cnt++,   until INPUT_NUMBER < 1000
      --(INPUT_NUMBER - 100),   100_cnt++,  until INPUT_NUMBER < 100
      --(INPUT_NUMBER - 10),    10_cnt++,   until INPUT_NUMBER < 10
      --(INPUT_NUMBER - 1),     1_cnt++,    until INPUT_NUMBER <= 0

      case s.state is
        when IDLE =>
          s_nxt.input_data_internal <= unsigned(input_data);
          s_nxt.signed_mode_internal <= signed_mode;

          if ((s.signed_mode_internal = '1' and signed_mode = '0') or
             (s.signed_mode_internal = '0' and signed_mode = '1')  or
             (to_integer(s.input_data_sampled) /= to_integer(unsigned(input_data)))) then

               if (to_integer(unsigned(input_data)) > 9999) then
                s_nxt.hex_digit1000_internal <= unsigned(SSD_CHAR_OFF);
                s_nxt.hex_digit100_internal  <= unsigned(SSD_CHAR_O);
                s_nxt.hex_digit10_internal   <= unsigned(SSD_CHAR_F);
                s_nxt.hex_digit1_internal    <= unsigned(SSD_CHAR_L);
               else
                s_nxt.hex_digit1000_internal <= unsigned(SSD_CHAR_OFF);
                s_nxt.hex_digit100_internal  <= unsigned(SSD_CHAR_OFF);
                s_nxt.hex_digit10_internal   <= unsigned(SSD_CHAR_OFF);
                s_nxt.hex_digit1_internal    <= unsigned(SSD_CHAR_OFF);
                s_nxt.state <= GET_DIGIT_1000;
               end if;
          end if;
        when GET_DIGIT_1000 =>
          if to_integer(s.input_data_internal) >= 1000 then
            s_nxt.input_data_internal <= to_unsigned(to_integer(s.input_data_internal)-1000, DATA_WIDTH);
            s_nxt.cnt <= s.cnt+1;
          else
            s_nxt.hex_digit1000_internal  <= unsigned(to_segs(std_ulogic_vector(s.cnt)));
            s_nxt.cnt <= (others=>'0');
            s_nxt.state <= GET_DIGIT_100;

            if to_integer(s.cnt) = 0 then
              s_nxt.hex_digit1000_internal <= unsigned(to_segs(x"0"));
            end if;
          end if;
        when GET_DIGIT_100 =>
          if to_integer(s.input_data_internal) >= 100 then
            s_nxt.input_data_internal <= to_unsigned(to_integer(s.input_data_internal)-100, DATA_WIDTH);
            s_nxt.cnt <= s.cnt+1;
          else
            s_nxt.hex_digit100_internal  <= unsigned(to_segs(std_ulogic_vector(s.cnt)));
            s_nxt.cnt <= (others=>'0');
            s_nxt.state <= GET_DIGIT_10;
            if to_integer(s.cnt) = 0 then
              s_nxt.hex_digit100_internal <= unsigned(to_segs(x"0"));
            end if;
          end if;
        when GET_DIGIT_10 =>
          if to_integer(s.input_data_internal) >= 10 then
            s_nxt.input_data_internal <= to_unsigned(to_integer(s.input_data_internal)-10, DATA_WIDTH);
            s_nxt.cnt <= s.cnt+1;
          else
            s_nxt.hex_digit10_internal <= unsigned(to_segs(std_ulogic_vector(s.cnt)));
            s_nxt.cnt <= (others=>'0');
            s_nxt.state <= GET_DIGIT_1;
            if to_integer(s.cnt) = 0 then
              s_nxt.hex_digit10_internal <= unsigned(to_segs(x"0"));
            end if;
          end if;
        when GET_DIGIT_1 =>
          if to_integer(s.input_data_internal) > 0 then
            s_nxt.input_data_internal <= to_unsigned(to_integer(s.input_data_internal)-1, DATA_WIDTH);
            s_nxt.cnt <= s.cnt+1;
          else
            s_nxt.hex_digit1_internal  <= unsigned(to_segs(std_ulogic_vector(s.cnt)));
            s_nxt.cnt <= (others=>'0');
            s_nxt.state <= IDLE;
            if to_integer(s.cnt) = 0 then
              s_nxt.hex_digit1_internal <= unsigned(to_segs(x"0"));
            end if;
          end if;
        end case;
	end process;
end architecture;
