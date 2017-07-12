library IEEE;
use IEEE.std_logic_1164.all;
USE ieee.std_logic_signed.all;
USE ieee.std_logic_arith.all;

entity ArithmeticUnit is port (
	A , B :in std_logic_vector (15 downto 0);
	B15to0 , AandB , AorB , notB , shlB , shrB , AaddB , AsubB , AmulB , AcmpB : in std_logic ; 
	ALUout : out std_logic_vector (15 downto 0); 
	Cin : in std_logic ; 
	Zout , Cout :out std_logic
	);

end ArithmeticUnit ;

architecture RTL of ArithmeticUnit is 
	constant  one : std_logic_vector (9 downto 0)
						 := "1000000000";
	constant  two : std_logic_vector (9 downto 0)
						 := "0100000000";
	constant  three : std_logic_vector (9 downto 0)
						 := "0010000000";
	constant  four : std_logic_vector (9 downto 0)
						 := "0001000000";
	constant  five : std_logic_vector (9 downto 0)
						 := "0000100000";
	constant  six : std_logic_vector (9 downto 0)
						 := "0000010000";
	constant  seven : std_logic_vector (9 downto 0)
						 := "0000001000";
	constant  eight : std_logic_vector (9 downto 0)
						 := "0000000100";
	constant  nine : std_logic_vector (9 downto 0)
						 := "0000000010";
	constant  ten: std_logic_vector (9 downto 0)
						 := "0000000001";
						 
begin
	process(A , B , B15to0 , AandB , AorB , notB , shlB , shrB , AaddB , AsubB ,AmulB , AcmpB , Cin)
		variable temp :std_logic_vector (9 downto 0);
		
		VARIABLE result : std_logic_vector (15 downto 0);
	  variable MSB : unsigned(2 DOWNTO 0); 
	
		
		
	begin
			temp := (B15to0 & AandB & AorB & notB & shlB & shrB & AaddB & AsubB & AmulB & AcmpB);
			Zout <= '0';
			Cout <= '0';
			ALUout <= (OTHERS => '0');
			
			case temp is 
				when one => result := B ;
				when two  => result :=  A and B ;
				when three  => result := A or B ;
				when four  => result := not B ;
				when five  => 	result (15 downto 1 ) := B(14 downto 0) ;		result (0) := '0' ;
				when six  =>	result (14 downto 0) := B(15 downto 1 );    result (15) := B(15); 
				when seven =>	result := A + B + Cin ;
				when eight  => result := A - B - Cin ;
				when nine  =>	result := A(7 downto 0) * B (7 downto 0) ; 	
				when ten  => result := A ;
											 
											if A=B then 
												Zout <= '1' ; 
											else 
												Zout <= '0' ;
												if A < B then 
													Cout <= '1' ; 
												else 
													Cout <= '0' ;
												end if ;
											end if ; 
				when others =>  result := "0000000000000000" ;
			end case ; 
			
			if(AcmpB /= '1') then 
				if result = "0000000000000000" then 
					Zout <= '1' ; 
				else
					Zout <= '0' ; 
				end if ;
			end if ;
			
			ALUout <= result ; 
			
			
			 
			MSB(2) := result(15);
			MSB(1) := A(15);
			MSB(0) := B(15);
			CASE MSB IS
			WHEN "001" => Cout <= '1';
			WHEN "010" => Cout <= '1';
			WHEN "011" => Cout <= '1';
			WHEN "111" => Cout <= '1';
			WHEN OTHERS => Cout <= '0';
			END CASE;
			
				
	end process;
end RTL;