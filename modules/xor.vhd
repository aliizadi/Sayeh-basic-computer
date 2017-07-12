library IEEE;
use IEEE.std_logic_1164.all;

entity Xorr is port (
	A : in std_logic_vector(15 downto 0) ;
	B : in std_logic_vector(15 downto 0) ;
	output : out std_logic_vector (15 downto 0) 
	);
end entity ;

architecture RTL of Xorr is 

begin 

	process(A, B)
	begin
		for i in 0 to 15 loop 
	    if(A(i) = '1' and B(i) = '0') then       
				output(i) <= '1' ;
			elsif 	(A(i) = '0' and B(i) = '1') then 
				output (i) <= '1' ; 
			else
	      	output (i) <= '0' ;
	    end if ;  		 
		end loop; 
	end process ;
end RTL ; 