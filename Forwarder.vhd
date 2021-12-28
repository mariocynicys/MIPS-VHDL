LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;

ENTITY Forwarder IS
  PORT (
    clk        : IN STD_LOGIC;
    sr1, sr2   : IN STD_LOGIC_VECTOR(2 DOWNTO 0);
    wb_alu     : IN STD_LOGIC_VECTOR(0 DOWNTO 0);
    dst_alu    : IN STD_LOGIC_VECTOR(2 DOWNTO 0);
    wb_mem     : IN STD_LOGIC_VECTOR(0 DOWNTO 0);
    dst_mem    : IN STD_LOGIC_VECTOR(2 DOWNTO 0);
    fsr1, fsr2 : OUT STD_LOGIC_VECTOR(1 DOWNTO 0)
  );
END ENTITY;

ARCHITECTURE ForwarderArch OF Forwarder IS
BEGIN
  fsr1 <=
    "01" WHEN wb_alu = "1" AND sr1 = dst_alu ELSE
    "10" WHEN wb_mem = "1" AND sr1 = dst_mem ELSE
    "00";
  fsr2 <=
    "01" WHEN wb_alu = "1" AND sr2 = dst_alu ELSE
    "10" WHEN wb_mem = "1" AND sr2 = dst_mem ELSE
    "00";
END ARCHITECTURE;
