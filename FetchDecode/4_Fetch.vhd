LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.numeric_std.ALL;
USE IEEE.std_logic_unsigned.ALL;

ENTITY FetchStage IS
  PORT (
    clk     : IN STD_LOGIC;
    reset   : IN STD_LOGIC_VECTOR(0 DOWNTO 0);
    in_port : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
    -- signals
    cu_func    : OUT STD_LOGIC_VECTOR(2 DOWNTO 0);
    cu_alu     : OUT STD_LOGIC_VECTOR(0 DOWNTO 0);
    cu_int_cal : OUT STD_LOGIC_VECTOR(0 DOWNTO 0);
    cu_in      : OUT STD_LOGIC_VECTOR(0 DOWNTO 0);
    cu_im      : OUT STD_LOGIC_VECTOR(0 DOWNTO 0);
    cu_mr      : OUT STD_LOGIC_VECTOR(0 DOWNTO 0);
    cu_mw      : OUT STD_LOGIC_VECTOR(0 DOWNTO 0);
    cu_brn     : OUT STD_LOGIC_VECTOR(0 DOWNTO 0);
    cu_ps_pp   : OUT STD_LOGIC_VECTOR(0 DOWNTO 0);
    cu_wb      : OUT STD_LOGIC_VECTOR(0 DOWNTO 0);
    cu_out     : OUT STD_LOGIC_VECTOR(0 DOWNTO 0);
    cu_dst     : OUT STD_LOGIC_VECTOR(2 DOWNTO 0);
    cu_sr1     : OUT STD_LOGIC_VECTOR(2 DOWNTO 0);
    cu_sr2     : OUT STD_LOGIC_VECTOR(2 DOWNTO 0);
    -- outputs
    pc  : OUT STD_LOGIC_VECTOR(31 DOWNTO 0) := x"00000000";
    inn : OUT STD_LOGIC_VECTOR(15 DOWNTO 0);
    imm : OUT STD_LOGIC_VECTOR(15 DOWNTO 0);
    rst : OUT STD_LOGIC_VECTOR(0 DOWNTO 0);
    epc : OUT STD_LOGIC_VECTOR(31 DOWNTO 0) := x"00000000";
    -- for load use
    exe_buf_dst            : IN STD_LOGIC_VECTOR(2 DOWNTO 0);
    exe_buf_wb, exe_buf_mr : IN STD_LOGIC_VECTOR(0 DOWNTO 0);
    -- for jumps and calls
    e_setpc : IN STD_LOGIC_VECTOR(0 DOWNTO 0);
    e_newpc : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
    e_hispc : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
    -- for rets and rtis
    m_setpc : IN STD_LOGIC_VECTOR(0 DOWNTO 0);
    m_newpc : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
    m_hispc : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
    -- for exp2
    m_setex : IN STD_LOGIC_VECTOR(0 DOWNTO 0);
    m_expc  : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
    -- flush outs
    f_flsh, r_flsh, e_flsh, m_flsh : OUT STD_LOGIC_VECTOR(0 DOWNTO 0)
  );
END ENTITY;

ARCHITECTURE FetchStageArch OF FetchStage IS
  SIGNAL instruction              : STD_LOGIC_VECTOR(15 DOWNTO 0);
  SIGNAL f_expc                   : STD_LOGIC_VECTOR(31 DOWNTO 0);
  SIGNAL sr1_ldus, sr2_ldus, ldus : STD_LOGIC_VECTOR(0 DOWNTO 0);
  SIGNAL cu_hlt, cu_int, f_setex  : STD_LOGIC_VECTOR(0 DOWNTO 0);
  SIGNAL to_where                 : STD_LOGIC_VECTOR(8 DOWNTO 0);
  --------------------------PCLOCATIONS-------------------------
  CONSTANT main : STD_LOGIC_VECTOR(31 DOWNTO 0) := x"00000000";
  CONSTANT exp1 : STD_LOGIC_VECTOR(31 DOWNTO 0) := x"00000002";
  CONSTANT exp2 : STD_LOGIC_VECTOR(31 DOWNTO 0) := x"00000004";
  ---------------------------STATEFUL---------------------------
  -- state no.0 -> HLTing and waiting for a rst
  -- state no.1 -> operating normally
  -- state no.2 -> double jumping (following a rst/intx/expx request)
  CONSTANT HLTING : INTEGER := 0;
  CONSTANT OPNORM : INTEGER := 1;
  CONSTANT DBJING : INTEGER := 2;
  CONSTANT ESCAPE : INTEGER := 3;
  -- Note that being on HLTING or DBJING forces the CU to output zeros.
  -- That's why you won't see me using f_flsh in this code.
  SIGNAL state : INTEGER := HLTING;
  --------------------------------------------------------------
  CONSTANT MAXPC : STD_LOGIC_VECTOR(31 DOWNTO 0) := x"0000FF00";

