
LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;

ENTITY buf_mem IS
  PORT (
    clk, fsh    : IN STD_LOGIC;
    out_in      : IN STD_LOGIC_VECTOR(0 DOWNTO 0);
    out_out     : OUT STD_LOGIC_VECTOR(0 DOWNTO 0);
    wb_in       : IN STD_LOGIC_VECTOR(0 DOWNTO 0);
    wb_out      : OUT STD_LOGIC_VECTOR(0 DOWNTO 0);
    wr_data_in  : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
    wr_data_out : OUT STD_LOGIC_VECTOR(15 DOWNTO 0);
    wr_addr_in  : IN STD_LOGIC_VECTOR(2 DOWNTO 0);
    wr_addr_out : OUT STD_LOGIC_VECTOR(2 DOWNTO 0)
  );
END ENTITY;

ARCHITECTURE buf_mem_arc OF buf_mem IS
BEGIN
  PROCESS (clk)
  BEGIN
    IF rising_edge(clk) THEN
      out_out     <= out_in;
      wb_out      <= wb_in;
      wr_data_out <= wr_data_in;
      wr_addr_out <= wr_addr_in;
      IF fsh = '1' THEN
        out_out     <= "0";
        wb_out      <= "0";
        wr_data_out <= "0000000000000000";
        wr_addr_out <= "000";
      END IF;
    END IF;
  END PROCESS;
END ARCHITECTURE;