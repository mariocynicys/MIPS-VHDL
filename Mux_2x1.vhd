LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.numeric_std.all;
use IEEE.math_real.all;

ENTITY Mux_2x1 IS
PORT(
	Input1 	: IN 	std_logic;
	Input2 	: IN 	std_logic;
	Sel 	: IN 	std_logic;
	Output	: Out 	std_logic
);
END ENTITY Mux_2x1;

ARCHITECTURE Mux2x1 OF Mux_2x1 IS
BEGIN
	With Sel Select
		Output <=
			Input1 	When '0',
			Input2 	When '1',
			'0' 	When others; 
END Mux2x1;
