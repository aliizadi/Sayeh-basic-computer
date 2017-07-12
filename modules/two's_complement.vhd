library IEEE;
use IEEE.std_logic_1164.all;
USE ieee.std_logic_signed.all;
USE ieee.std_logic_arith.all;

entity TwosComplement is port (
	A : in std_logic_vector (15 downto 0) ;
	output : out std_logic_vector (15 downto 0)
	);
end entity ; 

architecture RTL of TwosComplement is 

begin
  
  process(A) 
    variable result : std_logic_vector(15 downto 0 ) ; 
  begin
	
  result := not(A) + "0000000000000001" ;
  	
  	output <= result ; 
end process ;

end RTL ; 