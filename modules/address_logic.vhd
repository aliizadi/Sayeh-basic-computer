library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_unsigned.all;



entity addressLogic is port(
	ResetPc , PCplusI , PCplus1 , RplusI , Rplus0 : in std_logic;
	PCside , Rside : in std_logic_vector(15 downto 0);
	Iside : in std_logic_vector (7 downto 0);
	ALout :out std_logic_vector (15 downto 0)
	);
end addressLogic ; 

architecture DataFlow of addressLogic is 
	constant one : std_logic_vector (4 downto 0)
						 := "10000";
	constant two : std_logic_vector (4 downto 0)
						 := "01000";
	constant three : std_logic_vector (4 downto 0)
						 := "00100";		 
	constant four : std_logic_vector (4 downto 0)
						 := "00010";
	constant five : std_logic_vector (4 downto 0)
						 := "00001";
	
	begin 
	process(ResetPc , PCplusI , PCplus1 , RplusI , Rplus0, PCside , Rside , Iside)
		variable temp :std_logic_vector (4 downto 0);
		begin
			temp := (ResetPC & PCplusI & PCplus1 & RplusI & Rplus0);
			CASE temp IS
				WHEN one => ALout <= (OTHERS => '0');
				WHEN two => ALout <= PCside + Iside;
				WHEN three => ALout <= PCside + 1;
				WHEN four => ALout <= Rside + Iside;
				WHEN five => ALout <= Rside;
				WHEN OTHERS => ALout <= PCside;
			end case;
	end process;
end DataFlow;				