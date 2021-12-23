library ieee;
use ieee.std_logic_1164.all;

entity part_b is
    port(a, b: in std_logic_vector(15 downto 0);
        sel: in std_logic_vector(1 downto 0);
        f: out std_logic_vector(15 downto 0));
end entity;

architecture logic_b of part_b is
begin
    f <= a and b when sel = "00" else
         a or b when sel = "01" else
         a xor b when sel = "10" else
         not a;
end architecture;
