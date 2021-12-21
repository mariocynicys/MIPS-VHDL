LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.numeric_std.all;
use IEEE.math_real.all;

ENTITY Instruction_Memory IS
PORT(
	Clk : IN std_logic;
	Address : IN  std_logic_vector(31 DOWNTO 0);
	DataOut : OUT std_logic_vector(15 DOWNTO 0));
END ENTITY Instruction_Memory;

ARCHITECTURE InstMemory OF Instruction_Memory IS
TYPE ram_type IS ARRAY(0 TO 2**20-1) OF std_logic_vector(15 DOWNTO 0);
SIGNAL ram : ram_type ;

BEGIN
	PROCESS(Clk) IS
		BEGIN
			IF rising_edge(Clk) THEN  
				DataOut <= ram(to_integer(unsigned(Address)));
			END IF;
	END PROCESS;
END InstMemory;