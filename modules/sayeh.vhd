library IEEE;
use IEEE.std_logic_1164.all;

entity Sayeh is port (
	clk : in std_logic ;
	ExternalReset, MemDataready : in std_logic; 
	Databus : inout std_logic_vector (15 downto 0) ;
	ReadMem, WriteMem, ReadIO, WriteIO : out std_logic ;
	Addressbus : out std_logic_vector (15 downto 0) 
	);
end entity ;

architecture RTL of Sayeh is 

	component DataPath is port(
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
	end component ;
	
	component Controller is port(
	ExternalReset, clk , ShadowEn : in std_logic ; 
	
	ResetPC, PCplusI, PCplus1, RplusI, Rplus0,
   	Rs_on_AddressUnitRSide, Rd_on_AddressUnitRSide, EnablePC, 
    B15to0, AandB, AorB, notB, shlB, shrB, AaddB, AsubB, AmulB, AcmpB,
    RFLwrite, RFHwrite,
    WPreset, WPadd, IRload, SRload, 
    Address_on_Databus, ALU_on_Databus, IR_on_LOpndBus, IR_on_HOpndBus, RFright_on_OpndBus,
    ReadMem, WriteMem, ReadIO, WriteIO, Cset, Creset, Zset, Zreset, Shadow : out std_logic ; 
	
	Instruction : in std_logic_vector (15 downto 0); 
	
	Cflag, Zflag, memDataReady : in std_logic 
	
	);
	
	end component  ; 
	
	
	----------signals-------------
	
	signal Instruction : std_logic_vector (15 downto 0); 
	signal
	ResetPC, PCplusI, PCplus1, RplusI, Rplus0, ShadowEn ,
	Rs_on_AddressUnitRSide, Rd_on_AddressUnitRSide, EnablePC,
	B15to0, AandB, AorB, notB, shlB, shrB, AaddB, AsubB, AmulB, AcmpB,
	RFHwrite, RFLwrite, 
	WPreset, WPadd, IRload, SRload, 
	Address_on_Databus, ALU_on_Databus, IR_on_LOpndBus, IR_on_HOpndBus, RFright_on_OpndBus,
	Cset, Creset, Zset, Zreset, Shadow,
	Cflag, Zflag :  std_logic ; 
	
begin 

	dp : DataPath port map (clk, Databus, Addressbus,Instruction,ShadowEn,  Cflag, Zflag ,ResetPC, PCplusI, PCplus1, RplusI, Rplus0,
											Rs_on_AddressUnitRSide, Rd_on_AddressUnitRSide, EnablePC,
											B15to0, AandB, AorB, notB, shlB, shrB, AaddB, AsubB, AmulB, AcmpB,
											RFLwrite, RFHwrite,
											WPreset, WPadd, IRload, SRload, 
											Address_on_Databus, ALU_on_Databus, IR_on_LOpndBus, IR_on_HOpndBus, RFright_on_OpndBus,
											Cset, Creset, Zset, Zreset, Shadow
											 ) ;
											
	cl : Controller port map (	ExternalReset, clk,ShadowEn, 
							ResetPC, PCplusI, PCplus1, RplusI, Rplus0, 
							Rs_on_AddressUnitRSide, Rd_on_AddressUnitRSide, EnablePC, 
							B15to0, AandB, AorB, notB, shlB, shrB, AaddB, AsubB, AmulB, AcmpB,
							RFLwrite, RFHwrite,
							WPreset, WPadd,IRload, SRload, 
							Address_on_Databus, ALU_on_Databus, IR_on_LOpndBus, IR_on_HOpndBus, RFright_on_OpndBus,
							ReadMem, WriteMem,ReadIO, WriteIO, Cset, Creset, Zset, Zreset, Shadow, 
							Instruction, Cflag, Zflag, MemDataready) ;

end RTL ; 
