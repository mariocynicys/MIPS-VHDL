LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.numeric_std.ALL;
USE IEEE.math_real.ALL;

ENTITY Mux_2x1 IS
  PORT (
    Input1 : IN STD_LOGIC;
    Input2 : IN STD_LOGIC;
    Sel    : IN STD_LOGIC;
    Output : OUT STD_LOGIC
  );
END ENTITY Mux_2x1;

ARCHITECTURE Mux2x1 OF Mux_2x1 IS
BEGIN
  WITH Sel SELECT
    Output <=
    Input1 WHEN '0',
    Input2 WHEN '1',
    '0' WHEN OTHERS;

END Mux2x1;