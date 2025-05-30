library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.math_real.all;

use work.math_pkg.all;
use work.alu_pkg.all;

entity alu_tb is
end entity;

architecture tb of alu_tb is
  constant DATA_WIDTH : positive := 32;

  -- Inputs
  signal a : std_ulogic_vector(DATA_WIDTH-1 downto 0);
  signal b : std_ulogic_vector(DATA_WIDTH-1 downto 0);
  signal op : alu_op_t;

  -- Outputs
  signal r : std_ulogic_vector(DATA_WIDTH-1 downto 0);
  signal z : std_ulogic;
begin

	-- Instantiate your ALU here
  UUT : alu 
  generic map( DATA_WIDTH => DATA_WIDTH)
  port map(
    op => op,
    a => a, 
    b => b, 
    r => r,
    z => z
  );

	stimuli : process
	begin
    report "sim start";
    -- TODO: Test all op inputs
    op <= ALU_NOP;
    wait for 1 ns;
    op <= ALU_SLT;
		wait;
    report "sim done";
	end process;
end architecture;
