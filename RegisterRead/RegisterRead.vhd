LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;

-- The DecodeStage File
ENTITY DecodeStage IS
  PORT (
    clk           : IN STD_LOGIC;
    wr_en         : IN STD_LOGIC_VECTOR(0 DOWNTO 0);
    wdt           : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
    sr1, sr2, dst : IN STD_LOGIC_VECTOR(2 DOWNTO 0);
    im_en, in_en  : IN STD_LOGIC_VECTOR(0 DOWNTO 0);
    imm, inn      : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
    op1, op2      : OUT STD_LOGIC_VECTOR(15 DOWNTO 0);
    rsr1          : OUT STD_LOGIC_VECTOR(15 DOWNTO 0)
  );
END ENTITY;

ARCHITECTURE DecodeStageArch OF DecodeStage IS
BEGIN
  rf : ENTITY work.RegisterFile PORT MAP(clk, wr_en, wdt, sr1, sr2, dst, rsr1, op2);
  WITH im_en & in_en SELECT
  op1 <=
    imm WHEN "10",
    inn WHEN "01",
    rsr1 WHEN OTHERS;
END ARCHITECTURE;