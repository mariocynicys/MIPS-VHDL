LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.STD_LOGIC_UNSIGNED.ALL;
USE IEEE.numeric_std.ALL;
USE IEEE.math_real.ALL;

-- The Register File
ENTITY DecodeStage IS
  PORT (
    clk           : IN STD_LOGIC;
    wen           : IN STD_LOGIC;
    wdt           : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
    sr1, sr2, dst : IN STD_LOGIC_VECTOR(2 DOWNTO 0);
    rsr1, rsr2    : OUT STD_LOGIC_VECTOR(15 DOWNTO 0)
  );
END ENTITY;

ARCHITECTURE DecodeStageArch OF DecodeStage IS
  SIGNAL q0, q1, q2, q3, q4, q5, q6, q7 : STD_LOGIC_VECTOR(15 DOWNTO 0);
  SIGNAL e0, e1, e2, e3, e4, e5, e6, e7 : STD_LOGIC;
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

  e0 <= wen AND (NOT dst(0) AND NOT dst(1) AND NOT dst(2));
  r0 : ENTITY work.RegisterFileRegister PORT MAP (clk, e0, wdt, q0);

  e1 <= wen AND (NOT dst(0) AND NOT dst(1) AND dst(2));
  r1 : ENTITY work.RegisterFileRegister PORT MAP (clk, e1, wdt, q0);

  e2 <= wen AND (NOT dst(0) AND dst(1) AND NOT dst(2));
  r2 : ENTITY work.RegisterFileRegister PORT MAP (clk, e2, wdt, q0);

  e3 <= wen AND (NOT dst(0) AND dst(1) AND dst(2));
  r3 : ENTITY work.RegisterFileRegister PORT MAP (clk, e3, wdt, q0);

  e4 <= wen AND (dst(0) AND NOT dst(1) AND NOT dst(2));
  r4 : ENTITY work.RegisterFileRegister PORT MAP (clk, e4, wdt, q0);

  e5 <= wen AND (dst(0) AND NOT dst(1) AND dst(2));
  r5 : ENTITY work.RegisterFileRegister PORT MAP (clk, e5, wdt, q0);

  e6 <= wen AND (dst(0) AND dst(1) AND NOT dst(2));
  r6 : ENTITY work.RegisterFileRegister PORT MAP (clk, e6, wdt, q0);

  e7 <= wen AND (dst(0) AND dst(1) AND dst(2));
  r7 : ENTITY work.RegisterFileRegister PORT MAP (clk, e7, wdt, q0);
END ARCHITECTURE;