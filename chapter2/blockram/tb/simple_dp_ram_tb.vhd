library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use std.textio.all;

entity simple_dp_ram_tb is
end entity;

architecture tb of simple_dp_ram_tb is
  --file
  file input_file : text open read_mode is "./tb/debugdata_in.txt";
  file output_file : text open read_mode is "./tb/debugdata_out.txt";

  --clk stuff
	constant CLK_PERIOD : time := 20 ns;
	signal clk_stop : std_ulogic := '0';
	signal clk : std_ulogic := '0';
  signal res_n : std_ulogic := '0';

  --generics
  constant ADDR_WIDTH : positive := 8;
  constant DATA_WIDTH : positive := 8;

  --in
  signal rd_addr : std_ulogic_vector(ADDR_WIDTH - 1 downto 0) := (others=>'0');
  signal wr_en   : std_ulogic := '1';
  signal wr_addr : std_ulogic_vector(ADDR_WIDTH - 1 downto 0) := (others=>'0');
  signal wr_data : std_ulogic_vector(DATA_WIDTH - 1 downto 0) := (others=>'0');

  --out
  signal rd_data : std_ulogic_vector(DATA_WIDTH - 1 downto 0);

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


begin
	-- Stimulus process to handle file I/O and write to RAM
	stimulus : process
    procedure write_to_mem(data : integer; addr : integer) is
    begin
      wr_en <= '1';
      wr_data <= std_ulogic_vector(to_unsigned(data, DATA_WIDTH));
      wr_addr <= std_ulogic_vector(to_unsigned(addr, ADDR_WIDTH));
      wait for 2*clk_period;
    end procedure;

    procedure read_from_mem(addr : integer) is
    begin
      wr_en <= '0';
      rd_addr <= std_ulogic_vector(to_unsigned(addr, ADDR_WIDTH));
      wait for 2*clk_period;
      report to_string(to_integer(unsigned(rd_data)));
    end procedure;

    procedure blockram_testcase is
    begin
      --write data "11" into addr=1
      --write_to_mem(data=>11,addr=>0);
      --write_to_mem(data=>11,addr=>1);

      --read data from addr=1 should be "11"
      read_from_mem(addr=>1);

      --write-through
      --write_to_mem(data=>121,addr=>1);
      assert unsigned(rd_data) = unsigned(wr_data) report to_string(to_integer(unsigned(rd_data)));

      --read from 0 should always be 0
      read_from_mem(addr=>0);
      assert 0 = to_integer(unsigned(rd_data)) report "read_from_mem(0) error not 0";
    end procedure;

    procedure blockram_testcase_file is
      variable L       : line;
      variable addr    : integer;
      variable data    : std_logic_vector(7 downto 0);
      variable dummy   : character;  -- to skip the ':'
    begin
      report "read data from file now ...";
      --READ from file and write it to the mem:
        while not endfile(input_file) loop
          readline(input_file, L); -- Read one line from the file

          --Line Format is: ADDRESS: BINARY_DATA
          read(L, addr);
          read(L, dummy);
          read(L, data);
          report "Address: " & to_string(addr) & " Data: " & to_string(data);

          --and write it to the mem
          write_to_mem(data=>to_integer(unsigned(data)),addr=>addr);
        end loop;

      --WRITE:
      --loop thrugh all possible addr and write out all values from the mem
      --save the values in a file called: debugdata_out.txt
      --Line Format should be:ADDRESS: BINARY_DATA

      std.env.stop;
    end procedure;

	begin
    report "start sim";
		res_n <= '0';
		wait for 10 ns;
    res_n <= '1';
		wait until rising_edge(clk);
    --blockram_testcase;
    blockram_testcase_file;

	  clk_stop <= '1';
    report "sim done";
    wait;
	end process;

	-- instantiate uut
  UUT : simple_dp_ram
  generic map(
    ADDR_WIDTH => ADDR_WIDTH,
    DATA_WIDTH => DATA_WIDTH
  )
  port map(
    clk   => clk,
    res_n => res_n,
    rd_addr => rd_addr,
    rd_data => rd_data,
    wr_en   => wr_en,
    wr_addr => wr_addr,
    wr_data => wr_data
  );

	-- Clock generation process
  clk_gen : process is
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
