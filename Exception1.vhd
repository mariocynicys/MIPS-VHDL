LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.numeric_std.all;
use IEEE.math_real.all;

ENTITY Exception1_Unit IS
PORT(
	PC_IN 	: IN 	std_logic_vector(31 Downto 0);
	Clk	: IN	std_logic;
	PC_Out	: Out	std_logic_vector(31 Downto 0);
	IsExp	: Out	std_logic -- it might be used to make the entity that will change the pc with the Exp handler address Start
);
END ENTITY Exception1_Unit;

ARCHITECTURE Exception1 OF Exception1_Unit IS
BEGIN
	PROCESS(Clk) IS
		BEGIN
			IF rising_edge(Clk) Then
				IF to_integer(unsigned(PC_IN)) > 255  THEN  -- ff = 255
					IsExp <= '1';
					PC_Out <= std_logic_vector(to_unsigned(2,32)); -- 2 is the address of the Exception handler 
				Else
					IsExp <= '0';
					PC_Out <= PC_IN;
				END IF;
			End IF;
	END PROCESS; 
END Exception1;