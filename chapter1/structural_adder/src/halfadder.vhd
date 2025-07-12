library ieee;
use ieee.std_logic_1164.all;
use work.adder4_pkg.all;

entity halfadder is
	port (
		A : in std_ulogic;
		B : in std_ulogic;

		Sum  : out std_ulogic;
		Cout : out std_ulogic
	);
end entity;

architecture beh of halfadder is
begin
  -- Sum = A XOR B
  sum_output : xor_gate
  port map(
    a => a,
    b => b,
    z => sum
  );

  -- Carry = A AND B
  carry_output : and_gate
  port map(
    a => a,
    b => b,
    z => cout
  );
end architecture;
