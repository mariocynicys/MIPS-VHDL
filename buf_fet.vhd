
LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;

ENTITY buf_fet IS
  PORT (
    Clk     : IN STD_LOGIC;
    fnc_in  : IN STD_LOGIC_VECTOR(2 DOWNTO 0);
    fnc_out : OUT STD_LOGIC_VECTOR(2 DOWNTO 0);
    alu_in  : IN STD_LOGIC_VECTOR(0 DOWNTO 0);
    alu_out : OUT STD_LOGIC_VECTOR(0 DOWNTO 0);
    int_in  : IN STD_LOGIC_VECTOR(0 DOWNTO 0);
    int_out : OUT STD_LOGIC_VECTOR(0 DOWNTO 0);
    cal_in  : IN STD_LOGIC_VECTOR(0 DOWNTO 0);
    cal_out : OUT STD_LOGIC_VECTOR(0 DOWNTO 0);
    mer_in  : IN STD_LOGIC_VECTOR(0 DOWNTO 0);
    mer_out : OUT STD_LOGIC_VECTOR(0 DOWNTO 0);
    mew_in  : IN STD_LOGIC_VECTOR(0 DOWNTO 0);
    mew_out : OUT STD_LOGIC_VECTOR(0 DOWNTO 0);
    brn_in  : IN STD_LOGIC_VECTOR(0 DOWNTO 0);
    brn_out : OUT STD_LOGIC_VECTOR(0 DOWNTO 0);
    pup_in  : IN STD_LOGIC_VECTOR(0 DOWNTO 0);
    pup_out : OUT STD_LOGIC_VECTOR(0 DOWNTO 0);
    wrb_in  : IN STD_LOGIC_VECTOR(0 DOWNTO 0);
    wrb_out : OUT STD_LOGIC_VECTOR(0 DOWNTO 0);
    dst_in  : IN STD_LOGIC_VECTOR(2 DOWNTO 0);
    dst_out : OUT STD_LOGIC_VECTOR(2 DOWNTO 0);
    sr1_in  : IN STD_LOGIC_VECTOR(2 DOWNTO 0);
    sr1_out : OUT STD_LOGIC_VECTOR(2 DOWNTO 0);
    sr2_in  : IN STD_LOGIC_VECTOR(2 DOWNTO 0);
    sr2_out : OUT STD_LOGIC_VECTOR(2 DOWNTO 0);
    pc_in   : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
    pc_out  : OUT STD_LOGIC_VECTOR(31 DOWNTO 0)
  );
END ENTITY;

ARCHITECTURE buf_fet_arc OF buf_fet IS
BEGIN
  PROCESS (Clk)
  BEGIN
    IF rising_edge(Clk) THEN
      fnc_out <= fnc_in;
      alu_out <= alu_in;
      int_out <= int_in;
      cal_out <= cal_in;
      mer_out <= mer_in;
      mew_out <= mew_in;
      brn_out <= brn_in;
      pup_out <= pup_in;
      wrb_out <= wrb_in;
      dst_out <= dst_in;
      sr1_out <= sr1_in;
      sr2_out <= sr2_in;
      pc_out  <= pc_in;
    END IF;
  END PROCESS;
END ARCHITECTURE;