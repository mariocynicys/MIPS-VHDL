LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

ENTITY RegisterFileRegister IS
  PORT (
    clk : IN STD_LOGIC;
    wen : IN BOOLEAN;
    d   : IN STD_LOGIC_VECTOR (15 DOWNTO 0)  := x"0000";
    q   : OUT STD_LOGIC_VECTOR (15 DOWNTO 0) := x"0000"
  );
END ENTITY;

ARCHITECTURE RegisterFileRegisterArch OF RegisterFileRegister IS
BEGIN
  PROCESS (clk)
  BEGIN
    IF (wen = true AND falling_edge(clk)) THEN
      q <= d;
    END IF;
  END PROCESS;
END ARCHITECTURE;