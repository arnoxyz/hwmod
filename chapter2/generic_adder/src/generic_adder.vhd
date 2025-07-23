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
  constant adders_cnt : positive := N/4;
  -- N=4  cnt=1
  -- N=8  cnt=2
  -- N=12 cnt=3
  -- N=16 cnt=4
  -- N=20 cnt=5

  component adder4 is
    port (
      A : in std_ulogic_vector(3 downto 0);
      B : in std_ulogic_vector(3 downto 0);
      Cin : in std_ulogic;

      S  : out std_ulogic_vector(3 downto 0);
      Cout  : out std_ulogic
    );
  end component;

  signal c : std_ulogic_vector(adders_cnt-1 downto 0);
  --1 adder needs 0
  --2 adders need 1
  --3 adders need 2
  --4 adders need 3

begin

  gen_4adder : if adders_cnt=1 generate
    adder4_inst : adder4
      port map(
        A => A(3 downto 0),
        B => B(3 downto 0),
        Cin => '0',
        S  => S(3 downto 0),
        Cout  => Cout
      );
  end generate;

  gen_more_4adders : if adders_cnt > 1 generate
    gen_4adders_loop : for i in 0 to adders_cnt-1 generate
      gen_first_adder : if i = 0 generate
        adder4_inst : adder4
          port map(
            A => A(3 downto 0),
            B => B(3 downto 0),
            Cin => '0',
            S  => S(3 downto 0),
            Cout  => c(i)
          );
      end generate;

      gen_middle_adders : if ((i > 0) and (i < adders_cnt-2))  generate
        adder4_inst : adder4
          port map(
            A => A(i*4+3 downto i*4+0),
            B => B(i*4+3 downto i*4+0),
            Cin => c(i-1),
            S  => S(i*4+3 downto i*4+0),
            Cout  => c(i)
          );
      end generate;

      gen_last_adder : if i = adders_cnt-1 generate
      adder4_inst : adder4
          port map(
            A => A(i*4+3 downto i*4+0),
            B => B(i*4+3 downto i*4+0),
            Cin => c(i-1),
            S  => S(i*4+3 downto i*4+0),
            Cout  => Cout
          );
      end generate;
    end generate;
  end generate;
end architecture;
