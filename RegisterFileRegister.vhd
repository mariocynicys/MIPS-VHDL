LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

ENTITY RegisterFileRegister IS
  PORT (
    clk, wen : IN STD_LOGIC;
    d        : IN STD_LOGIC_VECTOR (15 DOWNTO 0);
    q        : OUT STD_LOGIC_VECTOR (15 DOWNTO 0));
END ENTITY;

ARCHITECTURE RegisterFileRegisterArch OF RegisterFileRegister IS
BEGIN
  PROCESS (clk)
  BEGIN
    -- This regsiter component is used in the regsiter file in the decode stage.
    -- The WB data is written at the falling edge of the clock.
    IF (wen = '1' AND falling_edge(clk)) THEN
      q <= d;
    END IF;
  END PROCESS;
END ARCHITECTURE;