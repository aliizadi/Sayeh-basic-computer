library IEEE;
use IEEE.std_logic_1164.all;
USE ieee.std_logic_signed.all;
USE ieee.std_logic_arith.all;

entity MultiPlier is port (
	A : in std_logic_vector (7 downto 0);
	B : in std_logic_vector (7 downto 0) ;
	multiplication : out std_logic_vector( 15 downto 0) 
	); 
end entity ;

architecture Behavioral of MultiPlier is 

begin 

  

	Proc1: Process (A,B)
	
	variable result : STD_LOGIC_Vector(15 downto 0);
	variable temp : std_logic_vector (7 downto 0) ;

	begin
	  
	 
	 	if (A = "00000000") then
			result := "0000000000000000";
		elsif (B = "00000000") then
			result := "0000000000000000";
		else
			result := "0000000000000000" ;
			temp := B ; 
			while (temp > "00000000") loop
				temp := (temp - "00000001");
				result := result + A ;    
				 
			end loop;	
		end if;
	multiplication <= result;
	 
	 
	
	end process Proc1;
end Behavioral ;