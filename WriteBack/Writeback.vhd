LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;

ENTITY WritebackStage IS
  PORT (
    clk : IN STD_LOGIC;
    -- We don't actually have to include the wb & dst signals in here
    -- letting them pass through the WBStage kinda cleans the design and
    -- closes the feedback loop in a neater way.
    wb_in, out_en : IN STD_LOGIC_VECTOR(0 DOWNTO 0);
    dst_in        : IN STD_LOGIC_VECTOR(2 DOWNTO 0);
    wrt_data      : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
    wb_out        : OUT STD_LOGIC_VECTOR(0 DOWNTO 0);
    dst_out       : OUT STD_LOGIC_VECTOR(2 DOWNTO 0);
    out_port      : OUT STD_LOGIC_VECTOR(15 DOWNTO 0)
  );
END ENTITY;

ARCHITECTURE WritebackStageArch OF WritebackStage IS
BEGIN
  dst_out <= dst_in;
  wb_out  <= wb_in;
  PROCESS (clk) IS
  BEGIN
    IF falling_edge(clk) AND out_en = "1" THEN
      out_port <= wrt_data;
    END IF;
  END PROCESS;
END ARCHITECTURE;