library ieee;
use ieee.std_logic_1164.all;

entity part_c is
    port(a: in std_logic_vector(15 downto 0);
        sel: in std_logic_vector(1 downto 0);
        cin: in std_logic;
        cout: out std_logic;
        f: out std_logic_vector(15 downto 0));
end entity;

architecture logic_c of part_c is
begin
    f <= '0' & a(15 downto 1) when sel = "00" else
         a(0) & a(15 downto 1) when sel = "01" else
         cin & a(15 downto 1) when sel = "10" else
         a(15) & a(15 downto 1);

    cout <= a(0);
end architecture;
