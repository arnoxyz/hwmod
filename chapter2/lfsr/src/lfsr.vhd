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
      x <= seed;
    elsif rising_edge(clk) then

      if load_seed_n = '0' then
        x <= seed;
      end if;

      if load_seed_n = '1' then
        --shift register

        for idx in 0 to 3 loop
          if idx = 0 then
            --start
			      x(idx) <= x(3) xor x(2); --TODO: set polynomial like here "0011";
          elsif idx = 3 then
            --end
		        prdata <= x(idx);
            x(idx) <= x(idx-1);
          else
            x(idx) <= x(idx-1);
          end if;
        end loop;
      end if;
    end if;
  end process;
end architecture;
