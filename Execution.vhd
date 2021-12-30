LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;

ENTITY ExecuteStage IS
  PORT (
    clk                : IN STD_LOGIC;
    alu_en             : IN STD_LOGIC_VECTOR(0 DOWNTO 0);
    branch             : IN STD_LOGIC_VECTOR(0 DOWNTO 0);
    intcal             : IN STD_LOGIC_VECTOR(0 DOWNTO 0);
    in_imm             : IN STD_LOGIC_VECTOR(0 DOWNTO 0);
    func               : IN STD_LOGIC_VECTOR(2 DOWNTO 0);
    sr1, sr2           : IN STD_LOGIC_VECTOR(2 DOWNTO 0);
    op1, op2, rsr1     : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
    res                : OUT STD_LOGIC_VECTOR(15 DOWNTO 0);
    flgs               : OUT STD_LOGIC_VECTOR(2 DOWNTO 0);
    frsr1              : OUT STD_LOGIC_VECTOR(15 DOWNTO 0);
    dst_alu, dst_mem   : IN STD_LOGIC_VECTOR(2 DOWNTO 0);
    wb_alu, wb_mem     : IN STD_LOGIC_VECTOR(0 DOWNTO 0);
    rsrc_alu, rsrc_mem : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
    mem_flgs_en        : IN STD_LOGIC_VECTOR(0 DOWNTO 0);
    mem_flgs           : IN STD_LOGIC_VECTOR(2 DOWNTO 0);
    new_pc_en          : OUT STD_LOGIC_VECTOR(0 DOWNTO 0);
    new_pc             : OUT STD_LOGIC_VECTOR(31 DOWNTO 0)
  );
END ENTITY;

ARCHITECTURE ExecuteStageArch OF ExecuteStage IS
  SIGNAL alu_op1, alu_op2 : STD_LOGIC_VECTOR(15 DOWNTO 0);
  SIGNAL n, z, c          : STD_LOGIC_VECTOR(0 DOWNTO 0);
  SIGNAL fsr1, fsr2       : STD_LOGIC_VECTOR(1 DOWNTO 0);
  SIGNAL is_jmp, is_cal   : STD_LOGIC_VECTOR(0 DOWNTO 0);
  SIGNAL flgs_and_func    : STD_LOGIC_VECTOR(2 DOWNTO 0);
BEGIN

  alu : ENTITY work.ALU PORT MAP(func, alu_op1, alu_op2, res);
  frw : ENTITY work.Forwarder PORT MAP(sr1, sr2, wb_alu, dst_alu, wb_mem, dst_mem, fsr1, fsr2);

  new_pc        <= x"0000" & frsr1;
  flgs_and_func <= flgs AND func;

  WITH branch & func SELECT
  is_jmp <=
    "1" WHEN "1000",
    "0" WHEN OTHERS;

  WITH intcal & func SELECT
  is_cal <=
    "1" WHEN "1001",
    "0" WHEN OTHERS;

  WITH fsr1 SELECT
    frsr1 <=
    rsrc_alu WHEN "01",
    rsrc_mem WHEN "10",
    rsr1 WHEN OTHERS;

  WITH in_imm SELECT
    alu_op1 <=
    op1 WHEN "1",
    frsr1 WHEN OTHERS;

  WITH fsr2 SELECT
    alu_op2 <=
    rsrc_alu WHEN "01",
    rsrc_mem WHEN "10",
    op2 WHEN OTHERS;

  new_pc_en <=
    "1" WHEN is_jmp = "1" ELSE
    "1" WHEN is_cal = "1" ELSE
    "1" WHEN flgs_and_func(2) = '1' ELSE
    "1" WHEN flgs_and_func(1) = '1' ELSE
    "1" WHEN flgs_and_func(0) = '1' ELSE
    "0";

  PROCESS (clk)
  BEGIN
    IF falling_edge(clk) THEN
      IF mem_flgs_en = "1" THEN
        -- this is when the memory requests to store these flags on the alu.
        -- happens with rti instruction.
        flgs <= mem_flgs;
      ELSIF alu_en = "1" THEN
        flgs <= n & z & c;
      ELSIF branch = "1" THEN
        flgs <= flgs and not flgs_and_func;
      END IF;
    END IF;
  END PROCESS;

END ARCHITECTURE;
