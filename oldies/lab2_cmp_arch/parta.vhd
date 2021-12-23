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

library ieee;
use ieee.std_logic_1164.all;
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
        fi : my_adder PORT MAP(a(i),b(i),temp(i),s(i),temp(i+1));
    END GENERATE;
    cout <= temp(n);
end architecture;


library ieee;
use ieee.std_logic_1164.all;
entity part_a is
    GENERIC (n : integer := 16);
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

signal fa,fb,fc,fd,notb :std_logic_vector(n-1 downto 0);
signal ca,cb,cc,cd,notcin:std_logic;
begin

	notb <= not b;
	notcin <= not cin;
	o0: my_nadder generic map(n) port map(a, (others => '0'),cin, fa,ca);
	o1: my_nadder generic map(n) port map(a, b,cin, fb,cb);
	o2: my_nadder generic map(n) port map(a, notb,cin, fc,cc);
	o3: my_nadder generic map(n) port map(a, (others => '1'),cin, fd,cd);

	f <= fa when sel ="00"
	else fb when sel = "01"
	else fc when sel = "10"
	else fd when sel = "11" and cin = '0'
	else (others => '0');

	cout<= ca when sel = "00"
	else cb when sel = "01"
	else cc when sel = "10"
	else cd when sel = "11" and cin ='0'
	else '0';

end architecture;
