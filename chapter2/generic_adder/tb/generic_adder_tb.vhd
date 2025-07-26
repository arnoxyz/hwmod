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
	signal A_ex , B_ex , S_ex : std_ulogic_vector(N_ex-1 downto 0);
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
  begin
    report "start sim";
    if TESTMODE = "exhaustive" then
      --TODO: write exhaustive test-case
      --Instantiate an 8-bit adder and create a stimulus process that exhaustively tests whether it correctly calculates all possible A * B possible additions.
      --Do not forget to also check the correct value of the Cout signal.
      report "EXHAUSTIVE!";

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
      S    => S_ex,
      Cout => cout_ex
    );
end generate;



end architecture;
