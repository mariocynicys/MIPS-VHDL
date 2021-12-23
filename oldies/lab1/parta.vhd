library ieee;
use ieee.std_logic_1164.all;

entity part_a is
    port(a, b: in std_logic_vector(15 downto 0);
        sel: in std_logic_vector(1 downto 0);
        cin: in std_logic;
        cout: out std_logic;
        f: out std_logic_vector(15 downto 0));
end entity;

architecture logic_a of part_a is
begin
    f <= "0000000000000000";
    cout <= '0';
end architecture;
