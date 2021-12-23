LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

ENTITY regist IS
  GENERIC (n : INTEGER := 32);
  PORT (
    clk, rst, en : IN STD_LOGIC;
    d            : IN STD_LOGIC_VECTOR (n - 1 DOWNTO 0);
    q            : OUT STD_LOGIC_VECTOR (n - 1 DOWNTO 0));
END ENTITY;

ARCHITECTURE regist_logic OF regist IS
BEGIN

  PROCESS (clk, rst)
  BEGIN
    IF (rst = '1') THEN
      q <= (OTHERS => '0');
    ELSIF (en = '1' AND rising_edge(clk)) THEN
      q <= d;
    END IF;
  END PROCESS;

END ARCHITECTURE;