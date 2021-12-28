LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;

ENTITY MIPS IS
  PORT (
    in_port  : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
    reset    : IN STD_LOGIC;
    out_port : OUT STD_LOGIC_VECTOR(15 DOWNTO 0)
  );
END ENTITY;

ARCHITECTURE MIPSArch OF MIPS IS
  CONSTANT clk_prd : TIME      := 100 ps;
  SIGNAL clk       : STD_LOGIC := '0';
BEGIN
  -- Update the clk.
  clk <= NOT clk AFTER clk_prd / 2;

  --fetch: entity work.fetch
END ARCHITECTURE;
