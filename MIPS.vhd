LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;

ENTITY MIPS IS
  PORT (
    reset    : IN STD_LOGIC;
    in_port  : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
    out_port : OUT STD_LOGIC_VECTOR(15 DOWNTO 0)
  );
END ENTITY;
ARCHITECTURE MIPSArch OF MIPS IS
  CONSTANT clk_prd : TIME      := 100 ps;
  SIGNAL clk       : STD_LOGIC := '0';
  SIGNAL rst       : STD_LOGIC_VECTOR(0 DOWNTO 0);
  ------------------------------------
  -- F = FetchDecodeStage
  -- R = RegiserReadStage
  -- E = ExecutionStage
  -- M = MemoryStage
  -- W = WriteBackStage
  -- B = Buffer
  ----------------FB------------------
  SIGNAL FB_rst, FB_in, FB_im, FB_alu, FB_brn, FB_wb : STD_LOGIC_VECTOR(0 DOWNTO 0);
  SIGNAL FB_int_cal, FB_out, FB_mr, FB_mw, FB_ps_pp  : STD_LOGIC_VECTOR(0 DOWNTO 0);
  SIGNAL FB_func, FB_dst, FB_sr1, FB_sr2             : STD_LOGIC_VECTOR(2 DOWNTO 0);
  SIGNAL FB_pc                                       : STD_LOGIC_VECTOR(31 DOWNTO 0);
  SIGNAL FB_imm, FB_inn                              : STD_LOGIC_VECTOR(15 DOWNTO 0);
  ----------------BR------------------
  SIGNAL BR_rst, BR_in, BR_im, BR_alu, BR_brn, BR_wb : STD_LOGIC_VECTOR(0 DOWNTO 0);
  SIGNAL BR_int_cal, BR_out, BR_mr, BR_mw, BR_ps_pp  : STD_LOGIC_VECTOR(0 DOWNTO 0);
  SIGNAL BR_func, BR_dst, BR_sr1, BR_sr2             : STD_LOGIC_VECTOR(2 DOWNTO 0);
  SIGNAL BR_pc                                       : STD_LOGIC_VECTOR(31 DOWNTO 0);
  SIGNAL BR_imm, BR_inn                              : STD_LOGIC_VECTOR(15 DOWNTO 0);
  ----------------RB------------------
  SIGNAL RB_op1, RB_op2, RB_rsr1 : STD_LOGIC_VECTOR(15 DOWNTO 0);
  ----------------BE------------------
  ----------------EB------------------
  ----------------BM------------------
  ----------------MB------------------
  ----------------BW------------------
  ---------------FLSH-----------------
  SIGNAL F_flsh, R_flsh, E_flsh, M_flsh : STD_LOGIC_VECTOR(0 DOWNTO 0);
  ------------FEEDBACKS---------------
  -- from writeback to registerread
  SIGNAL WR_wb : STD_LOGIC_VECTOR(0 DOWNTO 0);
  SIGNAL WR_wa : STD_LOGIC_VECTOR(2 DOWNTO 0);
  SIGNAL WR_wd : STD_LOGIC_VECTOR(15 DOWNTO 0);
BEGIN
  -- Update the clk.
  clk <= NOT clk AFTER clk_prd / 2;
  rst <= rst;

  --fetch_stage: entity work.fetch port map();
  ---
  fetch_buf : ENTITY work.fet_buf PORT MAP(clk, F_flsh,
    FB_func, BR_func,
    FB_alu, BR_alu,
    FB_int_cal, BR_int_cal,
    FB_in, BR_in,
    FB_im, BR_im,
    FB_mr, BR_mr,
    FB_mw, BR_mw,
    FB_brn, BR_brn,
    FB_ps_pp, BR_ps_pp,
    FB_wb, BR_wb,
    FB_out, BR_out,
    FB_dst, BR_dst,
    FB_sr1, BR_sr1,
    FB_sr2, BR_sr2,
    FB_pc, BR_pc,
    FB_inn, BR_inn,
    FB_imm, BR_imm,
    FB_rst, BR_rst
    );
  ---
  registerread_stage : ENTITY work.RegisterReadStage PORT MAP(clk,
    WR_wb, WR_wd,
    BR_sr1, BR_sr2, WR_wa,
    BR_im, BR_in,
    BR_imm, BR_inn,
    RB_op1, RB_op2, RB_rsr1
    );
END ARCHITECTURE;