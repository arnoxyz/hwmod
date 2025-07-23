library ieee;
use ieee.std_logic_1164.all;

entity generic_adder is
	generic (
		N : positive := 12 --4
	);
	port (
		A    : in std_ulogic_vector(N-1 downto 0);
		B    : in std_ulogic_vector(N-1 downto 0);

		S    : out std_ulogic_vector(N-1 downto 0);
		Cout : out std_ulogic
	);
end entity;



architecture beh of generic_adder is
  constant adders_cnt : positive := 12/4; -- 12/4 = 3

  component adder4 is
    port (
      A : in std_ulogic_vector(3 downto 0);
      B : in std_ulogic_vector(3 downto 0);
      Cin : in std_ulogic;

      S  : out std_ulogic_vector(3 downto 0);
      Cout  : out std_ulogic
    );
  end component;

  /*
  N=12, 12/4 = 3 => 3x4Bit adders

  Input is:
  A    : in std_ulogic_vector(11 downto 0);
  B    : in std_ulogic_vector(11 downto 0);

  S    : out std_ulogic_vector(11 downto 0);
  Cout : out std_ulogic

  A1 = 3 2 1 0
  A2 = 7 6 5 4
  A3 = 11 10 9 8

  B1 = 3 2 1 0
  B2 = 7 6 5 4
  B3 = 11 10 9 8

  S1 = 3 2 1 0
  S2 = 7 6 5 4
  S3 = 11 10 9 8
  */

  signal c1, c2 : std_ulogic;
begin

adder4_inst_1 : adder4
	port map(
		A => A(3 downto 0),
		B => B(3 downto 0),
		Cin => '0',
		S  => S(3 downto 0),
		Cout  => c1
	);

adder4_inst_2 : adder4
	port map(
		A => A(7 downto 4),
		B => B(7 downto 4),
		Cin => c1,
		S  => S(7 downto 4),
		Cout  => c2
	);

adder4_inst_3 : adder4
	port map(
		A => A(11 downto 8),
		B => B(11 downto 8),
		Cin => c2,
		S  => S(11 downto 8),
		Cout  => Cout
	);
end architecture;
