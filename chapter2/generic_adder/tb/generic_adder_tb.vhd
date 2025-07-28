library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity generic_adder_tb is
	generic (
		TESTMODE : string := "exhaustive"
	);
end entity;

architecture bench of generic_adder_tb is
  constant N_ex : positive := 8;
	signal A_ex , B_ex , Sum_ex : std_ulogic_vector(N_ex-1 downto 0);
  signal cout_ex: std_ulogic;

  constant N_fibo : positive := 32;
	signal A_fibo, B_fibo, S_fibo : std_ulogic_vector(N_fibo-1 downto 0);
  signal cout_fibo  : std_ulogic;


  component generic_adder is
    generic (
      N : positive := 4
    );
    port (
      A    : in std_ulogic_vector(N-1 downto 0);
      B    : in std_ulogic_vector(N-1 downto 0);
      S    : out std_ulogic_vector(N-1 downto 0);
      Cout : out std_ulogic
    );
  end component;
begin


  stimulus : process is
		procedure exhaustive_test(value_a, value_b : integer) is
      variable local_calc : std_ulogic_vector(8 downto 0 ) := (others => '0');
      variable local_sum : std_ulogic_vector(7 downto 0 ) := (others => '0');
      variable local_cout  : std_ulogic := '0';
		begin
      -- set inputs
      a_ex <= std_ulogic_vector(to_unsigned(value_a, 8));
      b_ex <= std_ulogic_vector(to_unsigned(value_b, 8));

      --local sum and cout (expected results to check the actuall results of the design)
      local_calc := std_ulogic_vector(to_unsigned(value_a + value_b, 9));
      local_sum := local_calc(7 downto 0);
      local_cout := local_calc(8);
      wait for 1 ns;

      -- check outputs
      assert sum_ex = local_sum report "sum is wrong: " & to_string(sum_ex) & " /= " & to_string(local_sum);
      assert cout_ex = local_cout report "cout is wrong: " & to_string(cout_ex) & " /= " & to_string(local_cout);

      -- for debugging and some manuall input checks
      report "sum_out is " & to_string(to_integer(unsigned(sum_ex)));
      report "cout is " & to_string(cout_ex);
		end procedure;


  begin
    report "start sim";
    if TESTMODE = "exhaustive" then
      --TODO: write exhaustive test-case
      --Instantiate an 8-bit adder and create a stimulus process that exhaustively tests whether it correctly calculates all possible A * B possible additions.
      --Do not forget to also check the correct value of the Cout signal.
      report "EXHAUSTIVE!";
      exhaustive_test(10,10);




    elsif TESTMODE = "fibonacci" then
      --TODO: write fibonacci test-case
      report "Fibonacci!";
      -- Instantiate a 32-bit adder and use it to calculate the fibonacci sequence starting by adding 0 and 1.
      -- Stop when the carry out bit is high and report the last calculated number as well as the number of steps it took to get there.
    end if;

    report "end sim";
    wait;
  end process;


gen_fibo : if TESTMODE = "fibonacci" generate
  generic_adder_inst : generic_adder
    generic map (
      N => N_fibo
    )
    port map (
      A    => A_fibo,
      B    => B_fibo,
      S    => S_fibo,
      Cout => cout_fibo
    );
end generate;

gen_ex : if TESTMODE = "exhaustive" generate
  generic_adder_inst : generic_adder
    generic map (
      N => N_ex
    )
    port map (
      A    => A_ex,
      B    => B_ex,
      S    => Sum_ex,
      Cout => cout_ex
    );
end generate;



end architecture;
