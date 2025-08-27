library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

use work.math_pkg.all;
use work.sram_ctrl_pkg.all;

entity sram_ctrl is
	port (
		clk   : in  std_ulogic;
		res_n : in std_ulogic;

		rd       : in std_ulogic;
		wr       : in std_ulogic;
		busy     : out std_ulogic;
		rd_valid : out std_ulogic;

		addr        : in byte_addr_t;
		access_mode : in sram_access_mode_t;
		wr_data     : in uword_t;
		rd_data     : out uword_t;

		-- external interface to SRAM
		sram_dq   : inout word_t;
		sram_addr : out word_addr_t;
		sram_ub_n : out std_logic;
		sram_lb_n : out std_logic;
		sram_we_n : out std_logic;
		sram_ce_n : out std_logic;
		sram_oe_n : out std_logic
	);
end entity;


architecture arch of sram_ctrl is
  type fsm_state_t is (IDLE, WRITE, READ_START, READ_OUT);

  type reg_t is record
    state : fsm_state_t;
		access_mode : sram_access_mode_t;
		addr        : byte_addr_t;
		wr_data     : uword_t;
  end record;

  constant RESET_VAL : reg_t := (state=>IDLE, access_mode=>BYTE, others=>(others=>'0'));
  signal s, s_nxt : reg_t;

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
    function to_word_addr(b : byte_addr_t) return word_addr_t is
    begin
      return std_logic_vector(b(20 downto 1));
    end function;
	begin
      s_nxt <= s;
      rd_valid <= '0';
      sram_dq <= (others=>'Z');

      -- external interface to SRAM
      sram_ce_n <= '0'; --always activate chip
      --for now only access_mode = WORD is valid
      sram_ub_n <= '0'; --always activate lower and upper bits
      sram_lb_n <= '0';

      case s.state is
        when IDLE  =>
          if rd = '1' then
            s_nxt.state <= READ_START;
            s_nxt.addr        <= addr;
            s_nxt.access_mode <= access_mode;
        end if;

          if wr = '1' then
            s_nxt.state <= WRITE;
            s_nxt.addr        <= addr;
            s_nxt.access_mode <= access_mode;
            s_nxt.wr_data     <= wr_data;
          end if;

        when READ_START =>
          report "READ_START";
          s_nxt.state <= READ_OUT;
          --Activate Read cycle no. 1
          sram_addr <= to_word_addr(s.addr);
          sram_dq <= (others=>'Z');
          sram_oe_n <= '0';
          sram_we_n <= '1';

        when READ_OUT =>
          report "READ_OUT";
          s_nxt.state <= IDLE;
		      rd_data <= sram_dq;
          rd_valid <= '1';

        when WRITE =>
          report "WRITE";
      end case;
	end process;
end architecture;
