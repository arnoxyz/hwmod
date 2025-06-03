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
      if input_a < 0 then 
        a <= std_ulogic_vector(to_signed(input_a, DATA_WIDTH));
      else 
        a <= std_ulogic_vector(to_unsigned(input_a, DATA_WIDTH));
      end if;
      if input_b < 0 then 
        b <= std_ulogic_vector(to_signed(input_b, DATA_WIDTH));
      else 
        b <= std_ulogic_vector(to_unsigned(input_b, DATA_WIDTH));
      end if;

      wait for 1 ns;

      case cmd is     
        when ALU_NOP =>
          report "(sim) check ALU_NOP";
          assert r = b   
            report "ALU_NOP r not b, " & "r= " & to_string(r) & ", b= " & to_string(b)
            severity error;
          assert z = '-' 
            report "ALU_NOP z not '-', " & "z= " & to_string(z)
            severity error;

        when ALU_SLT =>
          report "(sim) check ALU_SLT";
          if input_a < input_b then 
            assert r = ZERO 
              report "ALU_SLT  r not '1', " & 
                     "r= " & to_string(r) & ", a= " & to_string(a) & ", b= " & to_string(a)
              severity error;
          else 
            assert r = ONES  
              report "ALU_SLT  r not '0', " & "r= " & to_string(r) & ", b= " & to_string(b)
              severity error;
          end if;

          assert z = not r(0) 
              report "ALU_SLT z not r(0), " & "z= " & to_string(z) & ", r(0)= "& to_string(r(0))
              severity error;

        when ALU_SLTU =>
          report "(sim) check ALU_SLTU";
          if to_unsigned(input_a, DATA_WIDTH) < to_unsigned(input_b, DATA_WIDTH) then 
            assert r = ZERO 
              report "ALU_SLTU  r not '1', " & 
                     "r= " & to_string(r) & ", a= " & to_string(a) & ", b= " & to_string(a)
              severity error;
          else 
            assert r = ONES  
              report "ALU_SLTU  r not '0', " & 
                     "r= " & to_string(r) & ", a= " & to_string(a) & ", b= " & to_string(a)
              severity error;
          end if;

          assert z = not r(0) 
            report "ALU_SLT z not r(0), " & "z= " & to_string(z) & ", r(0)= "& to_string(r(0))
            severity error;

        when ALU_SLL =>
          report "(sim) check ALU_SLL";
            assert r = std_ulogic_vector(shift_left(to_unsigned(input_a, DATA_WIDTH), input_b)) 
              report "ALU_SLL is not correct " & "sll a= " & to_string(to_unsigned(input_a, DATA_WIDTH)) &
                     " by " & to_string(input_b) & " & result: " & to_string(r)
              severity error;

            assert z = '-' 
              report "ALU_SLL z not '-', " & "z= " & to_string(z)
              severity error;
          
        when ALU_SRL =>
          report "(sim) check ALU_SRL";
            assert r = std_ulogic_vector(shift_right(to_unsigned(input_a, DATA_WIDTH), input_b)) 
              report "ALU_SRL is not correct " & "sll a= " & to_string(to_unsigned(input_a, DATA_WIDTH)) &
                     " by " & to_string(input_b) & " & result: " & to_string(r)
              severity error;

            assert z = '-' 
              report "ALU_SRL z not '-', " & "z= " & to_string(z)
              severity error;

        when ALU_SRA =>
          report "(sim) check ALU_SRA";
            assert r = std_ulogic_vector(shift_right(to_signed(input_a, DATA_WIDTH), input_b)) 
              report "ALU_SRA is not correct " & "sll a= " & to_string(to_signed(input_a, DATA_WIDTH)) &
                     " by " & to_string(input_b) & " & result: " & to_string(r)
              severity error;

            assert z = '-' 
              report "ALU_SRA z not '-', " & "z= " & to_string(z)
              severity error;
        when ALU_ADD =>
          report "(sim) check ALU_ADD";
            assert signed(r) = to_signed(input_a + input_b, DATA_WIDTH) 
              report "ALU_ADD is not correct " & 
                    " a= " & to_string(to_signed(input_a, DATA_WIDTH)) &
                    " b= " & to_string(to_signed(input_b, DATA_WIDTH)) &
                    " a+b= " & to_string(to_signed(input_a+input_b, DATA_WIDTH)) &
                    " result=" & to_string(signed(r))
              severity error;

            assert z = '-' 
              report "ALU_ADD  z not '-', " & "z= " & to_string(z)
              severity error;

        when ALU_SUB =>
          report "(sim) check ALU_SUB";
            assert signed(r) = to_signed(input_a - input_b, DATA_WIDTH) 
              report "ALU_SUB is not correct " & 
                    " a=" & to_string(to_signed(input_a, DATA_WIDTH)) &
                    " b=" & to_string(to_signed(input_b, DATA_WIDTH)) &
                    " a-b=" & to_string(to_signed(input_a-input_b, DATA_WIDTH)) &
                    " result=" & to_string(signed(r))
              severity error;

            -- assert z if A=B to '1' else '0' 
            if (to_signed(input_a - input_b, DATA_WIDTH) = 0) then 
              assert z = '1' 
                report "ALU_SUB  z not '1', " & "z= " & to_string(z)
                severity error;
            else 
              assert z = '0' 
                report "ALU_SUB  z not '0', " & "z= " & to_string(z)
                severity error;
            end if;

        when ALU_AND =>
          report "(sim) check ALU_AND";
            assert signed(r) = (to_signed(input_a, DATA_WIDTH) and to_signed(input_b, DATA_WIDTH))
              report "ALU_AND is not correct " & 
                    " a=" & to_string(to_signed(input_a, DATA_WIDTH)) &
                    " b=" & to_string(to_signed(input_b, DATA_WIDTH)) &
                    " (a and b)=" & to_string(to_signed(input_a, DATA_WIDTH) and to_signed(input_b, DATA_WIDTH)) &
                    " result=" & to_string(signed(r))
              severity error;

            assert z = '-' 
              report "ALU_AND  z not '-', " & "z= " & to_string(z)
              severity error;

        when ALU_OR =>
          report "(sim) check ALU_OR";
            assert signed(r) = (to_signed(input_a, DATA_WIDTH) or to_signed(input_b, DATA_WIDTH))
              report "ALU_OR is not correct " & 
                    " a=" & to_string(to_signed(input_a, DATA_WIDTH)) &
                    " b=" & to_string(to_signed(input_b, DATA_WIDTH)) &
                    " (a or b)=" & to_string(to_signed(input_a, DATA_WIDTH) or to_signed(input_b, DATA_WIDTH)) &
                    " result=" & to_string(signed(r))
              severity error;


            assert z = '-' 
              report "ALU_AND  z not '-', " & "z= " & to_string(z)
              severity error;
        when ALU_XOR =>
          report "(sim) check ALU_XOR";
            assert signed(r) = (to_signed(input_a, DATA_WIDTH) xor to_signed(input_b, DATA_WIDTH))
              report "ALU_XOR is not correct " & 
                    " a=" & to_string(to_signed(input_a, DATA_WIDTH)) &
                    " b=" & to_string(to_signed(input_b, DATA_WIDTH)) &
                    " (a xor b)=" & to_string(to_signed(input_a, DATA_WIDTH) xor to_signed(input_b, DATA_WIDTH)) &
                    " result=" & to_string(signed(r))
              severity error;

            assert z = '-' 
              report "ALU_XOR  z not '-', " & "z= " & to_string(z)
              severity error;
        when others =>
          report "(sim) error";
      end case;
    end procedure;
	begin
    report "(sim) start";
    -- exec(cmd, input1, input2);
    exec(ALU_NOP, 1, 2);

    exec(ALU_SLT, -1, -20);
    exec(ALU_SLTU, 1, 2);

    exec(ALU_SLL, 1, 1);
    exec(ALU_SLL, 1, 2);

    exec(ALU_SRL, 2, 1);
    exec(ALU_SRL, 4, 2);

    exec(ALU_SRA, -8, 1);
    exec(ALU_SRA, 4, 2);

    exec(ALU_ADD, 4, 2);
    exec(ALU_ADD, 2, 4);

    exec(ALU_SUB, 2, 2);
    exec(ALU_SUB, 4, 1);

    exec(ALU_AND, 4, 4);
    exec(ALU_AND, 1, 0);

    exec(ALU_OR, 1, 0);
    exec(ALU_OR, 0, 0);

    exec(ALU_XOR, 1, 0);
    exec(ALU_XOR, 1, 1);
    report "(sim) done";
		wait;
	end process;
end architecture;
