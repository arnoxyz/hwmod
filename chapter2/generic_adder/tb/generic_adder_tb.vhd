library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity generic_adder_tb is
	generic (
		TESTMODE : string := "exhaustive"
	);
end entity;

architecture bench of generic_adder_tb is
  constant N : positive := 4;
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
    A <= "0001";
    B <= "0001";
    wait for 1 ns;
    report to_string(S);
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
