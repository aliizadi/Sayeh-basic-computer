library IEEE;
use IEEE.std_logic_1164.all;

entity DataPath is port(
	clk : in std_logic ; 
	Databus : inout std_logic_vector (15 downto 0);
	Addressbus , Instruction : out std_logic_vector(15 downto 0);
	ShadowEn : out  std_logic; 
	Cout, Zout : out std_logic ;
	
	ResetPC, PCplusI, PCplus1, RplusI, Rplus0,
	Rs_on_AddressUnitRSide, Rd_on_AddressUnitRSide, EnablePC,
	B15to0, AandB, AorB, notB, shlB, shrB,
	AaddB, AsubB, AmulB, AcmpB,
	RFLwrite, RFHwrite, WPreset, WPadd, IRload, SRload,
	Address_on_Databus, ALU_on_Databus, IR_on_LOpndBus,
	IR_on_HOpndBus, RFright_on_OpndBus,
	Cset, Creset, Zset, Zreset, Shadow : in std_logic 
	);
end entity ;

architecture RTL of DataPath is 

--------------AddressUnit-------------------
	component AddressUnit is PORT (
		Rside : IN std_logic_vector (15 DOWNTO 0);
		Iside : IN std_logic_vector (7 DOWNTO 0);
		Address : OUT std_logic_vector (15 DOWNTO 0);
		clk, ResetPC, PCplusI, PCplus1 : IN std_logic;
		RplusI, Rplus0, EnablePC : IN std_logic
		);
	end component ;
	
--------------ArithmeticUnit----------------
	component ArithmeticUnit is port (
	A , B :in std_logic_vector (15 downto 0);
	B15to0 , AandB , AorB , notB , shlB , shrB , AaddB , AsubB , AmulB , AcmpB : in std_logic ; 
	ALUout : out std_logic_vector (15 downto 0); 
	Cin : in std_logic ; -- I think that Zin have been missed here 
	Zout , Cout :out std_logic
	);
	end component ;
	
--------------RegisterFile-------------------
	component RegisterFile is port(
		input : in std_logic_vector (15 downto 0) ;
		clk , RFLwrite , RFHwrite : in std_logic ; 
		Ladder, Radder : in std_logic_vector (1 downto 0);
		wpside : in std_logic_vector (5 downto 0) ;
		Lout , Rout : out std_logic_vector(15 downto 0)
		);
	end component ;
--------------InstructionRegister-----------
	component InstructionRegister is port (
	clk , load :in std_logic ;
	input : in std_logic_vector (15 downto 0) ; 
	output : out std_logic_vector (15 downto 0)
	);
	end component ;
	
--------------StatusRegister-----------------
	component StatusRegister is port ( 
	 Cset, Creset,Zset, Zreset , SRload : in std_logic; 
	 Cin , Zin : in std_logic ;
	 clk : in std_logic; 
	 Cout, Zout : out std_logic 
	 );
	 
	 end component ;
	
--------------WindowPointer----------------
	component WindowPointer is port (
	input : in std_logic_vector(5 downto 0);
	clk, WPreset, WPadd : in std_logic ; 
	output : out std_logic_vector (5 downto 0)
	);
	end component ;
	
 

	
	signal  Right, Left, OpndBus, ALUout, IRout, Address, AddressUnitRSideBus : std_logic_vector (15 downto 0);
	signal SRCin, SRZin, SRZout, SRCout : std_logic ;
	signal  WPout : std_logic_vector (5 downto 0) ;
	signal  Laddr, Raddr : std_logic_vector (1 downto 0);


begin 

	AU : AddressUnit port map (AddressUnitRSideBus ,  IRout (7 downto 0) ,  Address , clk ,  ResetPC, PCplusI, PCplus1, RplusI,Rplus0, EnablePC) ; 
	AL : ArithmeticUnit port map (Left, OpndBus, B15to0, AandB, AorB, notB, shlB, shrB, AaddB, AsubB, AmulB, AcmpB,ALUout, SRCout, SRZin, SRCin);
	RF : RegisterFile port map (Databus, clk,RFLwrite,RFHwrite , Laddr, Raddr, WPout,  Left, Right) ;
	IR : InstructionRegister port map ( clk,IRload ,Databus , IRout); 
	SR : StatusRegister port map ( Cset, Creset,Zset, Zreset , SRload , SRCin, SRZin ,  clk ,  SRCout, SRZout);
	WP : WindowPointer port map (IRout (5 downto 0)  ,  clk, WPreset, WPadd, WPout ); 

	------wiring-------
	
	AddressUnitRSideBus <= Right when Rs_on_AddressUnitRSide='1' else
										   Left   when Rd_on_AddressUnitRSide='1' else 
										   "ZZZZZZZZZZZZZZZZ"; 
	
	Addressbus <= Address;
	
	Databus <= Address when Address_on_Databus ='1' else 
					   ALUout   when ALU_on_Databus='1' else 
					   "ZZZZZZZZZZZZZZZZ"; 
	

	
	OpndBus(7 downto 0) <= IRout(7 downto 0) when IR_on_LOpndBus='1' else
											 "ZZZZZZZZ" ;

	OpndBus(15 downto 8) <= IRout (7 downto 0) when IR_on_HOpndBus ='1' else 
											   "ZZZZZZZZ" ;	

	OpndBus <=  Right when RFright_on_OpndBus ='1' else 
						 "ZZZZZZZZZZZZZZZZ";
	Zout <= SRZout;
	Cout <= SRCout;
	
	Instruction <= IRout(15 downto 0);
	
	ShadowEn <= '0' when IRout (7 downto 0 ) = "00001111" else '1' ;  
	
	Laddr <= IRout(11 downto 10) when Shadow='0' else
					IRout(3 downto 2) ;
	Raddr <= IRout(9 downto 8) when Shadow='0' else
					IRout(1 downto 0) ;

end RTL ; 

