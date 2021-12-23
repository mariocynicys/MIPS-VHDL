LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.numeric_std.ALL;

ENTITY ram IS
  GENERIC (
    word_siz : INTEGER := 8;
    adrs_siz : INTEGER := 6);
  PORT (
    clk     : IN STD_LOGIC;
    we      : IN STD_LOGIC;
    address : IN STD_LOGIC_VECTOR(adrs_siz - 1 DOWNTO 0);
    datain  : IN STD_LOGIC_VECTOR(word_siz - 1 DOWNTO 0);
    dataout : OUT STD_LOGIC_VECTOR(word_siz - 1 DOWNTO 0));
END ENTITY ram;

ARCHITECTURE syncrama OF ram IS

  TYPE ram_type IS ARRAY(0 TO adrs_siz ** 2 - 1) OF STD_LOGIC_VECTOR(word_siz - 1 DOWNTO 0);
  SIGNAL ram : ram_type;

BEGIN
  PROCESS (clk) IS
  BEGIN
    IF rising_edge(clk) THEN
      IF we = '1' THEN
        ram(to_integer(unsigned(address))) <= datain;
      END IF;
    END IF;
  END PROCESS;
  dataout <= ram(to_integer(unsigned(address)));
END syncrama;