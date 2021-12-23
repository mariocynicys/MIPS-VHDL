LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.numeric_std.ALL;
USE IEEE.math_real.ALL;

ENTITY Data_Memory IS
  PORT (
    Clk          : IN STD_LOGIC;
    Address      : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
    Write_Enable : IN STD_LOGIC;
    Read_Enable  : IN STD_LOGIC;
    DataIn       : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
    DataOut      : OUT STD_LOGIC_VECTOR(15 DOWNTO 0)
  );
END ENTITY Data_Memory;

ARCHITECTURE DataMemory OF Data_Memory IS
  TYPE ram_type IS ARRAY(0 TO 2 ** 20 - 1) OF STD_LOGIC_VECTOR(15 DOWNTO 0);
  SIGNAL ram : ram_type;
BEGIN
  PROCESS (Clk) IS
  BEGIN
    IF rising_edge(Clk) THEN
      IF Write_Enable = '1' THEN
        ram(to_integer(unsigned(Address))) <= DataIn;
      END IF;
    END IF;
  END PROCESS;
  DataOut <= ram(to_integer(unsigned(Address)));
END DataMemory;