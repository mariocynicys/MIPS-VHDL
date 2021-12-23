LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

ENTITY bus_controller IS
  GENERIC (n : INTEGER := 32);
  PORT (
    w_en, r_en   : IN STD_LOGIC;
    w_sel, r_sel : IN STD_LOGIC_VECTOR(1 DOWNTO 0);
    rst          : IN STD_LOGIC_VECTOR (3 DOWNTO 0);
    d_bus        : INOUT STD_LOGIC_VECTOR(n - 1 DOWNTO 0));
END ENTITY;

ARCHITECTURE bus_controller_logic OF bus_controller IS
  COMPONENT decoder IS
    PORT (
      en  : IN STD_LOGIC;
      sel : IN STD_LOGIC_VECTOR(1 DOWNTO 0);
      o   : OUT STD_LOGIC_VECTOR(3 DOWNTO 0));
  END COMPONENT;
  COMPONENT tristatebuf IS
    PORT (
      en      : IN STD_LOGIC;
      in_buf  : IN STD_LOGIC_VECTOR (n - 1 DOWNTO 0);
      out_buf : OUT STD_LOGIC_VECTOR (n - 1 DOWNTO 0));
  END COMPONENT;
  COMPONENT regist IS
    PORT (
      clk, rst, en : IN STD_LOGIC;
      d            : IN STD_LOGIC_VECTOR (n - 1 DOWNTO 0);
      q            : OUT STD_LOGIC_VECTOR (n - 1 DOWNTO 0));
  END COMPONENT;

  SIGNAL read_address, writ_address : STD_LOGIC_VECTOR(3 DOWNTO 0);
  SIGNAL q0, q1, q2, q3             : STD_LOGIC_VECTOR(n - 1 DOWNTO 0);
  -- Clock generation
  CONSTANT clk_prd : TIME      := 100 ps;
  SIGNAL clk       : STD_LOGIC := '0';
BEGIN
  -- Clock update
  clk <= NOT clk AFTER clk_prd / 2;
  -- Decoders
  source_dec      : decoder PORT MAP(r_en, r_sel, read_address);
  destination_dec : decoder PORT MAP(w_en, w_sel, writ_address);
  -- Registers
  r0 : regist GENERIC MAP(n) PORT MAP(clk, rst(0), writ_address(0), d_bus, q0);
  r1 : regist GENERIC MAP(n) PORT MAP(clk, rst(1), writ_address(1), d_bus, q1);
  r2 : regist GENERIC MAP(n) PORT MAP(clk, rst(2), writ_address(2), d_bus, q2);
  r3 : regist GENERIC MAP(n) PORT MAP(clk, rst(3), writ_address(3), d_bus, q3);
  -- TriBuffers
  t0 : tristatebuf GENERIC MAP(n) PORT MAP(read_address(0), q0, d_bus);
  t1 : tristatebuf GENERIC MAP(n) PORT MAP(read_address(1), q1, d_bus);
  t2 : tristatebuf GENERIC MAP(n) PORT MAP(read_address(2), q2, d_bus);
  t3 : tristatebuf GENERIC MAP(n) PORT MAP(read_address(3), q3, d_bus);
END ARCHITECTURE;
