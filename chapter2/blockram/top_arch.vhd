library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.math_pkg.all;
use work.util_pkg.all;

architecture top_arch of top is
  constant ADDR_WIDTH : positive := 4;
  constant DATA_WIDTH : positive := 4;

  component simple_dp_ram is
    generic (
      ADDR_WIDTH : positive := 8;
      DATA_WIDTH : positive := 32
    );
    port (
      clk   : in std_ulogic;
      res_n : in std_ulogic;

      rd_addr : in std_ulogic_vector(ADDR_WIDTH - 1 downto 0);
      rd_data : out std_ulogic_vector(DATA_WIDTH - 1 downto 0);

      wr_en   : in std_ulogic;
      wr_addr : in std_ulogic_vector(ADDR_WIDTH - 1 downto 0);
      wr_data : in std_ulogic_vector(DATA_WIDTH - 1 downto 0)
    );
  end component;


  signal readaddr : std_ulogic_vector(ADDR_WIDTH - 1 downto 0);
  signal writeaddr : std_ulogic_vector(ADDR_WIDTH - 1 downto 0);
  signal wrdata: std_ulogic_vector(DATA_WIDTH - 1 downto 0);
  signal rddata: std_ulogic_vector(DATA_WIDTH - 1 downto 0);

begin

  ram_inst : simple_dp_ram
    generic map(
      ADDR_WIDTH => ADDR_WIDTH,
      DATA_WIDTH => DATA_WIDTH
    )
    port map(
      clk   => clk,
      res_n => keys(0),
      wr_addr => readaddr,
      rd_addr => writeaddr,
      wr_data => wrdata,
      wr_en   => not keys(3), --keys are low active
      rd_data => rddata
    );

  --inputs
  readaddr <= switches(3 downto 0);
  writeaddr <= switches(7 downto 4);
  wrdata <= switches(11 downto 8);

  --display inputs
  hex0 <= to_segs(readaddr);
  hex1 <= to_segs(writeaddr);
  hex2 <= to_segs(wrdata);

  --display output
  hex3 <= to_segs(rddata);


end architecture;
