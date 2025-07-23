library ieee;
use ieee.std_logic_1164.all;

architecture top_arch_generic_adder of top is
  constant N : positive := 12;

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
      A    => switches(11 downto 0),
      B    => switches(11 downto 0),
      S    => ledr(11 downto 0),
      Cout => ledg(0)
    );
end architecture;