BEGIN
  inn <= in_port;
  rst <= reset;

  iram         : ENTITY work.IRam PORT MAP(pc, instruction, imm);
  control_unit : ENTITY work.ControlUnit PORT MAP(instruction,
    cu_func,
    cu_wb,
    cu_in,
    cu_out,
    cu_im,
    cu_alu,
    cu_mr,
    cu_mw,
    cu_ps_pp,
    cu_brn,
    cu_int_cal,
    sr1_ldus, sr2_ldus,
    cu_dst,
    cu_sr1,
    cu_sr2,
    cu_hlt,
    cu_int,
    state = OPNORM
    );
  load_use : ENTITY work.LoadUse PORT MAP(clk,
    exe_buf_wb AND exe_buf_mr, exe_buf_dst,
    sr1_ldus, cu_sr1,
    sr2_ldus, cu_sr2,
    ldus
    );
  --
  PROCESS (clk)
    -- when this variable is set, this process will not enter the
    -- OPNORM state. This means that there is some BIG BOSS action
    -- occured and took over the normal execution.
  BEGIN
    IF falling_edge(clk) THEN
      -- reset the ex1 signal
      -- note that this won't affect ex1 inside this process.
      f_setex <= "0";
      -- reset the flush signals so not to kill any important
      -- instructions found in the buffers.
      f_flsh <= "0";
      r_flsh <= "0";
      e_flsh <= "0";
      m_flsh <= "0";
      -------------------------------------------------------
      -- BIG BOSSES i.e. they don't give a fuck to the state i.e. operate in any state.
      -- Also if one of them executes, the current state wont take effect.
      IF rst = "1" THEN
        -- first check for a rst signal.
        state <= DBJING;
        pc    <= main;
        -- note that we don't wanna flush the after fetch buffer because we
        -- want the reset signal to propagte through the pipeline.
        r_flsh <= "1";
        e_flsh <= "1";
        m_flsh <= "1";
      ELSIF m_setex = "1" THEN
        -- check for exception 2, it should be served first.
        pc     <= exp2;
        epc    <= m_expc;
        state  <= DBJING;
        r_flsh <= "1";
        e_flsh <= "1";
        m_flsh <= "1";
      ELSIF m_setpc = "1" THEN
        -- check for rti/ret.
        IF m_newpc > MAXPC THEN
          f_setex <= "1";
          f_expc  <= m_hispc;
          -- you don't need to set the state since we know that it will be set
          -- in the next falling edge when the ex1 takes effect.
          -- state   <= HLTING; -- any state other than OPNORM to stop the CU
          m_flsh <= "1"; -- flush the faulty instruction
        ELSE
          pc    <= m_newpc;
          state <= OPNORM;
        END IF;
      ELSIF e_setpc = "1" THEN
        -- check for jumps and calls.
        IF m_newpc > MAXPC THEN
          f_setex <= "1";
          f_expc  <= e_hispc;
          -- you don't need to set the state since we know that it will be set
          -- in the next falling edge when the ex1 takes effect.
          -- state   <= HLTING; -- any state other than OPNORM to stop the CU
          e_flsh <= "1"; -- flush the faulty instruction
        ELSE
          pc    <= e_newpc;
          state <= OPNORM;
        END IF;
      ELSIF f_setex = "1" THEN
        -- then check for exception 1.
        pc     <= exp1;
        epc    <= f_expc;
        state  <= DBJING;
        r_flsh <= "1"; -- this MIGHT be the faulty instruction
      ELSE
        ---------------------------------------------------------
        ---------------------------------------------------------
        ---------------------------------------------------------
        ---------------------------------------------------------
        IF state = HLTING THEN
          -- was halting
          -- as you see, doing nothing.
          ---------------------------------------------------------
          ---------------------------------------------------------
          ---------------------------------------------------------
          ---------------------------------------------------------
        ELSIF state = OPNORM THEN
          -- operating normally (listening to incoming signals)
          IF ldus = "1" THEN
            -- don't move the pc if we encountered a load use case.
            r_flsh <= "1";
          ELSIF cu_hlt = "1" THEN
            -- set the state to halting if we encountered a hlt.
            state <= HLTING;
          ELSIF cu_im = "1" THEN
            -- if the past instruction was an immediate one.
            IF STD_LOGIC_VECTOR(unsigned(pc) + 2) > MAXPC THEN
              -- check that the pc doesn't go past its max.
              f_setex <= "1";
              f_expc  <= pc;
            ELSE
              -- increment the pc by 2.
              pc <= STD_LOGIC_VECTOR(unsigned(pc) + 2);
            END IF;
          ELSE
            -- if the past instruction wasn't an immediate or had anything special.
            IF cu_int = "1" THEN
              -- check first if the past instruction was an int.
              pc       <= x"00000006";
              to_where <= cu_dst & cu_sr1 & cu_sr2;
              state    <= ESCAPE;
            ELSIF STD_LOGIC_VECTOR(unsigned(pc) + 1) > MAXPC THEN
              -- otherwise check that the pc doesn't go past its max.
              f_setex <= "1";
              f_expc  <= pc;
            ELSE
              -- then increment it.
              pc <= STD_LOGIC_VECTOR(unsigned(pc) + 1);
            END IF;
          END IF;
          ---------------------------------------------------------
          ---------------------------------------------------------
          ---------------------------------------------------------
          ---------------------------------------------------------
        ELSIF state = DBJING THEN
          -- move the pc to what is read by the pc.
          -- NOTE: it's not safe to mutate the pc without knowing whether
          -- instruction & imm goes past MAXPC or not, but we are assuming
          -- it will never happen.
          pc    <= instruction & imm;
          state <= OPNORM;
        ELSIF state = ESCAPE THEN
          pc    <= (instruction & imm) + (x"00000" & "000" & to_where);
          state <= DBJING;
        END IF;
        ---------------------------------------------------------
        ---------------------------------------------------------
        ---------------------------------------------------------
        ---------------------------------------------------------
      END IF;
    END IF;
  END PROCESS;
END ARCHITECTURE;