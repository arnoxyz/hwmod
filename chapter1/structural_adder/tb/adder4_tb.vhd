library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.adder4_pkg.all;

entity adder4_tb is
end entity;

architecture tb of adder4_tb is
  -- for testing basic gates
  signal output1, output2, output3 : std_ulogic;
  signal a,b : std_ulogic;

  -- for testing halfadder
  signal sum, carry : std_ulogic;

  -- for testing fulladder
  signal cin : std_ulogic;
  signal sum_fa, carry_fa : std_ulogic;

  -- for testing 4bitadder
  signal a_in, b_in, sum_out : std_ulogic_vector(3 downto 0);
  signal cout_out : std_ulogic;

begin
  UUT1 : and_gate
  port map(
    a => a,
    b => b,
    z => output1
  );

  UUT2 : xor_gate
  port map(
    a => a,
    b => b,
    z => output2
  );

  UUT3 : or_gate
  port map(
    a => a,
    b => b,
    z => output3
  );

  ha : halfadder
  port map (
    A => a,
    B => b,
    Sum => sum,
    Cout => carry
  );

  fa : fulladder
  port map (
    A => a,
    B => b,
    cin => cin,
    Sum => sum_fa,
    Cout => carry_fa
  );

  inst_add4 : adder4
  port map(
    A => a_in,
    B => b_in,
    Cin => cin,
    S => sum_out,
    Cout => cout_out
  );

  testing_gates : process is
    procedure testing_basic_gates is
    begin
      report "start - sim basic gates";
      a <= '0';
      b <= '0';
      wait for 1 ns;
      report "Input=" & to_string(a) & to_string(b) & " and="& to_string(output1) & " xor=" & to_string(output2) &" or=" & to_string(output3);

      a <= '1';
      b <= '0';
      wait for 1 ns;
      report "Input=" & to_string(a) & to_string(b) & " and="& to_string(output1) & " xor=" & to_string(output2) &" or=" & to_string(output3);

      a <= '0';
      b <= '1';
      wait for 1 ns;
      report "Input=" & to_string(a) & to_string(b) & " and="& to_string(output1) & " xor=" & to_string(output2) &" or=" & to_string(output3);

      a <= '1';
      b <= '1';
      wait for 1 ns;
      report "Input=" & to_string(a) & to_string(b) & " and="& to_string(output1) & " xor=" & to_string(output2) &" or=" & to_string(output3);

      report "done testing basic gates";
    end procedure;

    procedure testing_ha is
    begin
      report "start - sim ha";
      a <= '0';
      b <= '0';
      wait for 1 ns;
      report "Input=" & to_string(a) & to_string(b) & " sum="& to_string(sum) & " carry=" & to_string(carry);

      a <= '1';
      b <= '0';
      wait for 1 ns;
      report "Input=" & to_string(a) & to_string(b) & " sum="& to_string(sum) & " carry=" & to_string(carry);

      a <= '0';
      b <= '1';
      wait for 1 ns;
      report "Input=" & to_string(a) & to_string(b) & " sum="& to_string(sum) & " carry=" & to_string(carry);

      a <= '1';
      b <= '1';
      wait for 1 ns;
      report "Input=" & to_string(a) & to_string(b) & " sum="& to_string(sum) & " carry=" & to_string(carry);
      report "done - sim ha";
    end procedure;

    procedure testing_fa is
    begin
      report "start - sim fa";
      a <= '0';
      b <= '0';
      cin <= '0';
      wait for 1 ns;
      report "Input=" & to_string(a) & to_string(b) & to_string(cin) & " sum="& to_string(sum_fa) & " carry=" & to_string(carry_fa);

      a <= '1';
      b <= '0';
      cin <= '0';
      wait for 1 ns;
      report "Input=" & to_string(a) & to_string(b) & to_string(cin) & " sum="& to_string(sum_fa) & " carry=" & to_string(carry_fa);

      a <= '0';
      b <= '1';
      cin <= '0';
      wait for 1 ns;
      report "Input=" & to_string(a) & to_string(b) & to_string(cin) & " sum="& to_string(sum_fa) & " carry=" & to_string(carry_fa);

      a <= '1';
      b <= '1';
      cin <= '0';
      wait for 1 ns;
      report "Input=" & to_string(a) & to_string(b) & to_string(cin) & " sum="& to_string(sum_fa) & " carry=" & to_string(carry_fa);

      a <= '0';
      b <= '0';
      cin <= '1';
      wait for 1 ns;
      report "Input=" & to_string(a) & to_string(b) & to_string(cin) & " sum="& to_string(sum_fa) & " carry=" & to_string(carry_fa);

      a <= '1';
      b <= '0';
      cin <= '1';
      wait for 1 ns;
      report "Input=" & to_string(a) & to_string(b) & to_string(cin) & " sum="& to_string(sum_fa) & " carry=" & to_string(carry_fa);

      a <= '0';
      b <= '1';
      cin <= '1';
      wait for 1 ns;
      report "Input=" & to_string(a) & to_string(b) & to_string(cin) & " sum="& to_string(sum_fa) & " carry=" & to_string(carry_fa);

      a <= '1';
      b <= '1';
      cin <= '1';
      wait for 1 ns;
      report "Input=" & to_string(a) & to_string(b) & to_string(cin) & " sum="& to_string(sum_fa) & " carry=" & to_string(carry_fa);
      report "done - sim ha";
    end procedure;

    --for testing the 4 bit adder
		procedure test_values(value_a, value_b, value_cin : integer) is
      variable local_calc : std_ulogic_vector(4 downto 0 ) := (others => '0');
      variable local_sum : std_ulogic_vector(3 downto 0 ) := (others => '0');
      variable local_cout  : std_ulogic := '0';
		begin
      -- set inputs
      --a_in <= ;
      --b_in <= ;
      --cin <= ;

      --local sum and cout (expected results to check the actuall results of the design)
      local_calc := std_ulogic_vector(to_unsigned(value_a + value_b + value_cin, 5));
      local_sum := local_calc(3 downto 0);
      local_cout := local_calc(4);
      wait for 1 ns;

      -- check outputs
      --report to_string(sum_out);
      --report to_string(cout_out);
			-- assert that Sum is correct (sum_out)
			-- assert Cout is correct (cout_out)
		end procedure;

    procedure testing_4bitadder is
    begin
      report "start - sim 4bitadder";
		  test_values(1,0,0);
      report "done - sim 4bitadder";
    end procedure;


  begin
    --testing_basic_gates;
    --testing_ha;
    --testing_fa;
    testing_4bitadder;
    wait;
  end process;
end architecture;
