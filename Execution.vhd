LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.numeric_std.ALL;

ENTITY ExecuteStage IS
  PORT (
    clk      : IN STD_LOGIC;
    alu_en   : IN STD_LOGIC_VECTOR(0 DOWNTO 0);
    func     : IN STD_LOGIC_VECTOR(2 DOWNTO 0);
    op1, op2 : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
    res      : OUT STD_LOGIC_VECTOR(15 DOWNTO 0)
  );
END ENTITY;

ARCHITECTURE ExecuteStageArch OF ExecuteStage IS
  SIGNAL one                        : STD_LOGIC_VECTOR(15 DOWNTO 0) := x"0001";
  SIGNAL mov_o, not_o, and_o, add_o : STD_LOGIC_VECTOR(16 DOWNTO 0);
  SIGNAL sub_o, inc_o, set_c, res_o : STD_LOGIC_VECTOR(16 DOWNTO 0);
BEGIN

  -- alu: entity work.ALU port map()

END ARCHITECTURE;