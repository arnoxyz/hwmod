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
  type fsm_state_t is (IDLE, WRITE_START, READ_START, READ_OUT);

  type reg_t is record
    state : fsm_state_t;
    cnt : unsigned(3 downto 0);
		access_mode : sram_access_mode_t;
		addr        : byte_addr_t;
		wr_data     : uword_t;
  end record;

  constant RESET_VAL : reg_t := (state=>IDLE, cnt => (others=>'0'), access_mode=>BYTE, others=>(others=>'0'));
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
	begin
      s_nxt <= s;
      rd_valid <= '0';
      busy <= '0';

      sram_ce_n <= '0'; --always activate chip
      sram_dq <= (others=>'Z');
      sram_ub_n <= '0';
      sram_lb_n <= '0';


      case s.state is
        when IDLE  =>
          sram_ce_n <= '1';
          sram_oe_n <= '1';
          sram_we_n <= '1';

          s_nxt.addr        <= addr;
          s_nxt.access_mode <= access_mode;
          s_nxt.wr_data     <= wr_data;

          if rd = '1' then
            s_nxt.state <= READ_START;
            sram_oe_n <= '0';
            sram_we_n <= '1';
          end if;

          if wr = '1' then
            s_nxt.state <= WRITE_START;
            sram_ce_n <= '0';
            sram_oe_n <= '1';
            sram_we_n <= '0';
          end if;

        when READ_START =>
          --Activate Read cycle no. 1
          s_nxt.state <= READ_OUT;
          busy <= '1';

          sram_oe_n <= '0';
          sram_we_n <= '1';
          sram_addr <= std_ulogic_vector(s.addr(19 downto 0));

        when READ_OUT =>
          s_nxt.state <= IDLE;
          busy <= '1';

          sram_oe_n <= '0';
          sram_we_n <= '1';

		      rd_data <= std_ulogic_vector(sram_dq);
          rd_valid <= '1';

        when WRITE_START =>
          --Activate Write cycle no. 3
          s_nxt.cnt <= s.cnt + 1;
          busy <= '1';
          sram_ce_n <= '0';
          sram_oe_n <= '1';
          sram_we_n <= '0';

	        sram_addr <= std_ulogic_vector(s.addr(19 downto 0));
          sram_dq <= std_logic_vector(s.wr_data);

          --give the sram 3 cc to complete the write process
          if s.cnt = 2 then
            s_nxt.state <= IDLE;
          end if;
      end case;
	end process;
end architecture;
