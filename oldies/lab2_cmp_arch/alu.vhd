library ieee;
use ieee.std_logic_1164.all;

entity alu is
    generic (n: integer := 16);
    port(a, b: in std_logic_vector(n-1 downto 0);
        sel: in std_logic_vector(3 downto 0);
        cin: in std_logic;
        cout: out std_logic;
        f: out std_logic_vector(n-1 downto 0));
end entity;

architecture alulogic of alu is
    signal f_a, f_b, f_c, f_d: std_logic_vector(n-1 downto 0);
    signal cout_a, cout_c, cout_d: std_logic;

    component part_a is
        port(a, b: in std_logic_vector(n-1 downto 0);
            sel: in std_logic_vector(1 downto 0);
            cin: in std_logic;
            cout: out std_logic;
            f: out std_logic_vector(n-1 downto 0));
    end component;
    component part_b is
        port(a, b: in std_logic_vector(n-1 downto 0);
            sel: in std_logic_vector(1 downto 0);
            f: out std_logic_vector(n-1 downto 0));
    end component;
    component part_c is
        port(a: in std_logic_vector(n-1 downto 0);
            sel: in std_logic_vector(1 downto 0);
            cin: in std_logic;
            cout: out std_logic;
            f: out std_logic_vector(n-1 downto 0));
    end component;
    component part_d is
        port(a: in std_logic_vector(n-1 downto 0);
            sel: in std_logic_vector(1 downto 0);
            cin: in std_logic;
            cout: out std_logic;
            f: out std_logic_vector(n-1 downto 0));
    end component;
begin
    c0: part_a generic map(n) port map(a, b, sel(1 downto 0), cin, cout_a, f_a);
    c1: part_b generic map(n) port map(a, b, sel(1 downto 0), f_b);
    c2: part_c generic map(n) port map(a, sel(1 downto 0), cin, cout_c, f_c);
    c3: part_d generic map(n) port map(a, sel(1 downto 0), cin, cout_d, f_d);

    f <= f_a when sel(3 downto 2) = "00" else
         f_b when sel(3 downto 2) = "01" else
         f_c when sel(3 downto 2) = "10" else
         f_d;

    cout <= cout_a when sel(3 downto 2) = "00" else
            '0' when sel(3 downto 2) = "01" else
            cout_c when sel(3 downto 2) = "10" else
            cout_d;
end alulogic;