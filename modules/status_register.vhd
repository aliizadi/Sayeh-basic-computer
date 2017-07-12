library IEEE;
use IEEE.std_logic_1164.all;

entity StatusRegister is port ( 
	 Cset, Creset,Zset, Zreset , SRload : in std_logic; 
	 Cin , Zin : in std_logic ;
	 clk : in std_logic; 
	 Cout, Zout : out std_logic 
	 );
end entity;

architecture RTL of StatusRegister is 

begin 
	
	process(clk)
	
	begin
		if clk='1' and clk'event then
		  if SRload ='1' then 
		    Cout <= Cin ; 
		    Zout <= Zin ;
		   elsif Cset = '1' then 
		     Cout <= '1' ; 
		   elsif Creset ='1' then 
		     Cout <= '0' ; 
		   elsif Zset ='1' then 
		    Zout <= '1' ; 
		   elsif Zreset ='1' then 
		    Zout <= '0' ;  
			end if ; 

		end if ; 
	end process;

end RTL ;