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
  type fsm_state_t is (IDLE, WRITE, READ);

  type reg_t is record
    state : fsm_state_t;
  end record;

  constant RESET_VAL : reg_t := (state=>IDLE);
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

      case s.state is
        when IDLE  =>
          if rd = '1' then
            s_nxt.state <= READ;
          end if;

          if wr = '1' then
            s_nxt.state <= WRITE;
          end if;

        when READ  =>
          report "in READ";
        when WRITE =>
          report "in WRITE";
      end case;



	end process;
end architecture;
