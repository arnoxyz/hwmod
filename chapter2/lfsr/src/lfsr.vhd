library ieee;
use ieee.std_logic_1164.all;

entity lfsr is
	generic (
		LFSR_WIDTH : integer;
		POLYNOMIAL : std_ulogic_vector
	);
	port (
		clk         : in std_ulogic;
		res_n       : in std_ulogic;
		load_seed_n : in std_ulogic;
		seed        : in std_ulogic_vector(LFSR_WIDTH-1 downto 0);
		prdata      : out std_ulogic
	);
end entity;

architecture arch of lfsr is
  signal seed_reg : std_ulogic_vector(LFSR_WIDTH-1 downto 0);
begin
  sync : process(clk, res_n) is
  begin
    if res_n = '0' then
      seed_reg <= (others=>'0');
    elsif rising_edge(clk) then
      if load_seed_n = '0' then
        seed_reg <= seed;
      end if;
    end if;
  end process;
end architecture;
