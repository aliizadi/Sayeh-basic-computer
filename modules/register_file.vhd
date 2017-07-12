library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_unsigned.all;
USE ieee.numeric_std.ALL;

entity RegisterFile is port(
		input : in std_logic_vector (15 downto 0) ;
		clk , RFLwrite , RFHwrite : in std_logic ; 
		Ladder, Radder : in std_logic_vector (1 downto 0);
		wpside : in std_logic_vector (5 downto 0) ;
		Lout , Rout : out std_logic_vector(15 downto 0)
		);
end entity ;

architecture RTL of RegisterFile is 	

	type regs is array (0 to 63) of std_logic_vector(15 downto 0);
	signal memory : regs ;
	
	signal Laddress : std_logic_vector (5 downto 0);
	signal Raddress : std_logic_vector (5 downto 0);
	
	--signal tempReg : std_logic_vector(15 downto 0);
	
	
	

begin 

    
		Laddress <= wpside + Ladder ;
		Raddress <= wpside + Radder;
		
		Lout <= memory(to_integer(unsigned(Laddress))) ;
		Rout <= memory(to_integer(unsigned(Raddress))) ; 
		
	process(clk)
	begin
		if clk='1' and clk'event then
			
			--tempReg <= memory(to_integer(unsigned(Laddress)));
			
			if RFLwrite='1' then 
					memory(to_integer(unsigned(Laddress))	)(7 downto 0) <= input (7 downto 0);
			end if; 
			
			if RFHwrite='1' then 
					memory(to_integer(unsigned(Laddress))	)(15 downto 8) <= input (15 downto 8);
			end if; 
			
			--memory(to_integer(unsigned(Laddress))	) <= tempReg ; 
			
		end if ;
	end process ;

end RTL ;