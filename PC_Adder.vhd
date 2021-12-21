LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.numeric_std.all;
use IEEE.math_real.all;

ENTITY PC_Adder IS
PORT(
	PC 	: IN 	std_logic_vector(31 Downto 0);
	Sel	: IN	std_logic;
	NewPC	: Out 	std_logic_vector(31 Downto 0)
);
END ENTITY PC_Adder;

ARCHITECTURE PCAdder OF PC_Adder IS
BEGIN

	With Sel Select
		NewPC <=
			std_logic_vector(to_unsigned(to_integer(unsigned(PC)) + 1,32)) 	When '0',
			std_logic_vector(to_unsigned(to_integer(unsigned(PC)) + 2,32)) 	When '1',
			(Others => '0') 						When others; 
END PCAdder;