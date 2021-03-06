library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_unsigned.all;

entity WindowPointer is port (
	input : in std_logic_vector(5 downto 0);
	clk, WPreset, WPadd : in std_logic ; 
	output : out std_logic_vector (5 downto 0)
	);
end entity;

architecture RTL of WindowPointer is 

signal op : std_logic_vector ( 5 downto 0) := "000000";

begin 
	output <= op ;
	process(clk)
	begin
		if clk='1' and clk'event then
		
			if WPreset='1' then
				op <= "000000" ; 
				
			elsif WPadd='1' then
				op <= op + input ;  
			end if ; 
	end if ;
	end process ;

end RTL ;
