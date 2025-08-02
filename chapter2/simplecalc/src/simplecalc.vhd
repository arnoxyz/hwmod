
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity simplecalc is
	generic (
		DATA_WIDTH : natural := 8
	);
	port(
		clk    : in std_ulogic;
		res_n  : in std_ulogic;

		operand_data_in : in std_ulogic_vector(DATA_WIDTH-1 downto 0);
		store_operand1  : in std_ulogic;
		store_operand2  : in std_ulogic;

		sub : in std_ulogic;

		operand1 : out std_ulogic_vector(DATA_WIDTH-1 downto 0);
		operand2 : out std_ulogic_vector(DATA_WIDTH-1 downto 0);
		result   : out std_ulogic_vector(DATA_WIDTH-1 downto 0)
	);
end entity;

architecture arch of simplecalc is
  signal store_op1 : std_ulogic;
  signal store_op2 : std_ulogic;
begin

  sync : process(clk, res_n) is
  begin
    if res_n = '0' then
      operand1 <= (others=>'0');
      operand2 <= (others=>'0');
      store_op1 <= '0';
      store_op2 <= '0';
    elsif rising_edge(clk) then
      store_op1 <= store_operand1;
      store_op2 <= store_operand2;

      -- detect fallin transition
      if store_op1 = '1' and store_operand1 = '0' then
        operand1 <= operand_data_in;
      elsif store_op2 = '1' and store_operand2 = '0' then
        operand2 <= operand_data_in;
      end if;
    end if;
  end process;

  comb : process(all) is
  begin
    if sub = '0' then
      result <= std_ulogic_vector(unsigned(operand1)+unsigned(operand2));
    else
      result <= std_ulogic_vector(unsigned(operand1)-unsigned(operand2));
    end if;
  end process;
end architecture;
