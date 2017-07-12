library IEEE;
use IEEE.std_logic_1164.all;

entity InstructionRegister is port (
	clk , load :in std_logic ;
	input : in std_logic_vector (15 downto 0) ; 
	output : out std_logic_vector (15 downto 0)
	);
end entity ; 

architecture RTL of InstructionRegister is 

begin 
	process(clk)
		begin
			if clk='1' and clk'event then
				if load='1' then 
					output <= input ; 
				end if;
			end if;
		end process;
end RTL;