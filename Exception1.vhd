LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.numeric_std.ALL;
USE IEEE.math_real.ALL;

ENTITY Exception1_Unit IS
  PORT (
    PC_IN  : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
    Clk    : IN STD_LOGIC;
    PC_Out : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
    IsExp  : OUT STD_LOGIC -- it might be used to make the entity that will change the pc with the Exp handler address Start
  );
END ENTITY Exception1_Unit;

ARCHITECTURE Exception1 OF Exception1_Unit IS
BEGIN
  PROCESS (Clk) IS
  BEGIN
    IF rising_edge(Clk) THEN
      IF to_integer(unsigned(PC_IN)) > 255 THEN -- ff = 255
        IsExp  <= '1';
        PC_Out <= STD_LOGIC_VECTOR(to_unsigned(2, 32)); -- 2 is the address of the Exception handler 
      ELSE
        IsExp  <= '0';
        PC_Out <= PC_IN;
      END IF;
    END IF;
  END PROCESS;

END Exception1;