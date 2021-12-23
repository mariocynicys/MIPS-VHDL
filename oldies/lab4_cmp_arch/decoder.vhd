LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

ENTITY decoder IS
  PORT (
    en  : IN STD_LOGIC;
    sel : IN STD_LOGIC_VECTOR(1 DOWNTO 0);
    o   : OUT STD_LOGIC_VECTOR(3 DOWNTO 0));
END ENTITY;

ARCHITECTURE decoder_logic OF decoder IS
  -- A workaround to disable vcom's concatenation warning.
  SIGNAL conc : STD_LOGIC_VECTOR(2 DOWNTO 0);
BEGIN
  conc <= en & sel;

  WITH conc SELECT
  o <=
    "0001" WHEN "100",
    "0010" WHEN "101",
    "0100" WHEN "110",
    "1000" WHEN "111",
    "0000" WHEN OTHERS;

END ARCHITECTURE;