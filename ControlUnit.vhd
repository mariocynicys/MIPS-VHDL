LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.numeric_std.ALL;
USE IEEE.math_real.ALL;

ENTITY ControlUnit IS
  PORT (
    operation : IN STD_LOGIC_VECTOR(6 DOWNTO 0);
    func      : OUT STD_LOGIC_VECTOR(2 DOWNTO 0);
    wb        : OUT STD_LOGIC_VECTOR(0 DOWNTO 0);
    inn       : OUT STD_LOGIC_VECTOR(0 DOWNTO 0);
    outt      : OUT STD_LOGIC_VECTOR(0 DOWNTO 0);
    imm       : OUT STD_LOGIC_VECTOR(0 DOWNTO 0);
    alu       : OUT STD_LOGIC_VECTOR(0 DOWNTO 0);
    mr        : OUT STD_LOGIC_VECTOR(0 DOWNTO 0);
    mw        : OUT STD_LOGIC_VECTOR(0 DOWNTO 0);
    ps_pp     : OUT STD_LOGIC_VECTOR(0 DOWNTO 0);
    brnch     : OUT STD_LOGIC_VECTOR(0 DOWNTO 0);
    int_cal   : OUT STD_LOGIC_VECTOR(0 DOWNTO 0)
  );
END ENTITY;

ARCHITECTURE ControlUnitArch OF ControlUnit IS
  SIGNAL oper : STD_LOGIC_VECTOR(3 DOWNTO 0);
BEGIN

  func <= operation(2 DOWNTO 0);
  oper <= operation(6 DOWNTO 3);

  WITH oper(3 DOWNTO 2) SELECT
  imm <=
    "1" WHEN "11", -- imm instructions take the format "11xx"
    "0" WHEN OTHERS;

  WITH oper SELECT
    inn <=
    "1" WHEN "0100", -- in
    "0" WHEN OTHERS;

  WITH oper SELECT
    outt <=
    "1" WHEN "0011", -- out
    "0" WHEN OTHERS;

  WITH oper SELECT
    alu <=
    "1" WHEN "0010", -- basic alu instructions
    "1" WHEN "1100", -- iadd
    "0" WHEN OTHERS;

  WITH oper SELECT
    ps_pp <=
    "1" WHEN "0101", -- push
    "1" WHEN "0110", -- pop
    "1" WHEN "1010", -- int/cal
    "1" WHEN "1011", -- rti/ret
    "0" WHEN OTHERS;

  WITH oper SELECT
    wb <=
    "1" WHEN "0010", -- basic alu instructions
    "1" WHEN "1100", -- iadd
    "1" WHEN "0100", -- in
    "1" WHEN "0110", -- pop
    "1" WHEN "1101", -- ldm
    "1" WHEN "1110", -- ldd
    "0" WHEN OTHERS;

  WITH oper SELECT
    brnch <=
    "1" WHEN "0111", -- jumps
    "0" WHEN OTHERS;

  WITH oper SELECT
    int_cal <=
    "1" WHEN "1010", -- int/cal
    "1" WHEN "1011", -- rti/ret
    "0" WHEN OTHERS;

  WITH oper SELECT
    mr <=
    "1" WHEN "0110", -- pop
    "1" WHEN "1110", -- ldd
    "1" WHEN "1011", -- rti/ret
    "0" WHEN OTHERS;

  WITH oper SELECT
    mr <=
    "1" WHEN "0101", -- push
    "1" WHEN "1111", -- std
    "1" WHEN "1010", -- int/call
    "0" WHEN OTHERS;

END ARCHITECTURE;
