library ieee;
use ieee.std_logic_1164.all;
use work.adder4_pkg.all;

entity adder4 is
	port (
		A    : in std_ulogic_vector(3 downto 0);
		B    : in std_ulogic_vector(3 downto 0);
		Cin  : in std_ulogic;

		S    : out std_ulogic_vector(3 downto 0);
		Cout : out std_ulogic
	);
end entity;

architecture beh of adder4 is
  signal c1_out, c2_out, c3_out : std_ulogic := '0';
begin

  FA1 : fulladder
  port map(
			A    => A(0),
			B    => B(0),
			Cin  => Cin,
			Sum  => S(0),
			Cout => c1_out
  );

  FA2 : fulladder
  port map(
			A    => A(1),
			B    => B(1),
			Cin  => c1_out,
			Sum  => S(0),
			Cout => c2_out
  );

  FA3 : fulladder
  port map(
			A    => A(2),
			B    => B(2),
			Cin  => c2_out,
			Sum  => S(2),
			Cout => c3_out
  );

  FA4 : fulladder
  port map(
			A    => A(3),
			B    => B(3),
			Cin  => c3_out,
			Sum  => S(3),
			Cout => Cout
  );
end architecture;
