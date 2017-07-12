library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
USE ieee.std_logic_arith.all;
use IEEE.numeric_std.all;


entity Divider is port ( 
	A : in std_logic_vector (15 downto 0) ;
	B : in std_logic_vector (7 downto 0) ;
	division : out std_logic_vector (15 downto 0) 
	);
end entity ;

architecture Behavioral of Divider is 


begin 

  
	

	Proc1: Process (A,B)
	

	
	variable temp : std_logic_vector (15 downto 0) ;

	variable result : STD_LOGIC_Vector(15 downto 0);
	begin
	  
	  
	  

		if (A < B) then
			result := "0000000000000000";
			temp := A;
		elsif (A = B) then
			result := "0000000000000001";
		elsif (A > B) then
			result := "0000000000000001";
			temp := (A - B);
			while (temp >= B) loop
				temp := (temp - B);
				result := result + "0000000000000001";    
			end loop;	
		end if;
	division <= result;
	end process Proc1;
end Behavioral ;