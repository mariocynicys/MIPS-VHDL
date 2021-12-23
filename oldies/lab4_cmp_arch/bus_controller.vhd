LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;

ENTITY bus_controller IS
  GENERIC (
    n           : INTEGER := 32;
    adrs_n_bits : INTEGER := 4);
  PORT (
    w_en, r_en   : IN STD_LOGIC;
    w_sel, r_sel : IN STD_LOGIC_VECTOR(1 DOWNTO 0);
    rst          : IN STD_LOGIC_VECTOR (4 DOWNTO 0);
    d_bus        : INOUT STD_LOGIC_VECTOR(n - 1 DOWNTO 0));
END ENTITY;

ARCHITECTURE bus_controller_logic OF bus_controller IS
  SIGNAL read_address, writ_address : STD_LOGIC_VECTOR(3 DOWNTO 0);
  SIGNAL q0, q1, q2, q3, q4         : STD_LOGIC_VECTOR(n - 1 DOWNTO 0);
  -- Clock generation
  CONSTANT clk_prd         : TIME      := 100 ps;
  SIGNAL mem_w, mem_r, clk : STD_LOGIC := '0';
  SIGNAL mem_adrs          : STD_LOGIC_VECTOR(adrs_n_bits - 1 DOWNTO 0);
BEGIN
  PROCESS (clk, rst(4))
  BEGIN
    IF (rst(4) = '1') THEN
      mem_adrs <= "1010";
    END IF;
    -- It is so inconvenient to have the memory address controlled by the clock.
    -- Since this is not part of the interface, but instead part of the verification,
    -- I decided to let this signal change on falling edges of the clock as opposed
    -- to other signals and components to have a convenient non-hacky simulation.
    IF falling_edge(clk) THEN
      mem_adrs <= STD_LOGIC_VECTOR(unsigned(mem_adrs) - 1);
    END IF;
  END PROCESS;
  -- Clock update
  clk <= NOT clk AFTER clk_prd / 2;
  -- Memory selection
  mem_r <= not r_en;
  mem_w <= not w_en;
  -- Decoders
  source_dec      : ENTITY work.decoder PORT MAP(r_en, r_sel, read_address);
  destination_dec : ENTITY work.decoder PORT MAP(w_en, w_sel, writ_address);
  -- Registers
  r0 : ENTITY work.regist GENERIC MAP(n) PORT MAP(clk, rst(0), writ_address(0), d_bus, q0);
  r1 : ENTITY work.regist GENERIC MAP(n) PORT MAP(clk, rst(1), writ_address(1), d_bus, q1);
  r2 : ENTITY work.regist GENERIC MAP(n) PORT MAP(clk, rst(2), writ_address(2), d_bus, q2);
  r3 : ENTITY work.regist GENERIC MAP(n) PORT MAP(clk, rst(3), writ_address(3), d_bus, q3);
  -- Memory
  m0 : ENTITY work.ram GENERIC MAP (n, adrs_n_bits) PORT MAP(clk, mem_w, mem_adrs, d_bus, q4);
  -- TriBuffers
  t0 : ENTITY work.tristatebuf GENERIC MAP(n) PORT MAP(read_address(0), q0, d_bus);
  t1 : ENTITY work.tristatebuf GENERIC MAP(n) PORT MAP(read_address(1), q1, d_bus);
  t2 : ENTITY work.tristatebuf GENERIC MAP(n) PORT MAP(read_address(2), q2, d_bus);
  t3 : ENTITY work.tristatebuf GENERIC MAP(n) PORT MAP(read_address(3), q3, d_bus);
  t4 : ENTITY work.tristatebuf GENERIC MAP(n) PORT MAP(mem_r, q4, d_bus);
END ARCHITECTURE;