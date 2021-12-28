LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;

ENTITY WritebackStage IS
  PORT (
    clk      : IN STD_LOGIC;
    out_en   : IN STD_LOGIC_VECTOR(0 DOWNTO 0);
    wrt_data : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
    out_port : OUT STD_LOGIC_VECTOR(15 DOWNTO 0)
  );
END ENTITY;

ARCHITECTURE WritebackStageArch OF WritebackStage IS
BEGIN
  PROCESS (clk) IS
  BEGIN
    IF falling_edge(clk) AND out_en = "1" THEN
      out_port <= wrt_data;
    END IF;
  END PROCESS;
END ARCHITECTURE;
