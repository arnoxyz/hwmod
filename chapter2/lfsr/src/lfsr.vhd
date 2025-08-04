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
  signal x : std_ulogic_vector(LFSR_WIDTH-1 downto 0);

begin
  sync : process(clk, res_n) is
  begin
    if res_n = '0' then
      -- apply seed to the regs (init values)
      x(0) <= seed(0);
      x(1) <= seed(1);
      x(2) <= seed(2);
      x(3) <= seed(3);

    elsif rising_edge(clk) then
      if load_seed_n = '0' then
        x <= seed;
      end if;

      --using load_seed_n as shift enable signal
      if load_seed_n = '1' then
			  x(0) <= x(3) xor x(2);
				x(1) <= x(0);
				x(2) <= x(1);
				x(3) <= x(2);
		    prdata <= x(3);
      end if;
    end if;
  end process;
end architecture;
