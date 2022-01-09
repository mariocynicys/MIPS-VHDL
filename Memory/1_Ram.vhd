LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.numeric_std.ALL;
USE IEEE.math_real.ALL;

ENTITY Ram IS
  PORT (
    clk : IN STD_LOGIC;
    adr : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
    -- dbl_op = we will use m(r/w)_adr1 for reading/writing.
    mw, dbl_op       : IN STD_LOGIC_VECTOR(0 DOWNTO 0);
    mw_adr0, mw_adr1 : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
    mr_adr0, mr_adr1 : OUT STD_LOGIC_VECTOR(15 DOWNTO 0)
  );
END ENTITY;

ARCHITECTURE RamArch OF Ram IS
  TYPE ram_type IS ARRAY(0 TO 2 ** 20 - 1) OF STD_LOGIC_VECTOR(15 DOWNTO 0);
  SIGNAL inner_ram : ram_type;
  SIGNAL addr      : INTEGER := 0;
BEGIN
  addr <= to_integer(unsigned(adr(19 DOWNTO 0)));
  PROCESS (clk) IS
  BEGIN
    IF falling_edge(clk) AND mw = "1" THEN
      inner_ram(to_integer(to_unsigned(addr, 20))) <= mw_adr0;
      IF dbl_op = "1" THEN
        inner_ram(to_integer(to_unsigned(addr - 1, 20))) <= mw_adr1;
      END IF;
    END IF;
  END PROCESS;
  -- Having the reading outside the process makes the data read ready by
  -- the falling edge of this cycle, thus can be used by other processes
  -- in the alu(flags) and the fetch(new pc).
  mr_adr0 <= inner_ram(to_integer(to_unsigned(addr, 20)));
  WITH dbl_op SELECT
    mr_adr1 <=
    inner_ram(to_integer(to_unsigned(addr + 1, 20))) WHEN "1",
    "0000000000000000" WHEN OTHERS;
END ARCHITECTURE;