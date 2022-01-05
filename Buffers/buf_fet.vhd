
LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;

ENTITY buf_fet IS
  PORT (
    clk            : IN STD_LOGIC;
    fsh            : IN STD_LOGIC_VECTOR(0 DOWNTO 0);
    fnc_in         : IN STD_LOGIC_VECTOR(2 DOWNTO 0);
    fnc_out        : OUT STD_LOGIC_VECTOR(2 DOWNTO 0);
    alu_en_in      : IN STD_LOGIC_VECTOR(0 DOWNTO 0);
    alu_en_out     : OUT STD_LOGIC_VECTOR(0 DOWNTO 0);
    cal_int_in     : IN STD_LOGIC_VECTOR(0 DOWNTO 0);
    cal_int_out    : OUT STD_LOGIC_VECTOR(0 DOWNTO 0);
    in_en_in       : IN STD_LOGIC_VECTOR(0 DOWNTO 0);
    in_en_out      : OUT STD_LOGIC_VECTOR(0 DOWNTO 0);
    imm_en_in      : IN STD_LOGIC_VECTOR(0 DOWNTO 0);
    imm_en_out     : OUT STD_LOGIC_VECTOR(0 DOWNTO 0);
    mr_in          : IN STD_LOGIC_VECTOR(0 DOWNTO 0);
    mr_out         : OUT STD_LOGIC_VECTOR(0 DOWNTO 0);
    mw_in          : IN STD_LOGIC_VECTOR(0 DOWNTO 0);
    mw_out         : OUT STD_LOGIC_VECTOR(0 DOWNTO 0);
    brn_in         : IN STD_LOGIC_VECTOR(0 DOWNTO 0);
    brn_out        : OUT STD_LOGIC_VECTOR(0 DOWNTO 0);
    pus_pop_en_in  : IN STD_LOGIC_VECTOR(0 DOWNTO 0);
    pus_pop_en_out : OUT STD_LOGIC_VECTOR(0 DOWNTO 0);
    wb_in          : IN STD_LOGIC_VECTOR(0 DOWNTO 0);
    wb_out         : OUT STD_LOGIC_VECTOR(0 DOWNTO 0);
    dst_in         : IN STD_LOGIC_VECTOR(2 DOWNTO 0);
    dst_out        : OUT STD_LOGIC_VECTOR(2 DOWNTO 0);
    sr1_in         : IN STD_LOGIC_VECTOR(2 DOWNTO 0);
    sr1_out        : OUT STD_LOGIC_VECTOR(2 DOWNTO 0);
    sr2_in         : IN STD_LOGIC_VECTOR(2 DOWNTO 0);
    sr2_out        : OUT STD_LOGIC_VECTOR(2 DOWNTO 0);
    pc_in          : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
    pc_out         : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
    imm_in         : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
    imm_out        : OUT STD_LOGIC_VECTOR(15 DOWNTO 0);
    rst_in         : IN STD_LOGIC_VECTOR(0 DOWNTO 0);
    rst_out        : OUT STD_LOGIC_VECTOR(0 DOWNTO 0)
  );
END ENTITY;

ARCHITECTURE buf_fet_arc OF buf_fet IS
BEGIN
  PROCESS (clk)
  BEGIN
    IF rising_edge(clk) THEN
      IF fsh = "1" THEN
        fnc_out        <= "000";
        alu_en_out     <= "0";
        cal_int_out    <= "0";
        in_en_out      <= "0";
        imm_en_out     <= "0";
        mr_out         <= "0";
        mw_out         <= "0";
        brn_out        <= "0";
        pus_pop_en_out <= "0";
        wb_out         <= "0";
        dst_out        <= "000";
        sr1_out        <= "000";
        sr2_out        <= "000";
        pc_out         <= "00000000000000000000000000000000";
        imm_out        <= "0000000000000000";
        rst_out        <= "0";
      ELSE
        fnc_out        <= fnc_in;
        alu_en_out     <= alu_en_in;
        cal_int_out    <= cal_int_in;
        in_en_out      <= in_en_in;
        imm_en_out     <= imm_en_in;
        mr_out         <= mr_in;
        mw_out         <= mw_in;
        brn_out        <= brn_in;
        pus_pop_en_out <= pus_pop_en_in;
        wb_out         <= wb_in;
        dst_out        <= dst_in;
        sr1_out        <= sr1_in;
        sr2_out        <= sr2_in;
        pc_out         <= pc_in;
        imm_out        <= imm_in;
        rst_out        <= rst_in;
      END IF;
    END IF;
  END PROCESS;
END ARCHITECTURE;