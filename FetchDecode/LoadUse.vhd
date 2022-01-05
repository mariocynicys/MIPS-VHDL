LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.numeric_std.ALL;
USE IEEE.math_real.ALL;

ENTITY LoadUse IS
  PORT (
    clk      : IN STD_LOGIC;
    new_mr   : IN STD_LOGIC_VECTOR(0 DOWNTO 0);
    new_wb   : IN STD_LOGIC_VECTOR(0 DOWNTO 0);
    new_dst  : IN STD_LOGIC_VECTOR(2 DOWNTO 0);
    sr1_used : IN STD_LOGIC_VECTOR(0 DOWNTO 0);
    new_sr1  : IN STD_LOGIC_VECTOR(2 DOWNTO 0);
    sr2_used : IN STD_LOGIC_VECTOR(0 DOWNTO 0);
    new_sr2  : IN STD_LOGIC_VECTOR(2 DOWNTO 0);
    ld_use   : OUT STD_LOGIC_VECTOR(0 DOWNTO 0)
  );
END ENTITY;

ARCHITECTURE LoadUseArch OF LoadUse IS
  SIGNAL old_dst   : STD_LOGIC_VECTOR(2 DOWNTO 0);
  SIGNAL old_mr_wb : STD_LOGIC_VECTOR(0 DOWNTO 0);
BEGIN

  PROCESS (clk)
  BEGIN
    IF rising_edge(clk) THEN
      old_dst   <= new_dst;
      old_mr_wb <= new_mr AND new_wb;
    END IF;
  END PROCESS;

  ld_use <=
    "1" WHEN old_mr_wb = "1" AND sr1_used = "1" AND new_sr1 = old_dst ELSE
    "1" WHEN old_mr_wb = "1" AND sr2_used = "1" AND new_sr2 = old_dst ELSE
    "0";
END ARCHITECTURE;
