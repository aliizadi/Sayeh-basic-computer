library IEEE;
use IEEE.std_logic_1164.all;

entity programCounter is port (
	input : in std_logic_vector(15 downto 0);
	clk , enable : in std_logic ; 
	output : out std_logic_vector(15 downto 0)
	);
end programCounter ; 

architecture RTL of programCounter is 
begin
	process(clk)
	begin
		if clk='1' and clk'event then
			if enable='1' then 
				output <= input ; 
			end if;
		end if;
	end process;
end RTL;