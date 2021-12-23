LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

ENTITY tristatebuf IS
  GENERIC (n : INTEGER := 32);
  PORT (
    en      : IN STD_LOGIC;
    in_buf  : IN STD_LOGIC_VECTOR (n - 1 DOWNTO 0);
    out_buf : OUT STD_LOGIC_VECTOR (n - 1 DOWNTO 0));
END ENTITY;

ARCHITECTURE tristatbuf_logic OF tristatebuf IS
BEGIN
  WITH en SELECT
    out_buf <= in_buf WHEN '1',
    (OTHERS => 'Z') WHEN OTHERS;
END ARCHITECTURE;