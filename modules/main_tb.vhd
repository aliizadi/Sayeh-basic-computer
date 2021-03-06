library IEEE;
use IEEE.std_logic_1164.all;

entity MainTb is 
end entity ; 

architecture testBench of MainTb is 

component Main is port (
  clk : in std_logic ; 
  ExternalReset : in std_logic
  );  
  
  end component ;
  
  signal clk , ExternalReset : std_logic ; 
  
  
begin

  M : Main port map (clk , ExternalReset) ;   
  
	process
	begin
		clk <= '0' ;
		Wait for 50 ns  ;
		clk <='1' ; 
		Wait for 50 ns ; 
	end process ;
	
	process
	begin
	ExternalReset <= '1' ; 
	wait for 100 ns ; 
	ExternalReset <= '0'; 
	wait ; 
	end process ;


end architecture ;