library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity generic_adder_tb is
	generic (
		TESTMODE : string := "exhaustive"
	);
end entity;

architecture bench of generic_adder_tb is
  constant N : positive := 8;
	signal A,B,S : std_ulogic_vector(N-1 downto 0);
  signal cout  : std_ulogic;

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


generic_adder_inst : generic_adder
	generic map (
		N => N
	)
	port map (
		A    => A,
		B    => B,
		S    => S,
		Cout => cout
	);



end architecture;
