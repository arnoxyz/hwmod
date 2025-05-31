library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.math_real.all;

use work.math_pkg.all;
use work.alu_pkg.all;

entity alu_tb is
end entity;

architecture tb of alu_tb is
  constant DATA_WIDTH : positive := 32;
  -- Inputs
  signal a : std_ulogic_vector(DATA_WIDTH-1 downto 0) := (others => '0');
  signal b : std_ulogic_vector(DATA_WIDTH-1 downto 0) := (others => '0');
  signal op : alu_op_t := ALU_NOP;
  -- Outputs
  signal r : std_ulogic_vector(DATA_WIDTH-1 downto 0);
  signal z : std_ulogic;
begin

	-- Instantiate your ALU here
  UUT : alu 
  generic map( DATA_WIDTH => DATA_WIDTH)
  port map(
    op => op,
    a => a, 
    b => b, 
    r => r,
    z => z
  );

	stimuli : process
    procedure exec(cmd : alu_op_t; input_a : integer; input_b : integer) is 
      constant ZERO : std_ulogic_vector(DATA_WIDTH - 1 downto 0) := (others=>'0');
      constant ONES : std_ulogic_vector(DATA_WIDTH - 1 downto 0) := (others=>'1');
    begin 
      -- apply inputs to the UUT
      op <= cmd;
      a <= std_ulogic_vector(to_unsigned(input_a, DATA_WIDTH));
      b <= std_ulogic_vector(to_unsigned(input_b, DATA_WIDTH));
      wait for 1 ns;

      case cmd is     
        when ALU_NOP =>
          report "(sim) check ALU_NOP";
          assert r = b   report "ALU_NOP r not b, " & "r= " & to_string(r) & ", b= " & to_string(b);
          assert z = '-' report "ALU_NOP z not '-', " & "z= " & to_string(z);
        when ALU_SLT =>
          report "(sim) check ALU_SLT";
          if input_a < input_b then 
            assert r = ZERO report "ALU_SLT  r not '1', " & 
                                   "r= " & to_string(r) & ", a= " & to_string(a) & ", b= " & to_string(a);
          else 
            assert r = ONES  report "ALU_SLT  r not '0', " & "r= " & to_string(r) & ", b= " & to_string(b);
          end if;

          assert z = not r(0) report "ALU_SLT z not r(0), " & "z= " & to_string(z) & ", r(0)= "& to_string(r(0));

        when ALU_SLTU =>
          report "(sim) check ALU_SLTU";
        when ALU_SLL =>
          report "(sim) check ALU_SLL";
        when ALU_SRL =>
          report "(sim) check ALU_SRL";
        when ALU_SRA =>
          report "(sim) check ALU_SRA";
        when ALU_ADD =>
          report "(sim) check ALU_ADD";
        when ALU_SUB =>
          report "(sim) check ALU_SUB";
        when ALU_AND =>
          report "(sim) check ALU_AND";
        when ALU_OR =>
          report "(sim) check ALU_OR";
        when ALU_XOR =>
          report "(sim) check ALU_XOR";
        when others =>
          report "(sim) error";
      end case;
    end procedure;
	begin
    report "(sim) start";
    -- TODO: Test all op inputs
    -- exec(cmd, input1, input2);
    exec(ALU_NOP, 1, 2);

    exec(ALU_SLT, 1, 2);
    report "(sim) done";
		wait;
	end process;
end architecture;
