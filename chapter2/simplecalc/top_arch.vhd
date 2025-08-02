library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.util_pkg.all;

architecture top_arch_simplecalc of top is
  component simplecalc is
    generic (
      DATA_WIDTH : natural := 8
    );
    port(
      clk    : in std_ulogic;
      res_n  : in std_ulogic;

      operand_data_in : in std_ulogic_vector(DATA_WIDTH-1 downto 0);
      store_operand1  : in std_ulogic;
      store_operand2  : in std_ulogic;

      sub : in std_ulogic;

      operand1 : out std_ulogic_vector(DATA_WIDTH-1 downto 0);
      operand2 : out std_ulogic_vector(DATA_WIDTH-1 downto 0);
      result   : out std_ulogic_vector(DATA_WIDTH-1 downto 0)
    );
  end component;

  constant DATA_WIDTH : natural := 8;
  signal operand1 : std_ulogic_vector(DATA_WIDTH-1 downto 0);
  signal operand2 : std_ulogic_vector(DATA_WIDTH-1 downto 0);
  signal result : std_ulogic_vector(DATA_WIDTH-1 downto 0);
begin

  calc_inst : simplecalc
  generic map( DATA_WIDTH  => DATA_WIDTH )
  port map(
      clk    => clk,
      res_n  => keys(0),
      operand_data_in => switches(7 downto 0),
      sub => switches(17),
      store_operand1  => keys(1),
      store_operand2  => keys(2),
      operand1 => operand1,
      operand2 => operand2,
      result   => result
  );

  hex7 <= to_segs(operand1(DATA_WIDTH-1 downto 4));
  hex6 <= to_segs(operand1(3 downto 0));
  hex5 <= to_segs(operand2(DATA_WIDTH-1 downto 4));
  hex4 <= to_segs(operand2(3 downto 0));
  hex3 <= to_segs(result(DATA_WIDTH-1 downto 4));
  hex2 <= to_segs(result(3 downto 0));

end architecture;
