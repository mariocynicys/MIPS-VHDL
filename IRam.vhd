LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.numeric_std.ALL;
USE IEEE.math_real.ALL;

ENTITY IRam IS
  PORT (
    clk         : IN STD_LOGIC;
    pc          : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
    instruction : OUT STD_LOGIC_VECTOR(31 DOWNTO 0));
END ENTITY;

ARCHITECTURE IRamArch OF IRam IS
  TYPE ram_type IS ARRAY(0 TO 2 ** 20 - 1) OF STD_LOGIC_VECTOR(15 DOWNTO 0);
  SIGNAL ram : ram_type;

BEGIN
  PROCESS (clk) IS
  BEGIN
    IF rising_edge(clk) THEN
      instruction(15 DOWNTO 0)  <= ram(to_integer(unsigned(pc)));
      instruction(31 DOWNTO 16) <= ram(to_integer(unsigned(pc) + 1));
    END IF;
  END PROCESS;
END ARCHITECTURE;