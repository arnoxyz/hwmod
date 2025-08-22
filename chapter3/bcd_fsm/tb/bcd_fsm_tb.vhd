library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

use work.util_pkg.all;

entity bcd_fsm_tb is
end entity;

architecture tb of bcd_fsm_tb is
  constant DATA_WIDTH : integer := 16;
  --clk
  constant CLK_PERIOD : time := 2 ns;

  signal clk         : std_ulogic;
  signal res_n       : std_ulogic := '0';
  signal clk_stop    : std_ulogic := '0';

  --in
	signal input_data : std_ulogic_vector(DATA_WIDTH-1 downto 0) := (others=>'0');
	signal signed_mode : std_ulogic := '0';

  --out
	signal hex_digit1000, hex_digit100, hex_digit10, hex_digit1, hex_sign: std_ulogic_vector(6 downto 0);

  component bcd_fsm is
    port(
      clk         : in std_ulogic;
      res_n       : in std_ulogic;

      input_data  : in std_ulogic_vector(15 downto 0);
      signed_mode : in std_ulogic;

      hex_digit1     : out std_ulogic_vector(6 downto 0);
      hex_digit10    : out std_ulogic_vector(6 downto 0);
      hex_digit100   : out std_ulogic_vector(6 downto 0);
      hex_digit1000  : out std_ulogic_vector(6 downto 0);
      hex_sign       : out std_ulogic_vector(6 downto 0)
    );
  end component;

begin
	stimulus : process
    procedure test_input_change is begin

      --test start-process with changing singed_mode input
      signed_mode <= '1';
      wait for 10*clk_period;
      signed_mode <= '0';
      wait for 10*clk_period;
      signed_mode <= '1';
      wait for 10*clk_period;
      signed_mode <= '0';
      wait for 10*clk_period;
      signed_mode <= '0';

      --test start-process with changing data input
      wait for 10*clk_period;
      input_data  <= (0=>'1', others=>'0');
      wait for 10*clk_period;
      input_data  <= (others=>'0');
      wait for 10*clk_period;
      input_data  <= (others=>'1');
      wait for 10*clk_period;
    end procedure;

    procedure apply_input(data : integer) is
    begin
      signed_mode <= '0';
      input_data  <= std_ulogic_vector(to_unsigned(data, DATA_WIDTH));
      wait for 100*clk_period;
    end procedure;

    procedure test_unsigned_input(input_val : integer) is
      variable input_digit1     : integer;
      variable input_digit10    : integer;
      variable input_digit100   : integer;
      variable input_digit1000  : integer;
    begin
      input_digit1     := input_val mod 10;
      input_digit10    := (input_val/10) mod 10;
      input_digit100   := (input_val/100) mod 10;
      input_digit1000  := (input_val/1000) mod 10;

      apply_input(input_val);

      assert to_segs(std_ulogic_vector(to_unsigned(input_digit1, 4))) = hex_digit1
        report "input_digit1 /= hex_digit1 " & to_string(to_segs(std_ulogic_vector(to_unsigned(input_digit1, 4)))) & " " & to_string(hex_digit1);

      assert to_segs(std_ulogic_vector(to_unsigned(input_digit10, 4))) = hex_digit10
        report "input_digit1 /= hex_digit1 " & to_string(to_segs(std_ulogic_vector(to_unsigned(input_digit10, 4)))) & " " & to_string(hex_digit10);

      assert to_segs(std_ulogic_vector(to_unsigned(input_digit100, 4))) = hex_digit100
        report "input_digit1 /= hex_digit1 " & to_string(to_segs(std_ulogic_vector(to_unsigned(input_digit100, 4)))) & " " & to_string(hex_digit100);

      assert to_segs(std_ulogic_vector(to_unsigned(input_digit1000, 4))) = hex_digit1000
        report "input_digit1 /= hex_digit1 " & to_string(to_segs(std_ulogic_vector(to_unsigned(input_digit1000, 4)))) & " " & to_string(hex_digit1000);
    end procedure;

    procedure test_unsigned is
    begin
      for i in 0 to 9999 loop
        report "test with input = " & to_string(i);
        test_unsigned_input(i);
      end loop;
    end procedure;


    procedure apply_input_signed(data : integer) is
    begin
      signed_mode <= '1';
      input_data  <= std_ulogic_vector(to_signed(data, DATA_WIDTH));
      wait for 50*clk_period;
    end procedure;

    procedure test_signed_input(input_val : integer) is
      variable input_digit1     : integer;
      variable input_digit10    : integer;
      variable input_digit100   : integer;
      variable input_digit1000  : integer;
    begin
      input_digit1     := input_val mod 10;
      input_digit10    := (input_val/10) mod 10;
      input_digit100   := (input_val/100) mod 10;
      input_digit1000  := (input_val/1000) mod 10;

      apply_input_signed(input_val);
    end procedure;

	begin
    report "sim start";
    res_n <= '0';
    wait for 10*clk_period;
    res_n <= '1';
    wait for 10*clk_period;

    --test_input_change;
    --test_unsigned;

      --test for input bigger than 9999
    --apply_input(10000);
    --apply_input(19011);


    test_signed_input(-7821);
    --test_signed_input(8432);

    clk_stop <= '1';
    report "done sim ";
    wait;
	end process;

	uut : entity work.bcd_fsm
		port map (
			clk           => clk,
			res_n         => res_n,
			input_data    => input_data,
			signed_mode   => signed_mode,
			hex_digit1000 => hex_digit1000,
			hex_digit100  => hex_digit100,
			hex_digit10   => hex_digit10,
			hex_digit1    => hex_digit1,
			hex_sign      => hex_sign
		);

	clk_gen : process
	begin
    clk <= '0';
    wait for clk_period / 2;
    clk <= '1';
    wait for clk_period / 2;

    if clk_stop = '1' then
      wait;
    end if;
	end process;
end architecture;
