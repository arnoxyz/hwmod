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
    variable feedback : std_ulogic := '0';
  begin

    if res_n = '0' then
      x <= seed;
    elsif rising_edge(clk) then
      --set default val
      prdata <= '0';

      if load_seed_n = '0' then
        x <= seed;
      end if;

      if load_seed_n = '1' then
        --shift register

        --start
        for idy in LFSR_WIDTH-1 downto 0 loop
          if polynomial(idy) = '1' then
            feedback := feedback xor x(idy);
          end if;
        end loop;

        --report to_string(x(3)) & " xor " & to_string(x(2)) & " is " & to_string(feedback);
        assert (x(7) xor x(5) xor x(2)) = feedback report "ERROR in feedback logic";
	      --POLY_8 "10100100"; meaning x(7) xor x(5) xor x(2)
        x(0) <= feedback;
        feedback := '0';

        --shifting outputs
        for idx in 1 to LFSR_WIDTH-1 loop
            x(idx) <= x(idx-1);
        end loop;

        --output
		    prdata <= x(LFSR_WIDTH-1);
      end if;
    end if;
  end process;
end architecture;
