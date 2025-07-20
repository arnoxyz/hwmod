library ieee;
use ieee.std_logic_1164.all;

entity generic_adder is
	generic (
		N : positive := 4
	);
	port (
		A    : in std_ulogic_vector(N-1 downto 0);
		B    : in std_ulogic_vector(N-1 downto 0);

		S    : out std_ulogic_vector(N-1 downto 0);
		Cout : out std_ulogic
	);
end entity;



architecture beh of generic_adder is
  component adder4 is
    port (
      A : in std_ulogic_vector(3 downto 0);
      B : in std_ulogic_vector(3 downto 0);
      Cin : in std_ulogic;

      S  : out std_ulogic_vector(3 downto 0);
      Cout  : out std_ulogic
    );
  end component;

begin

-- N=4
adder4_inst : adder4
	port map(
		A => A,
		B => B,
		Cin => '0',
		S  => S,
		Cout  => open
	);

end architecture;
