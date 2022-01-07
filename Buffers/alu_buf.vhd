LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;

ENTITY alu_buf IS
  PORT (
    clk : IN STD_LOGIC;
    fsh : IN STD_LOGIC_VECTOR(0 DOWNTO 0);

    rst_in      : IN STD_LOGIC_VECTOR(0 DOWNTO 0);
    rst_out     : OUT STD_LOGIC_VECTOR(0 DOWNTO 0)
  );
END ENTITY;

ARCHITECTURE alu_buf_arc OF alu_buf IS
BEGIN
  PROCESS (clk)
  BEGIN
    IF rising_edge(clk) THEN
      IF fsh = "1" or rst_out = "1" THEN

        rst_out <= "0";
      ELSE

        rst_out <= rst_in;
      END IF;
    END IF;
  END PROCESS;
END ARCHITECTURE;
