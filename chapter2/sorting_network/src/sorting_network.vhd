library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

use work.sorting_network_pkg.all;

entity sorting_network is
	generic (
		DATA_WIDTH : natural := 32
	);
	port (
		clk      : in std_logic;
		res_n    : in std_logic;

		unsorted_data : in  std_ulogic_vector;
		sorted_data   : out std_ulogic_vector;

		start : in std_ulogic;
		done  : out std_ulogic
	);
end entity;

architecture beh of sorting_network is
  signal data_line1 : std_ulogic_vector(DATA_WIDTH-1 downto 0);
  signal data_line2 : std_ulogic_vector(DATA_WIDTH-1 downto 0);
  signal data_line3 : std_ulogic_vector(DATA_WIDTH-1 downto 0);
  signal data_line4 : std_ulogic_vector(DATA_WIDTH-1 downto 0);

  signal data_line1_stage1 : std_ulogic_vector(DATA_WIDTH-1 downto 0);
  signal data_line2_stage1 : std_ulogic_vector(DATA_WIDTH-1 downto 0);
  signal data_line3_stage1 : std_ulogic_vector(DATA_WIDTH-1 downto 0);
  signal data_line4_stage1 : std_ulogic_vector(DATA_WIDTH-1 downto 0);

  signal data_line1_stage2 : std_ulogic_vector(DATA_WIDTH-1 downto 0);
  signal data_line2_stage2 : std_ulogic_vector(DATA_WIDTH-1 downto 0);
  signal data_line3_stage2 : std_ulogic_vector(DATA_WIDTH-1 downto 0);
  signal data_line4_stage2 : std_ulogic_vector(DATA_WIDTH-1 downto 0);

  signal data_line1_stage3 : std_ulogic_vector(DATA_WIDTH-1 downto 0);
  signal data_line2_stage3 : std_ulogic_vector(DATA_WIDTH-1 downto 0);
  signal data_line3_stage3 : std_ulogic_vector(DATA_WIDTH-1 downto 0);
  signal data_line4_stage3 : std_ulogic_vector(DATA_WIDTH-1 downto 0);

begin
  sync : process(clk, res_n) is
  begin
    if res_n = '0' then
      data_line1 <= (others=>'0');
      data_line2 <= (others=>'0');
      data_line3 <= (others=>'0');
      data_line4 <= (others=>'0');
      --stage 1 (3 stages = 3 layers)
      data_line1_stage1 <= (others=>'0');
      data_line2_stage1 <= (others=>'0');
      data_line3_stage1 <= (others=>'0');
      data_line4_stage1 <= (others=>'0');
      --stage 2
      data_line1_stage2 <= (others=>'0');
      data_line2_stage2 <= (others=>'0');
      data_line3_stage2 <= (others=>'0');
      data_line4_stage2 <= (others=>'0');
      --stage 3
      data_line1_stage3 <= (others=>'0');
      data_line2_stage3 <= (others=>'0');
      data_line3_stage3 <= (others=>'0');
      data_line4_stage3 <= (others=>'0');

    elsif rising_edge(clk) then
      --sample data
      if start = '1' then
        data_line1 <= unsorted_data(DATA_WIDTH-1 downto 0);
        data_line2 <= unsorted_data(DATA_WIDTH*2-1 downto DATA_WIDTH);
        data_line3 <= unsorted_data(DATA_WIDTH*3-1 downto DATA_WIDTH*2);
        data_line4 <= unsorted_data(DATA_WIDTH*4-1 downto DATA_WIDTH*3);

        --implemented sorting networK: Sorting network for 4 inputs, 5 CEs, 3 layers:
        --input lines 1,2,3,4
          --stage1 compare
          --[(1,3),(2,4)]
          --stage2 compare
          --[(1,2),(3,4)]
          --stage3 compare
          --[(2,3)]

        --stage1: compare 1 with 3 and 2 with 4
        if unsigned(data_line1) > unsigned(data_line3) then
          --swap data
          data_line1_stage1 <= data_line3;
          data_line3_stage1 <= data_line1;
        else
          data_line1_stage1 <= data_line1;
          data_line3_stage1 <= data_line3;
        end if;

        if unsigned(data_line2) > unsigned(data_line4) then
          --swap data
          data_line2_stage1 <= data_line4;
          data_line4_stage1 <= data_line2;
        else
          data_line2_stage1 <= data_line2;
          data_line4_stage1 <= data_line4;
        end if;
      end if;

        --stage2: compare 1 with 2 and 3 with 4
        if unsigned(data_line1_stage1) > unsigned(data_line2_stage1) then
          --swap data
          data_line1_stage2 <= data_line2_stage1;
          data_line2_stage2 <= data_line1_stage1;
        else
          data_line1_stage2 <= data_line1_stage1;
          data_line2_stage2 <= data_line2_stage1;
        end if;

        if unsigned(data_line3_stage1) > unsigned(data_line4_stage1) then
          --swap data
          data_line3_stage2 <= data_line4_stage1;
          data_line4_stage2 <= data_line3_stage1;
        else
          data_line3_stage2 <= data_line3_stage1;
          data_line4_stage2 <= data_line4_stage1;
        end if;

        --stage3: compare 2 with 3
        if unsigned(data_line2_stage2) > unsigned(data_line3_stage2) then
          --swap data
          data_line2_stage3 <= data_line3_stage2;
          data_line3_stage3 <= data_line2_stage2;
        else
          data_line2_stage3 <= data_line2_stage2;
          data_line3_stage3 <= data_line3_stage2;
        end if;

          data_line1_stage3 <= data_line1_stage2;
          data_line4_stage3 <= data_line4_stage2;

        --output data
        sorted_data(DATA_WIDTH-1 downto 0) <= data_line1_stage3;
        sorted_data(DATA_WIDTH*2-1 downto DATA_WIDTH) <= data_line2_stage3;
        sorted_data(DATA_WIDTH*3-1 downto DATA_WIDTH*2) <= data_line3_stage3;
        sorted_data(DATA_WIDTH*4-1 downto DATA_WIDTH*3) <= data_line4_stage3;
    end if;
  end process;
end architecture;
