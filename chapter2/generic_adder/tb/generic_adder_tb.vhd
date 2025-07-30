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
	signal A_fibo, B_fibo, Sum_fibo : std_ulogic_vector(N_fibo-1 downto 0);
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
      --report "sum_out is " & to_string(to_integer(unsigned(sum_ex)));
      --report "cout is " & to_string(cout_ex);
		end procedure;

		procedure fibo_test is
      constant N : integer := N_fibo;

      variable a_in : unsigned(N-1 downto 0) := (others=>'0');
      variable b_in : unsigned(N-1 downto 0) := (0=>'1', others=>'0');
	    variable prev_sum : std_ulogic_vector(N-1 downto 0) := (others=>'0');
		begin
      -- Fib Sequence is: {0 1 1 2 3 5 8 13 and so on... }

      -- First Iteration:
      -- set first: a=0, b=1, => sum1=1
      a_fibo <= std_ulogic_vector(a_in);
      b_fibo <= std_ulogic_vector(b_in);
      wait for 1 ns;

      -- Second Iteration: a=sum1, b=1, => sum2=2
      a_in := unsigned(sum_fibo);
      b_in := (0=>'0', others=>'0');
      a_fibo <= std_ulogic_vector(a_in);
      b_fibo <= std_ulogic_vector(b_in);
      prev_sum := sum_fibo;
      wait for 1 ns;

      -- Third Iteration: a=sum2 (actual output = sum2) , b=sum1 (prev_sum), => sum3=3
      -- N-Iteration: a=sum_n (actual output = sum_n on sum_fibo output) , b=sum_n-1 (prev_sum), => sum_n+1
      for i in 0 to 50 loop
        a_in := unsigned(sum_fibo);
        b_in := unsigned(prev_sum);
        a_fibo <= std_ulogic_vector(a_in);
        b_fibo <= std_ulogic_vector(b_in);
        prev_sum := sum_fibo;
        wait for 1 ns;

        --for debugging
        --report to_string(cout_fibo);

        if cout_fibo = '1' then
          report "Overflow";
          report "Last Fibo Number: " & to_string(to_integer(unsigned(sum_fibo)));
          exit;
        end if;
      end loop;
		end procedure;


  begin
    report "start sim";
    if TESTMODE = "exhaustive" then
      --exhaustively tests whether it correctly calculates all possible A * B possible additions.
      report "EXHAUSTIVE!";
      for i in 0 to 2**8-1 loop
        for j in 0 to 2**8-1 loop
          exhaustive_test(i,j);
        end loop;
      end loop;

    elsif TESTMODE = "fibonacci" then
      --TODO: write fibonacci test-case
      report "Fibonacci!";
      -- Instantiate a 32-bit adder and use it to calculate the fibonacci sequence starting by adding 0 and 1.
      -- Stop when the carry out bit is high and report the last calculated number as well as the number of steps it took to get there.
		  fibo_test;
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
      S    => Sum_fibo,
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
