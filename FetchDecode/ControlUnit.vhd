LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.numeric_std.ALL;
USE IEEE.math_real.ALL;

ENTITY ControlUnit IS
  PORT (
    operation          : IN STD_LOGIC_VECTOR(6 DOWNTO 0);
    func               : OUT STD_LOGIC_VECTOR(2 DOWNTO 0);
    wb                 : OUT STD_LOGIC_VECTOR(0 DOWNTO 0);
    inn                : OUT STD_LOGIC_VECTOR(0 DOWNTO 0);
    outt               : OUT STD_LOGIC_VECTOR(0 DOWNTO 0);
    imm                : OUT STD_LOGIC_VECTOR(0 DOWNTO 0);
    alu                : OUT STD_LOGIC_VECTOR(0 DOWNTO 0);
    mr                 : OUT STD_LOGIC_VECTOR(0 DOWNTO 0);
    mw                 : OUT STD_LOGIC_VECTOR(0 DOWNTO 0);
    ps_pp              : OUT STD_LOGIC_VECTOR(0 DOWNTO 0);
    brnch              : OUT STD_LOGIC_VECTOR(0 DOWNTO 0);
    int_cal            : OUT STD_LOGIC_VECTOR(0 DOWNTO 0);
    sr1_used, sr2_used : OUT STD_LOGIC_VECTOR(0 DOWNTO 0)
  );
END ENTITY;

ARCHITECTURE ControlUnitArch OF ControlUnit IS
  SIGNAL oper : STD_LOGIC_VECTOR(3 DOWNTO 0);
  SIGNAL call : STD_LOGIC_VECTOR(3 DOWNTO 0);

  -------------------------------------------------------------
  -- class codes:
  CONSTANT in_op      : STD_LOGIC_VECTOR(3 DOWNTO 0) := "0100";
  CONSTANT out_op     : STD_LOGIC_VECTOR(3 DOWNTO 0) := "0011";
  CONSTANT alu_op     : STD_LOGIC_VECTOR(3 DOWNTO 0) := "0010";
  CONSTANT iadd_op    : STD_LOGIC_VECTOR(3 DOWNTO 0) := "1100";
  CONSTANT push_op    : STD_LOGIC_VECTOR(3 DOWNTO 0) := "0101";
  CONSTANT pop_op     : STD_LOGIC_VECTOR(3 DOWNTO 0) := "0110";
  CONSTANT int_cal_op : STD_LOGIC_VECTOR(3 DOWNTO 0) := "1010";
  CONSTANT rti_ret_op : STD_LOGIC_VECTOR(3 DOWNTO 0) := "1011";
  CONSTANT ldm_op     : STD_LOGIC_VECTOR(3 DOWNTO 0) := "1101";
  CONSTANT ldd_op     : STD_LOGIC_VECTOR(3 DOWNTO 0) := "1110";
  CONSTANT std_op     : STD_LOGIC_VECTOR(3 DOWNTO 0) := "1111";
  CONSTANT jmp_op     : STD_LOGIC_VECTOR(3 DOWNTO 0) := "0111";
  CONSTANT mov_op     : STD_LOGIC_VECTOR(3 DOWNTO 0) := "1000";
  -------------------------------------------------------------
  -- func codes:
  CONSTANT cal_func : STD_LOGIC_VECTOR(2 DOWNTO 0) := "001";
  CONSTANT and_func : STD_LOGIC_VECTOR(2 DOWNTO 0) := "011";
  CONSTANT add_func : STD_LOGIC_VECTOR(2 DOWNTO 0) := "100";
  CONSTANT sub_func : STD_LOGIC_VECTOR(2 DOWNTO 0) := "101";
  -------------------------------------------------------------
BEGIN

  oper <= operation(6 DOWNTO 3);
  func <= operation(2 DOWNTO 0);

  WITH oper SELECT
    imm <=
    "1" WHEN iadd_op,
    "1" WHEN ldm_op,
    "1" WHEN ldd_op,
    "1" WHEN std_op,
    "0" WHEN OTHERS;

  WITH oper SELECT
    inn <=
    "1" WHEN in_op,
    "0" WHEN OTHERS;

  WITH oper SELECT
    outt <=
    "1" WHEN out_op,
    "0" WHEN OTHERS;

  WITH oper SELECT
    alu <=
    "1" WHEN alu_op,
    "1" WHEN iadd_op,
    "0" WHEN OTHERS;

  WITH oper SELECT
    ps_pp <=
    "1" WHEN push_op,
    "1" WHEN pop_op,
    "1" WHEN int_cal_op,
    "1" WHEN rti_ret_op,
    "0" WHEN OTHERS;

  WITH oper SELECT
    wb <=
    "1" WHEN mov_op,
    "1" WHEN alu_op,
    "1" WHEN iadd_op,
    "1" WHEN in_op,
    "1" WHEN pop_op,
    "1" WHEN ldm_op,
    "1" WHEN ldd_op,
    "0" WHEN OTHERS;

  WITH oper SELECT
    brnch <=
    "1" WHEN jmp_op,
    "0" WHEN OTHERS;

  WITH oper SELECT
    int_cal <=
    "1" WHEN int_cal_op,
    "1" WHEN rti_ret_op,
    "0" WHEN OTHERS;

  WITH oper SELECT
    mr <=
    "1" WHEN pop_op,
    "1" WHEN ldd_op,
    "1" WHEN rti_ret_op,
    "0" WHEN OTHERS;

  WITH oper SELECT
    mw <=
    "1" WHEN push_op,
    "1" WHEN std_op,
    "1" WHEN int_cal_op,
    "0" WHEN OTHERS;

  sr1_used <=
    "1" WHEN oper = alu_op ELSE
    "1" WHEN oper = out_op ELSE
    "1" WHEN oper = push_op ELSE
    "1" WHEN oper = ldd_op ELSE
    "1" WHEN oper = std_op ELSE
    "1" WHEN oper = jmp_op ELSE
    "1" WHEN oper = int_cal_op AND func = cal_func ELSE
    "0";

  sr2_used <=
    "1" WHEN oper = alu_op AND func = and_func ELSE
    "1" WHEN oper = alu_op AND func = add_func ELSE
    "1" WHEN oper = alu_op AND func = sub_func ELSE
    "1" WHEN oper = iadd_op ELSE
    "1" WHEN oper = ldd_op ELSE
    "1" WHEN oper = std_op ELSE
    "0";

END ARCHITECTURE;