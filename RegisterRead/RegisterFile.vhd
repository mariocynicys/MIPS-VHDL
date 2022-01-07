LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;

-- The Register File
ENTITY RegisterFile IS
  PORT (
    clk           : IN STD_LOGIC;
    wen           : IN STD_LOGIC_VECTOR(0 DOWNTO 0);
    wdt           : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
    sr1, sr2, dst : IN STD_LOGIC_VECTOR(2 DOWNTO 0);
    rsr1, rsr2    : OUT STD_LOGIC_VECTOR(15 DOWNTO 0)
  );
END ENTITY;

ARCHITECTURE RegisterFileArch OF RegisterFile IS
  SIGNAL q0, q1, q2, q3, q4, q5, q6, q7 : STD_LOGIC_VECTOR(15 DOWNTO 0);
  SIGNAL wen_bool                       : BOOLEAN;
BEGIN

  WITH sr1 SELECT
    rsr1 <=
    q1 WHEN "001",
    q2 WHEN "010",
    q3 WHEN "011",
    q4 WHEN "100",
    q5 WHEN "101",
    q6 WHEN "110",
    q7 WHEN "111",
    q0 WHEN OTHERS;

  WITH sr2 SELECT
    rsr2 <=
    q1 WHEN "001",
    q2 WHEN "010",
    q3 WHEN "011",
    q4 WHEN "100",
    q5 WHEN "101",
    q6 WHEN "110",
    q7 WHEN "111",
    q0 WHEN OTHERS;

  WITH wen SELECT
    wen_bool <= true WHEN "1",
    false WHEN OTHERS;

  r0 : ENTITY work.RegisterFileRegister PORT MAP (clk, wen_bool AND (dst = "000"), wdt, q0);
  r1 : ENTITY work.RegisterFileRegister PORT MAP (clk, wen_bool AND (dst = "001"), wdt, q1);
  r2 : ENTITY work.RegisterFileRegister PORT MAP (clk, wen_bool AND (dst = "010"), wdt, q2);
  r3 : ENTITY work.RegisterFileRegister PORT MAP (clk, wen_bool AND (dst = "011"), wdt, q3);
  r4 : ENTITY work.RegisterFileRegister PORT MAP (clk, wen_bool AND (dst = "100"), wdt, q4);
  r5 : ENTITY work.RegisterFileRegister PORT MAP (clk, wen_bool AND (dst = "101"), wdt, q5);
  r6 : ENTITY work.RegisterFileRegister PORT MAP (clk, wen_bool AND (dst = "110"), wdt, q6);
  r7 : ENTITY work.RegisterFileRegister PORT MAP (clk, wen_bool AND (dst = "111"), wdt, q7);
END ARCHITECTURE;
