LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.numeric_std.ALL;

ENTITY ALU IS
  PORT (
    func     : IN STD_LOGIC_VECTOR(2 DOWNTO 0);
    op1, op2 : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
    res      : OUT STD_LOGIC_VECTOR(15 DOWNTO 0);
    n, z, c  : OUT STD_LOGIC_VECTOR(0 DOWNTO 0)
  );
END ENTITY;

ARCHITECTURE ALUArch OF ALU IS
  SIGNAL one                        : STD_LOGIC_VECTOR(15 DOWNTO 0) := x"0001";
  SIGNAL mov_o, not_o, and_o, add_o : STD_LOGIC_VECTOR(16 DOWNTO 0);
  SIGNAL sub_o, inc_o, set_c, res_o : STD_LOGIC_VECTOR(16 DOWNTO 0);
BEGIN

  mov_o <= "0" & (op1);
  set_c <= "1" & (one);
  not_o <= "0" & (NOT op1);
  and_o <= "0" & (op1 AND op2);
  add_o <= STD_LOGIC_VECTOR(resize(UNSIGNED(op1) + UNSIGNED(op2), 17));
  sub_o <= STD_LOGIC_VECTOR(resize(UNSIGNED(op1) - UNSIGNED(op2), 17));
  inc_o <= STD_LOGIC_VECTOR(resize(UNSIGNED(op1) + UNSIGNED(one), 17));

  WITH func SELECT
  res_o <=
    set_c WHEN "001",
    not_o WHEN "010",
    and_o WHEN "011",
    add_o WHEN "100",
    sub_o WHEN "101",
    inc_o WHEN "110",
    mov_o WHEN OTHERS;

  res <= res_o(15 DOWNTO 0);

  z <=
    "1" WHEN res_o(15 DOWNTO 0) = x"0000"
    ELSE "0";

  n <= res_o(15 DOWNTO 15);

  c <= res_o(16 DOWNTO 16);

END ARCHITECTURE;