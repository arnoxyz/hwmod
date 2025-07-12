library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.adder4_pkg.all;

entity adder4_tb is
end entity;

architecture tb of adder4_tb is
  signal output1, output2, output3 : std_ulogic;
  signal a,b : std_ulogic;

begin
  UUT1 : and_gate
  port map(
    a => a,
    b => b,
    z => output1
  );

  UUT2 : xor_gate
  port map(
    a => a,
    b => b,
    z => output2
  );

  UUT3 : or_gate
  port map(
    a => a,
    b => b,
    z => output3
  );

  testing_gates : process is
    procedure testing_basic_gates is
    begin
      report "start - sim basic gates";
      a <= '0';
      b <= '0';
      wait for 1 ns;
      report "Input=" & to_string(a) & to_string(b) & " and="& to_string(output1) & " xor=" & to_string(output2) &" or=" & to_string(output3);

      a <= '1';
      b <= '0';
      wait for 1 ns;
      report "Input=" & to_string(a) & to_string(b) & " and="& to_string(output1) & " xor=" & to_string(output2) &" or=" & to_string(output3);

      a <= '0';
      b <= '1';
      wait for 1 ns;
      report "Input=" & to_string(a) & to_string(b) & " and="& to_string(output1) & " xor=" & to_string(output2) &" or=" & to_string(output3);

      a <= '1';
      b <= '1';
      wait for 1 ns;
      report "Input=" & to_string(a) & to_string(b) & " and="& to_string(output1) & " xor=" & to_string(output2) &" or=" & to_string(output3);

      report "done testing basic gates";
    end procedure;

  begin
    testing_basic_gates;
    wait;
  end process;



	-- Instantiate the unit under test (adder4)

	-- Stimulus process
	stimulus: process
		-- implement this procedure!
		procedure test_values(value_a, value_b, value_cin : integer) is
		begin
			-- assert that Sum is correct
			-- assert Cout is correct
		end procedure;
	begin
		report "simulation start";

		-- Apply test stimuli
		test_values(0,0,0);

		report "simulation end";
		-- End simulation
		wait;
	end process;
end architecture;

