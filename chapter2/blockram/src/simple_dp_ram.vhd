library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity simple_dp_ram is
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
end entity;

architecture beh of simple_dp_ram is
  type MEM is array(0 to 2**ADDR_WIDTH-1) of std_ulogic_vector(DATA_WIDTH-1 downto 0);
begin
  sync : process(clk) is
    variable ram_block : MEM;
  begin
    if rising_edge(clk) then
      if wr_en = '1' then
          ram_block(to_integer(unsigned(wr_addr))) := wr_data;
      end if;

      if wr_en = '1' and unsigned(wr_addr)=unsigned(rd_addr) then
        --write-through
        rd_data <= wr_data;
      else
        if to_integer(unsigned(rd_addr)) = 0 then
          rd_data <= (others=>'0');
        else
          rd_data <= ram_block(to_integer(unsigned(rd_addr)));
        end if;
      end if;
    end if;
  end process;
end architecture;

architecture beh_reset of simple_dp_ram is
  type MEM is array(0 to 2**ADDR_WIDTH-1) of std_ulogic_vector(DATA_WIDTH-1 downto 0);
begin
  sync : process(clk) is
    variable ram_block : MEM;
  begin
    if rising_edge(clk) then
      if wr_en = '1' then
          ram_block(to_integer(unsigned(wr_addr))) := wr_data;
      end if;

      if wr_en = '1' and unsigned(wr_addr)=unsigned(rd_addr) then
        --write-through
        rd_data <= wr_data;
      else
        if to_integer(unsigned(rd_addr)) = 0 then
          rd_data <= (others=>'0');
        else
          rd_data <= ram_block(to_integer(unsigned(rd_addr)));
        end if;
      end if;
    end if;
  end process;
end architecture;
