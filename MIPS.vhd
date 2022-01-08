LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;

ENTITY MIPS IS
  PORT (
    reset    : IN STD_LOGIC;
    in_port  : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
    out_port : OUT STD_LOGIC_VECTOR(15 DOWNTO 0);
    epc      : OUT STD_LOGIC_VECTOR(31 DOWNTO 0)
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
  ---------------NEXT-----------------
  ----------------BR------------------
  SIGNAL BR_rst, BR_in, BR_im, BR_alu, BR_brn, BR_wb : STD_LOGIC_VECTOR(0 DOWNTO 0);
  SIGNAL BR_int_cal, BR_out, BR_mr, BR_mw, BR_ps_pp  : STD_LOGIC_VECTOR(0 DOWNTO 0);
  SIGNAL BR_func, BR_dst, BR_sr1, BR_sr2             : STD_LOGIC_VECTOR(2 DOWNTO 0);
  SIGNAL BR_pc                                       : STD_LOGIC_VECTOR(31 DOWNTO 0);
  SIGNAL BR_imm, BR_inn                              : STD_LOGIC_VECTOR(15 DOWNTO 0);
  ----------------RB------------------
  SIGNAL RB_op1, RB_op2, RB_rsr1 : STD_LOGIC_VECTOR(15 DOWNTO 0);
  ---------------NEXT-----------------
  ----------------BE------------------
  SIGNAL BE_rst, BE_alu, BE_brn, BE_wb, BE_in_im    : STD_LOGIC_VECTOR(0 DOWNTO 0);
  SIGNAL BE_int_cal, BE_out, BE_mr, BE_mw, BE_ps_pp : STD_LOGIC_VECTOR(0 DOWNTO 0);
  SIGNAL BE_func, BE_dst, BE_sr1, BE_sr2            : STD_LOGIC_VECTOR(2 DOWNTO 0);
  SIGNAL BE_op1, BE_op2, BE_rsr1                    : STD_LOGIC_VECTOR(15 DOWNTO 0);
  SIGNAL BE_pc                                      : STD_LOGIC_VECTOR(31 DOWNTO 0);
  ----------------EB------------------
  SIGNAL EB_rsr1, EB_result : STD_LOGIC_VECTOR(15 DOWNTO 0);
  SIGNAL EB_flags           : STD_LOGIC_VECTOR(2 DOWNTO 0);
  ---------------NEXT-----------------
  ----------------BM------------------
  SIGNAL BM_rst, BM_wb, BM_int_cal, BM_out : STD_LOGIC_VECTOR(0 DOWNTO 0);
  SIGNAL BM_mr, BM_mw, BM_ps_pp            : STD_LOGIC_VECTOR(0 DOWNTO 0);
  SIGNAL BM_func, BM_dst                   : STD_LOGIC_VECTOR(2 DOWNTO 0);
  SIGNAL BM_rsr1, BM_result                : STD_LOGIC_VECTOR(15 DOWNTO 0);
  SIGNAL BM_flags                          : STD_LOGIC_VECTOR(2 DOWNTO 0);
  SIGNAL BM_pc                             : STD_LOGIC_VECTOR(31 DOWNTO 0);
  ----------------MB------------------
  SIGNAL MB_wd : STD_LOGIC_VECTOR(15 DOWNTO 0);
  ---------------NEXT-----------------
  ----------------BW------------------
  SIGNAL BW_rst, BW_wb, BW_out : STD_LOGIC_VECTOR(0 DOWNTO 0);
  SIGNAL BW_dst                : STD_LOGIC_VECTOR(2 DOWNTO 0);
  SIGNAL BW_wd                 : STD_LOGIC_VECTOR(15 DOWNTO 0);
  ---------------FNSH-----------------
  ---------------FLSH-----------------
  SIGNAL F_flsh, R_flsh, E_flsh, M_flsh : STD_LOGIC_VECTOR(0 DOWNTO 0);
  ------------FEEDBACKS---------------

  -- from writeback to registerread
  SIGNAL WR_we : STD_LOGIC_VECTOR(0 DOWNTO 0);
  SIGNAL WR_wa : STD_LOGIC_VECTOR(2 DOWNTO 0);
  SIGNAL WR_wd : STD_LOGIC_VECTOR(15 DOWNTO 0);
  -- from memory to execute
  SIGNAL ME_setflgs : STD_LOGIC_VECTOR(0 DOWNTO 0);
  SIGNAL ME_newflgs : STD_LOGIC_VECTOR(2 DOWNTO 0);
  -- from execute to fetch
  SIGNAL EF_setpc : STD_LOGIC_VECTOR(0 DOWNTO 0);
  SIGNAL EF_newpc : STD_LOGIC_VECTOR(31 DOWNTO 0);
  -- from memory to fetch
  SIGNAL MF_setpc : STD_LOGIC_VECTOR(0 DOWNTO 0);
  SIGNAL MF_newpc : STD_LOGIC_VECTOR(31 DOWNTO 0);
  SIGNAL MF_setex : STD_LOGIC_VECTOR(0 DOWNTO 0);
  SIGNAL MF_expc  : STD_LOGIC_VECTOR(31 DOWNTO 0);
BEGIN
  -- Update the clk.
  clk <= NOT clk AFTER clk_prd / 2;
  ---
  fetch_stage : ENTITY work.FetchStage PORT MAP(clk,
    (0 => reset),
    in_port,
    -- outputs
    FB_func,
    FB_alu,
    FB_int_cal,
    FB_in,
    FB_im,
    FB_mr,
    FB_mw,
    FB_brn,
    FB_ps_pp,
    FB_wb,
    FB_out,
    FB_dst,
    FB_sr1,
    FB_sr2,
    FB_pc,
    FB_inn,
    FB_imm,
    FB_rst,
    epc,
    -- back to fetch
    BE_dst, BE_wb, BE_mr,      -- for load use
    EF_setpc, EF_newpc, BE_pc, -- jumps and cals
    MF_setpc, MF_newpc, BM_pc, -- rets and rtis
    MF_setex, MF_expc,         -- sp exp
    -- flush outs
    F_flsh, R_flsh, E_flsh, M_flsh
    );
  ---
  fetch_buf : ENTITY work.FetBuf PORT MAP(clk, F_flsh,
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
    WR_we, WR_wd,
    BR_sr1, BR_sr2, WR_wa,
    BR_im, BR_in,
    BR_imm, BR_inn,
    -- outputs
    RB_rsr1, RB_op1, RB_op2
    );
  ---
  registerread_buffer : ENTITY work.RegBuf PORT MAP(clk, R_flsh,
    RB_rsr1, BE_rsr1,
    RB_op1, BE_op1,
    RB_op2, BE_op2,
    -- pass
    BR_func, BE_func,
    BR_alu, BE_alu,
    BR_int_cal, BE_int_cal,
    BR_in OR BR_im, BE_in_im,
    BR_mr, BE_mr,
    BR_mw, BE_mw,
    BR_brn, BE_brn,
    BR_ps_pp, BE_ps_pp,
    BR_wb, BE_wb,
    BR_out, BE_out,
    BR_dst, BE_dst,
    BR_sr1, BE_sr1,
    BR_sr2, BE_sr2,
    BR_pc, BE_pc,
    BR_rst, BE_rst
    );
  ---
  execute_stage : ENTITY work.ExecuteStage PORT MAP(clk,
    BE_rst,
    BE_alu,
    BE_brn,
    BE_int_cal,
    BE_in_im,
    BE_func,
    BE_sr1, BE_sr2,
    BE_op1, BE_op2, BE_rsr1,
    -- outputs
    EB_rsr1, EB_result, EB_flags,
    -- forwarding
    BM_wb, BM_dst, BM_result,
    BW_wb, BW_dst, BW_wd,
    -- memory flags loader (for rti)
    ME_setflgs, ME_newflgs,
    -- branch
    EF_setpc, EF_newpc
    );
  ---
  execute_buffer : ENTITY work.ExeBuf PORT MAP(clk, E_flsh,
    EB_rsr1, BM_rsr1,
    EB_result, BM_result,
    EB_flags, BM_flags,
    -- pass
    BE_func, BM_func,
    BE_int_cal, BM_int_cal,
    BE_mr, BM_mr,
    BE_mw, BM_mw,
    BE_ps_pp, BM_ps_pp,
    BE_wb, BM_wb,
    BE_out, BM_out,
    BE_dst, BM_dst,
    BE_pc, BM_pc,
    BE_rst, BM_rst
    );
  ---
  memory_stage : ENTITY work.MemoryStage PORT MAP(clk,
    BM_rst,
    BM_rsr1,
    BM_result,
    BM_mr,
    BM_mw,
    BM_ps_pp,
    BM_int_cal,
    BM_func,
    BM_pc,
    BM_flags,
    -- output
    MB_wd,
    -- rti to exe
    ME_setflgs, ME_newflgs,
    -- rti/ret to fetch
    MF_setpc, MF_newpc,
    -- exp
    MF_setex, MF_expc
    );
  ---
  -- We will need to flush the after memory buffer when ex2 occurs.
  -- This is to stop the instruction causing the exception from
  -- writing back, because the fetch stage will know about the exception
  -- one cycle later and will have no time to stop the faulty instruction
  -- in the after memory buffer.
  memory_buffer : ENTITY work.MemBuf PORT MAP(clk, M_flsh OR MF_setex,
    MB_wd, BW_wd,
    -- pass
    BM_wb, BW_wb,
    BM_out, BW_out,
    BM_dst, BW_dst,
    BM_rst, BW_rst
    );
  ---
  writeback_stage : ENTITY work.WriteBackStage PORT MAP(clk,
    BW_wb,
    BW_out,
    BW_dst,
    BW_wd,
    -- outputs
    WR_we,
    WR_wa,
    WR_wd
    );
  ---
END ARCHITECTURE;