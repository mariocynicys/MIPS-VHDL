library ieee;
use ieee.std_logic_1164.all;

ENTITY my_adder IS -- single bit adder
    PORT( a,b,cin : IN std_logic;
        s,cout : OUT std_logic); 
END entity;

ARCHITECTURE a_my_adder OF my_adder IS
BEGIN
    s <= a XOR b XOR cin;
    cout <= (a AND b) or (cin AND (a XOR b));
END architecture;


ENTITY my_nadder IS
    GENERIC (n : integer := 16);
    PORT (a, b : IN std_logic_vector(n-1 DOWNTO 0) ;
        cin : IN std_logic;
        s : OUT std_logic_vector(n-1 DOWNTO 0);
        cout : OUT std_logic);
END entity;

ARCHITECTURE a_my_nadder OF my_nadder IS
    COMPONENT my_adder IS
        PORT( a,b,cin : IN std_logic; s,cout : OUT std_logic);
    END COMPONENT;
SIGNAL temp : std_logic_vector(n DOWNTO 0);
BEGIN
    temp(0) <= cin;
    loop1: FOR i IN 0 TO n-1 GENERATE
        f(i) <= my_adder PORT MAP(a(i),b(i),temp(i),s(i),temp(i+1));
    END GENERATE;
    cout <= temp(n)
end architecture;

entity part_a is
    port(a, b: in std_logic_vector(n-1 downto 0);
        sel: in std_logic_vector(1 downto 0);
        cin: in std_logic;
        cout: out std_logic;
        f: out std_logic_vector(n-1 downto 0));
end entity;

architecture logic_a of part_a is
    component my_nadder is
        PORT (a, b : IN std_logic_vector(n-1 DOWNTO 0) ;
        cin : IN std_logic;
        s : OUT std_logic_vector(n-1 DOWNTO 0);
        cout : OUT std_logic);
    end component;
begin

end architecture;
