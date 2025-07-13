library ieee;
use ieee.std_logic_1164.all;
use work.adder4_pkg.all;

entity fulladder is
	port (
		A    : in std_ulogic;
		B    : in std_ulogic;
		Cin  : in std_ulogic;

		Sum  : out std_ulogic;
		Cout : out std_ulogic
	);
end entity;

architecture beh of fulladder is
  signal sum1 : std_ulogic := '0';
  signal cout1 : std_ulogic := '0';
  signal cout2 : std_ulogic := '0';
begin
  ha1 : halfadder
  port map(
    A => A,
    B => B,
    Sum => sum1,
    Cout => cout1
  );

  ha2 : halfadder
  port map(
    A => cin,
    B => sum1,
    Sum => sum,
    Cout => cout2
  );

  or1 : or_gate
  port map(
    a => cout1,
    b => cout2,
    z => cout
  );
end architecture;
