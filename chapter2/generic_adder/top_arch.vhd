library ieee;
use ieee.std_logic_1164.all;

architecture top_arch_generic_adder of top is
  constant N : positive := 8;

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

  generic_adder_inst : generic_adder
    generic map (
      N => N
    )
    port map (
      A    => switches(N-1 downto 0),
      B    => switches(2*N-1 downto N),
      S    => ledr(N-1 downto 0),
      Cout => ledg(0)
    );
end architecture;
