library ieee;
use ieee.std_logic_1164.all;

entity part_d is
    port(a: in std_logic_vector(15 downto 0);
        sel: in std_logic_vector(1 downto 0);
        cin: in std_logic;
        cout: out std_logic;
        f: out std_logic_vector(15 downto 0));
end entity;

architecture logic_d of part_d is
begin
    f <= a(14 downto 0) & '0' when sel = "00" else
         a(14 downto 0) & a(15) when sel = "01" else
         a(14 downto 0) & cin when sel = "10" else
         "0000000000000000";

    cout <= '0' when sel = "11" else
            a(15);
end architecture;
