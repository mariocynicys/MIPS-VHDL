LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.numeric_std.all;
use IEEE.math_real.all;

ENTITY Fetch IS
PORT(
	Instruction 	: Out 	std_logic_vector(31 Downto 0);
	Clk		: IN	std_logic
);
END ENTITY Fetch;

ARCHITECTURE Fetch1 OF Fetch IS

Signal PC	: std_logic_vector(31 Downto 0);
Signal AdderOut : std_logic_vector(31 Downto 0);
Signal Ex1Out 	: std_logic_vector(31 Downto 0);
Signal Inst	: std_logic_vector(31 Downto 0);
Signal isImm	: std_logic;
Signal isEx1	: std_logic;

BEGIN
	isImm <= Inst(2) and Inst(3);
	Instruction <= Inst;
	PC <= Ex1Out; -- this should be change later to the output of the last mux
	A : entity work.Instruction_Memory Port map
	( 
		Clk => Clk,
		PC => PC,
		Instruction => Inst
	);

	B : entity work.PC_Adder Port map
	( 
		PC => PC,
		Sel => isImm,
		NewPC => AdderOut
	);

	C : entity work.Exception1_Unit Port map
	( 
		PC_IN => AdderOut, -- this should be change later to the output of the mux
		Clk => Clk,
		PC_Out => Ex1Out,
		IsExp => isEx1
	);
 
END Fetch1;