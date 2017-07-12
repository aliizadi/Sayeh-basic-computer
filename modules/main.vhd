library IEEE;
use IEEE.std_logic_1164.all;

entity Main is port (
  clk : in std_logic ; 
  ExternalReset : in std_logic
  );  
end entity ;

architecture RTL of Main is

	component Sayeh is port (
	clk : in std_logic ;
	ExternalReset, MemDataready : in std_logic; 
	Databus : inout std_logic_vector (15 downto 0) ;
	ReadMem, WriteMem, ReadIO, WriteIO : out std_logic ;
	Addressbus : out std_logic_vector (15 downto 0) 
	);
	end component ;
	
	component memory is
	generic (blocksize : integer := 1024);

	port (clk, readmem, writemem : in std_logic;
		addressbus: in std_logic_vector (15 downto 0);
		databus : inout std_logic_vector (15 downto 0);
		memdataready : out std_logic);
	end component ; 
	
	component portManager is
	generic (blocksize : integer := 64);

	port (clk, ReadIO, WriteIO : in std_logic;
		addressbus: in std_logic_vector (15 downto 0);
		databus : inout std_logic_vector (15 downto 0)
		);
	end component ; 
	

	
	signal MemDataready: std_logic ;
	signal Databus : std_logic_vector ( 15 downto 0) ;
	signal ReadMem, WriteMem :std_logic ;
	signal  ReadIO, WriteIO : std_logic  ;
	signal Addressbus : std_logic_vector (15 downto 0) ;
	
	



begin 

	s : Sayeh port map (clk , ExternalReset ,  MemDataready , Databus , ReadMem, WriteMem, ReadIO, WriteIO ,Addressbus) ; 
	mem : memory port map (clk , ReadMem ,  WriteMem ,Addressbus, Databus , MemDataready); 
  portM : portManager port map ( clk , ReadIO ,  WriteIO ,Addressbus, Databus); 

	


end RTL ; 