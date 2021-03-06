library IEEE;
use IEEE.std_logic_1164.all;

ENTITY AddressUnit is PORT (
	Rside : IN std_logic_vector (15 DOWNTO 0);
	Iside : IN std_logic_vector (7 DOWNTO 0);
	Address : OUT std_logic_vector (15 DOWNTO 0);
	clk, ResetPC, PCplusI, PCplus1 : IN std_logic;
	RplusI, Rplus0, EnablePC : IN std_logic
	);
 end AddressUnit;
 
 architecture DataFlow of AddressUnit is 
	component programCounter is port (
	input : in std_logic_vector(15 downto 0);
	clk , enable : in std_logic ; 
	output : out std_logic_vector(15 downto 0)
	);
	end component ;
	
	component addressLogic is port(
	ResetPc , PCplusI , PCplus1 , RplusI , Rplus0 : in std_logic;
	PCside , Rside : in std_logic_vector(15 downto 0);
	Iside : in std_logic_vector (7 downto 0);
	ALout :out std_logic_vector (15 downto 0)
	);
	end component; 
	
	SIGNAL pcout : std_logic_vector (15 DOWNTO 0);
	SIGNAL AddressSignal : std_logic_vector (15 DOWNTO 0);
	
	
	begin
	Address <= AddressSignal; 
	l1 : programCounter PORT MAP ( AddressSignal , clk ,EnablePC , pcout);
	l2 : addressLogic PORT MAP (ResetPC, PCplusI , PCplus1 , RplusI , Rplus0 , pcout, Rside, Iside, AddressSignal );
	
end DataFlow ;