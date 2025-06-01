library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

use work.math_pkg.all;
use work.alu_pkg.all;

entity alu is
	generic (
		DATA_WIDTH : positive := 32
	);
	port (
		op   : in  alu_op_t;
		a, b : in  std_ulogic_vector(DATA_WIDTH-1 downto 0);
		r    : out std_ulogic_vector(DATA_WIDTH-1 downto 0) := (others => '0');
		z    : out std_ulogic := '0'
  );
end entity;

architecture beh of alu is 
begin 
  comb : process(all) is 
  begin 
    case op is     
      when ALU_NOP =>
        --report "exec ALU_NOP";
        z <= '-';
        r <= b;

      when ALU_SLT =>
        --report "exec ALU_SLT";
        -- SLT = Set Less Than
        if signed(a) < signed(b) then 
          r <= (others=>'0');
        else 
          r <= (Others=>'1');
        end if;

        z <= not r(0);

      when ALU_SLTU =>
        --report "exec ALU_SLTU";
        -- SLT U = Set Less Than Unsigned=Inputs
        if unsigned(a) < unsigned(b) then 
          r <= (others=>'0');
        else 
          r <= (Others=>'1');
        end if;

        z <= not r(0);
      when ALU_SLL =>
        report "exec ALU_SLL";
      when ALU_SRL =>
        report "exec ALU_SRL";
      when ALU_SRA =>
        report "exec ALU_SRA";
      when ALU_ADD =>
        report "exec ALU_ADD";
      when ALU_SUB =>
        report "exec ALU_SUB";
      when ALU_AND =>
        report "exec ALU_AND";
      when ALU_OR =>
        report "exec ALU_OR";
      when ALU_XOR =>
        report "exec ALU_XOR";
      when others =>
    end case;
  end process;
end architecture;
