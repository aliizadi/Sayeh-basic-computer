library IEEE;
use IEEE.std_logic_1164.all;

entity Controller is port(
	ExternalReset, clk  , ShadowEn: in std_logic ; 
	
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
end entity ; 

architecture RTL of Controller is 

	type state is (reset , halt , fetch , memread , exec1 , exec2 ,exec1lda , exec2lda  , incpc  , exec1sta , exec2sta );
	signal current_state : state;
	signal next_state : state;
	
	CONSTANT b0000 : std_logic_vector (3 DOWNTO 0) := "0000" ;
	CONSTANT b1111 : std_logic_vector (3 DOWNTO 0) := "1111" ;
	
	CONSTANT nop	 : std_logic_vector (3 DOWNTO 0) := "0000" ;
	CONSTANT hlt		 : std_logic_vector (3 DOWNTO 0) := "0001" ;
	CONSTANT szf		 : std_logic_vector (3 DOWNTO 0) := "0010" ;
	CONSTANT czf		 : std_logic_vector (3 DOWNTO 0) := "0011" ;
	CONSTANT scf 	 : std_logic_vector (3 DOWNTO 0) := "0100" ;
	CONSTANT ccf 	 : std_logic_vector (3 DOWNTO 0) := "0101" ;
	CONSTANT cwp	 : std_logic_vector (3 DOWNTO 0) := "0110" ;
	CONSTANT jpr 	 : std_logic_vector (3 DOWNTO 0) := "0111" ;
	CONSTANT brz 	 : std_logic_vector (3 DOWNTO 0) := "1000" ;
	CONSTANT brc	 : std_logic_vector (3 DOWNTO 0) := "1001" ;
	CONSTANT awp	 : std_logic_vector (3 DOWNTO 0) := "1010" ;
	
	CONSTANT mvr	 : std_logic_vector (3 DOWNTO 0) := "0001" ;
	CONSTANT lda	 : std_logic_vector (3 DOWNTO 0) := "0010" ;
	CONSTANT sta 	 : std_logic_vector (3 DOWNTO 0) := "0011" ;
	CONSTANT inp 	 : std_logic_vector (3 DOWNTO 0) := "0100" ;
	CONSTANT oup	 : std_logic_vector (3 DOWNTO 0) := "0101" ;
	CONSTANT anl	 : std_logic_vector (3 DOWNTO 0) := "0110" ;
	CONSTANT orr	 : std_logic_vector (3 DOWNTO 0) := "0111" ;
	CONSTANT nol	 : std_logic_vector (3 DOWNTO 0) := "1000" ;
	CONSTANT shl 	 : std_logic_vector (3 DOWNTO 0) := "1001" ;
	CONSTANT shr   	 : std_logic_vector (3 DOWNTO 0) := "1010" ;
	CONSTANT add  	 : std_logic_vector (3 DOWNTO 0) := "1011" ;
	CONSTANT sub  	 : std_logic_vector (3 DOWNTO 0) := "1100" ;
	CONSTANT mul  	 : std_logic_vector (3 DOWNTO 0) := "1101" ;
	CONSTANT cmp  	 : std_logic_vector (3 DOWNTO 0) := "1110" ;
	
	CONSTANT mil  	 : std_logic_vector (1 DOWNTO 0) := "00" ;
	CONSTANT mih  	 : std_logic_vector (1 DOWNTO 0) := "01" ;
	CONSTANT spc  	 : std_logic_vector (1 DOWNTO 0) := "10" ;
	CONSTANT jpa  	 : std_logic_vector (1 DOWNTO 0) := "11" ;
	
	--signal ShadowEn : std_logic ;
--	signal Regd_MemDataReady : std_logic ;




	

begin 

--	ShadowEn <= '0' when Instruction (7 downto 0 ) = "00001111" else '1' ; 
	
	process ( Instruction , current_state , ExternalReset , Cflag , Zflag , memDataReady) 
  begin	
		ResetPC 			   <= '0' ;
		PCplusI 			   <= '0' ;
		PCplus1 			   <= '0' ;
		RplusI 				   <= '0' ;
		Rplus0  			   <= '0' ;
		EnablePC 			   <= '0' ;
		B15to0 				   <= '0' ;
		AandB 				   <= '0' ;
		AorB 				   <= '0' ;
		notB 				   <= '0' ;
		shrB 				   <= '0' ;
		shlB 				   <= '0' ;
		AaddB  				   <= '0' ;
		AsubB 				   <= '0' ;
		AmulB  				  <= '0' ;
		AcmpB  				   <= '0' ;
		RFLwrite			   <= '0' ;
		RFHwrite 			   <= '0' ;
		WPreset				   <= '0' ;
		WPadd				   <= '0' ;
		IRload 				   <= '0' ;
		SRload  			   <= '0' ;
		Address_on_Databus 	   <= '0' ;
		ALU_on_Databus 		   <= '0' ;
		IR_on_LOpndBus 		   <= '0' ;
		IR_on_HOpndBus		   <= '0' ;
		RFright_on_OpndBus 	   <= '0' ;
		ReadMem 			   <= '0' ;
		WriteMem 			   <= '0' ;
		ReadIO 				   <= '0' ;
		WriteIO 			   <= '0' ;
		Shadow				   <= '0' ;
		Cset				   <= '0' ;
		Creset				   <= '0' ;
		Zset				   <= '0' ;
		Zreset				   <= '0' ;
		Rs_on_AddressUnitRSide <= '0' ;
		Rd_on_AddressUnitRSide <= '0' ;
		
	--	if Instruction (7 downto 0 ) = "00001111" then 
		--  ShadowEn <= '0' ;
		--else
		--  ShadowEn <= '1' ; 
	--	end if ; 
		
		
		case current_state is 
			
			when reset => 
					if ExternalReset ='1' then 
						WPreset <= '1' ;
						ResetPC <= '1' ;
						EnablePC <= '1' ; 
						Creset <= '1' ; 
						Zreset <= '1' ; 
						next_state <= reset ; 
					
					else
						next_state <= fetch ;
					end if ; 
					
			when halt   => 	
					if  ExternalReset = '1' then 
						next_state <= fetch ;
					else 
						next_state <= halt ; 
					end if ; 
			
			when fetch => 
					if ExternalReset = '1' then 
						next_state <= reset ;
					else
						ReadMem <= '1' ; 
						
						next_state <= memread ; 
					end if ; 
			
			when memread =>
					if ExternalReset ='1' then 
						next_state <= reset ; 
					else 
						--if memDataReady = '0' then  -- nafahmiadam 
						--	ReadMem <= '1' ; 
						--	next_state <= memread ; 
						--else 
						--ReadMem <= '1' ; 
						IRload <= '1' ; 
						next_state <= exec1 ; 
						--end if ;
					end if ; 
			
			when exec1 => 
					if ExternalReset = '1' then 
						next_state <= reset ;
					else
						case Instruction (15 downto 12) is
							when b0000 => 
								case Instruction (11 downto 8 ) is 
									when nop  => 
											if ShadowEn = '1' then 
													next_state <= exec2 ; 
											else 
												PCplus1 <= '1' ; 
												EnablePC <= '1' ; 
												next_state <= fetch ;
											end if ; 
											
									when hlt =>
											next_state <= halt ; 
									
									when szf => 
											Zset <= '1'; 
											if ShadowEn = '1' then 
													next_state <= exec2 ;
											else 
												PCplus1 <= '1' ; 
												EnablePC <= '1' ; 
												next_state <= fetch ;
											end if ; 
											
									when czf => 
											Zreset <= '1' ; 
											if ShadowEn = '1' then 
													next_state <= exec2 ;
											else 
												PCplus1 <= '1' ; 
												EnablePC <= '1' ; 
												next_state <= fetch ;
											end if ; 
											
									when scf => 
											Cset <= '1' ; 
											if ShadowEn = '1' then 
													next_state <= exec2 ;
											else 
												PCplus1 <= '1' ; 
												EnablePC <= '1' ; 
												next_state <= fetch ;
											end if ; 
											
									when ccf =>
											Creset <= '1' ;
											if ShadowEn = '1' then 
													next_state <= exec2 ;
											else 
												PCplus1 <= '1' ; 
												EnablePC <= '1' ; 
												next_state <= fetch ;
											end if ;
									
									when cwp =>
											WPreset <= '1' ;
											if ShadowEn = '1' then 
													next_state <= exec2 ;
											else 
												PCplus1 <= '1' ; 
												EnablePC <= '1' ; 
												next_state <= fetch ;
											end if ; 
											
									when jpr => 
											PCplusI <= '1' ; 
											EnablePC <= '1' ; 
											next_state <= fetch ;
											
									when brz => 
											if Zflag ='1' then 
												PCplusI <= '1' ; 
												EnablePC <= '1' ; 
											else 
												PCplus1 <= '1' ; 
												EnablePC <= '1' ; 
											end if ;
											next_state <= fetch ;
										
									when brc => 
											if Cflag ='1' then 
												PCplusI <= '1' ; 
												EnablePC <= '1' ; 
											else 
												PCplus1 <= '1' ; 
												EnablePC <= '1' ; 
											end if ;
											next_state <= fetch ;
											
									when awp => 
											PCplus1 <= '1' ;
											EnablePC <= '1' ; 
											WPadd <= '1' ; 
											next_state <= fetch ; 
									when others => 
											PCplus1 <= '1' ;
											EnablePC <= '1' ;  
											next_state <= fetch  ;
								
								end case ; 
								
							when mvr =>
									RFright_on_OpndBus<= '1' ; 
									B15to0 <= '1' ; 
									ALU_on_Databus <= '1' ; 
									RFLwrite <= '1'; 
									RFHwrite <='1' ;
									SRload <= '1' ;     ----------------------------------------------why !!!!??????????????????
									
									if ShadowEn = '1' then 
										next_state <= exec2 ;
									else 
										PCplus1 <= '1' ; 
										EnablePC <= '1' ; 
										next_state <= fetch ;
									end if ;
									
							when lda => 
									Rplus0 <= '1'; 
									Rs_on_AddressUnitRSide <= '1' ; 
									ReadMem <= '1' ;
									next_state <= exec1lda ;
									
							when sta => 
									Rplus0 <= '1' ; 
									Rd_on_AddressUnitRSide <= '1' ;   
									RFright_on_OpndBus <= '1'  ; 
									B15to0 <= '1' ; 
									ALU_on_Databus <= '1' ;
									WriteMem <= '1' ; 
									next_state <= exec1sta ;
							when inp => 
									Rplus0 <= '1' ; 
									Rs_on_AddressUnitRSide <= '1' ; 
									ReadIO <='1' ; 
									RFLwrite <= '1' ; 
									RFHwrite <= '1'  ;
									SRload <= '1' ; 
									if ShadowEn = '1' then 
										next_state <= exec2 ; 
									else 
										next_state <= incpc ; 
									end if ; 
							when oup => 
									Rplus0 <= '1' ; 
									Rd_on_AddressUnitRSide <= '1' ; 
									B15to0 <= '1' ; 
									ALU_on_Databus<= '1' ; 
									WriteIO <= '1' ; 
									if ShadowEn = '1' then 
										next_state <= exec2 ; 
									else 
										next_state <= incpc ;
									end if ; 
									
							when anl => 
									RFright_on_OpndBus <= '1' ;
									AandB <= '1' ; 
									ALU_on_Databus <= '1' ;
									RFLwrite <= '1' ; 
									RFHwrite <= '1' ; 
									SRload <= '1' ; 
									if ShadowEn = '1' then 
										next_state <= exec2 ; 
									else 
									  RFLwrite <= '1' ;
									RFHwrite <='1' ; 
										PCplus1 <= '1' ; 
										EnablePC <= '1' ; 
										next_state <= fetch ; 
									end if ; 
									
							when orr  =>
									RFright_on_OpndBus <= '1' ;
									AorB <= '1' ; 
									ALU_on_Databus <= '1' ;
									RFLwrite <= '1' ; 
									RFHwrite <= '1' ; 
									SRload <= '1' ; 
									if ShadowEn = '1' then 
										next_state <= exec2 ; 
									else 
										PCplus1 <= '1' ; 
										EnablePC <= '1' ; 
										next_state <= fetch ; 
									end if ;
							
							when nol => 
									RFright_on_OpndBus <= '1' ;
									notB<= '1' ; 
									ALU_on_Databus <= '1' ;
									RFLwrite <= '1' ; 
									RFHwrite <= '1' ; 
									SRload <= '1' ; 
									if ShadowEn = '1' then 
										next_state <= exec2 ; 
									else 
										PCplus1 <= '1' ; 
										EnablePC <= '1' ; 
										next_state <= fetch ; 
									end if ; 
									
							when shl => 
									RFright_on_OpndBus <= '1' ;
									shlB <= '1' ; 
									ALU_on_Databus <= '1' ;
									RFLwrite <= '1' ; 
									RFHwrite <= '1' ; 
									SRload <= '1' ; 
									if ShadowEn = '1' then 
										next_state <= exec2 ; 
									else 
										PCplus1 <= '1' ; 
										EnablePC <= '1' ; 
										next_state <= fetch ; 
									end if ; 
									
							when shr => 
									RFright_on_OpndBus <= '1' ;
									shrB <= '1' ; 
									ALU_on_Databus <= '1' ;
									RFLwrite <= '1' ; 
									RFHwrite <= '1' ; 
									SRload <= '1' ; 
									if ShadowEn = '1' then 
										next_state <= exec2 ; 
									else 
										PCplus1 <= '1' ; 
										EnablePC <= '1' ; 
										next_state <= fetch ; 
									end if ; 
									
							when add => 
									RFright_on_OpndBus <= '1' ;
									AaddB <= '1' ; 
									ALU_on_Databus <= '1' ;
									RFLwrite <= '1' ; 
									RFHwrite <= '1' ; 
									SRload <= '1' ; 
									if ShadowEn = '1' then 
										next_state <= exec2 ; 
									else 
										PCplus1 <= '1' ; 
										EnablePC <= '1' ; 
										next_state <= fetch ; 
									end if ; 
									
							when sub => 
									RFright_on_OpndBus <= '1' ;
									AsubB <= '1' ; 
									ALU_on_Databus <= '1' ;
									RFLwrite <= '1' ; 
									RFHwrite <= '1' ; 
									SRload <= '1' ; 
									if ShadowEn = '1' then 
										next_state <= exec2 ; 
									else 
										PCplus1 <= '1' ; 
										EnablePC <= '1' ; 
										next_state <= fetch ; 
									end if ; 
									
							when mul => 
									RFright_on_OpndBus <= '1' ;
									AmulB <= '1' ; 
									ALU_on_Databus <= '1' ;
									RFLwrite <= '1' ; 
									RFHwrite <= '1' ; 
									SRload <= '1' ; 
									if ShadowEn = '1' then 
										next_state <= exec2 ; 
									else 
										PCplus1 <= '1' ; 
										EnablePC <= '1' ; 
										next_state <= fetch ; 
									end if ; 
							
							when cmp => 
									RFright_on_OpndBus <= '1' ;
									AcmpB <= '1' ; 
									SRload <= '1' ;
									if ShadowEn = '1' then 
										next_state <= exec2 ; 
									else 
										PCplus1 <= '1' ; 
										EnablePC <= '1' ; 
										next_state <= fetch ; 
									end if ; 
									
							when b1111 =>
									case Instruction (9 downto 8) is
										when mil =>
												IR_on_LOpndBus <= '1' ;
												ALU_on_Databus <= '1' ;
												B15to0 <= '1' ; 
												RFLwrite <= '1' ; 
												SRload <= '1' ; 
												PCplus1 <= '1' ;
												EnablePC <= '1' ;
												next_state <= fetch ; 
												
										when mih => 
												IR_on_HOpndBus <= '1' ;
												ALU_on_Databus <= '1' ;
												B15to0 <= '1' ; 
												RFHwrite <= '1' ; 
												SRload <= '1' ; 
												PCplus1 <= '1' ;
												EnablePC <= '1' ;
												next_state <= fetch ;
										when spc => 
												PCplusI <= '1' ; 
												Address_on_Databus <= '1' ; 
												RFLwrite <= '1' ; 
												RFHwrite <= '1' ; 
												EnablePC <= '1' ; 
												next_state <= fetch ; 
												
										when jpa => 
												Rd_on_AddressUnitRSide <= '1' ; 
												RplusI <= '1' ; 
												EnablePC <= '1' ; 
												next_state <= fetch ;
													
										when others =>
												next_state <= fetch ;
				
									end case ;	

							when others =>
									next_state <= fetch ;
									
						end case ;
					end if ; 
			
			
			when exec1lda =>
					if ExternalReset = '1' then 
						next_state <= reset ; 
					else 
						--if memDataReady = '0' then 
						--	Rplus0 <= '1' ; 
						--	Rs_on_AddressUnitRSide <= '1' ;
							--ReadMem <= '1' ;
						--	RFLwrite <= '1' ;
						--	RFHwrite <= '1' ; 
						--	next_state <= exec1lda ;
						
							if ShadowEn = '1' then 
								next_state <= exec2 ; 
							else 
							  
							 
									 RFLwrite <= '1' ; 
									RFHwrite <= '1' ; 
								PCplus1 <= '1' ; 
								EnablePC <= '1' ; 
								next_state <= fetch ; 
							end if ; 
	
						 

					end if ; 
			
			
			when exec1sta => 
					if ExternalReset = '1' then 
						next_state <= reset ; 
					else 
					--	if memDataReady = '0' then
						--	Rplus0 <= '1' ;
							--Rd_on_AddressUnitRSide <= '1' ;
						--	RFright_on_OpndBus <= '1' ;
						--	B15to0 <='1' ; 
						--	ALU_on_Databus <='1' ; 
						--	WriteMem <= '1' ; 
					--		next_state <= exec1sta ;
					--	else 
							if ShadowEn = '1' then 
								next_state <= exec2 ; 
							else 
							   
								next_state <= incpc ; 
							end if ; 
					--	end if ; 
					end if ; 
			
			when exec2 =>
		
					Shadow <= '1' ;
					if ExternalReset = '1' then 
						next_state <= reset ;
					else
						case Instruction (7 downto 4) is
							when b0000 => 
								case Instruction (3 downto 0 ) is  					
									when hlt =>
											next_state <= halt ; 
									
									when szf => 
											Zset <= '1'; 
											PCplus1 <= '1' ; 
											EnablePC <= '1' ; 
											next_state <= fetch ;
									
											
									when czf => 
											Zreset <= '1' ; 
											PCplus1 <= '1' ; 
											EnablePC <= '1' ; 
											next_state <= fetch ;

											
									when scf => 
											Cset <= '1' ; 
											PCplus1 <= '1' ; 
											EnablePC <= '1' ; 
											next_state <= fetch ;

											
									when ccf =>
											Creset <= '1' ;
											PCplus1 <= '1' ; 
											EnablePC <= '1' ; 
											next_state <= fetch ;

											
									when cwp =>
											WPreset <= '1' ;
											PCplus1 <= '1' ; 
											EnablePC <= '1' ; 
											next_state <= fetch ;

											
									when others => 
											PCplus1 <= '1' ;
											EnablePC <= '1' ;  
											next_state <= fetch  ;
								
								end case ; 
								
							when mvr =>
									RFright_on_OpndBus<= '1' ; 
									B15to0 <= '1' ; 
									ALU_on_Databus <= '1' ; 
									RFLwrite <= '1'; 
									RFHwrite <='1' ;
									SRload <= '1' ;     
									PCplus1 <= '1' ; 
									EnablePC <= '1' ; 
									next_state <= fetch ;

									
							when lda => 
									Rplus0 <= '1'; 
									Rs_on_AddressUnitRSide <= '1' ; 
									ReadMem <= '1' ; 
									
									next_state <= exec2lda ;
									
							when sta => 
									Rplus0 <= '1' ; 
									Rd_on_AddressUnitRSide <= '1' ;  
									RFright_on_OpndBus <= '1'  ; 
									B15to0 <= '1' ; 
									ALU_on_Databus <= '1' ;
									WriteMem <= '1' ; 
									next_state <= exec2sta ;
									
							when inp => 
									Rplus0 <= '1' ; 
									Rs_on_AddressUnitRSide <= '1' ; 
									ReadIO <='1' ; 
									RFLwrite <= '1' ; 
									RFHwrite <= '1'  ;
									SRload <= '1' ; 
									next_state <= incpc ; 
									 
							when oup => 
									Rplus0 <= '1' ; 
									Rd_on_AddressUnitRSide <= '1' ; 
									B15to0 <= '1' ; 
									ALU_on_Databus<= '1' ; 
									WriteIO <= '1' ; 
									next_state <= incpc ;
									
							when anl => 
									RFright_on_OpndBus <= '1' ;
									AandB <= '1' ; 
									ALU_on_Databus <= '1' ;
									RFLwrite <= '1' ; 
									RFHwrite <= '1' ; 
									SRload <= '1' ; 
									PCplus1 <= '1' ; 
									EnablePC <= '1' ; 
									next_state <= fetch ; 
									
							when orr  =>
									RFright_on_OpndBus <= '1' ;
									AorB <= '1' ; 
									ALU_on_Databus <= '1' ;
									RFLwrite <= '1' ; 
									RFHwrite <= '1' ; 
									SRload <= '1' ; 
									PCplus1 <= '1' ; 
									EnablePC <= '1' ; 
									next_state <= fetch ; 
							
							when nol => 
									RFright_on_OpndBus <= '1' ;
									notB<= '1' ; 
									ALU_on_Databus <= '1' ;
									RFLwrite <= '1' ; 
									RFHwrite <= '1' ; 
									SRload <= '1' ; 
									PCplus1 <= '1' ; 
									EnablePC <= '1' ; 
									next_state <= fetch ; 
									
							when shl => 
									RFright_on_OpndBus <= '1' ;
									shlB <= '1' ; 
									ALU_on_Databus <= '1' ;
									RFLwrite <= '1' ; 
									RFHwrite <= '1' ; 
									SRload <= '1' ; 
									PCplus1 <= '1' ; 
									EnablePC <= '1' ; 
									next_state <= fetch ; 
									
							when shr => 
									RFright_on_OpndBus <= '1' ;
									shrB <= '1' ; 
									ALU_on_Databus <= '1' ;
									RFLwrite <= '1' ; 
									RFHwrite <= '1' ; 
									SRload <= '1' ; 
									PCplus1 <= '1' ; 
									EnablePC <= '1' ; 
									next_state <= fetch ; 
									
							when add => 
									RFright_on_OpndBus <= '1' ;
									AaddB <= '1' ; 
									ALU_on_Databus <= '1' ;
									RFLwrite <= '1' ; 
									RFHwrite <= '1' ; 
									SRload <= '1' ; 
									PCplus1 <= '1' ; 
									EnablePC <= '1' ; 
									next_state <= fetch ; 
									
							when sub => 
									RFright_on_OpndBus <= '1' ;
									AsubB <= '1' ; 
									ALU_on_Databus <= '1' ;
									RFLwrite <= '1' ; 
									RFHwrite <= '1' ; 
									SRload <= '1' ; 
									PCplus1 <= '1' ; 
									EnablePC <= '1' ; 
									next_state <= fetch ; 
									
							when mul => 
									RFright_on_OpndBus <= '1' ;
									AmulB <= '1' ; 
									ALU_on_Databus <= '1' ;
									RFLwrite <= '1' ; 
									RFHwrite <= '1' ; 
									SRload <= '1' ; 
									PCplus1 <= '1' ; 
									EnablePC <= '1' ; 
									next_state <= fetch ; 
							
							when cmp => 
									RFright_on_OpndBus <= '1' ;
									AcmpB <= '1' ; 
									SRload <= '1' ;
									PCplus1 <= '1' ; 
									EnablePC <= '1' ; 
									next_state <= fetch ; 

							when others =>
									next_state <= fetch ;
									
						end case ;
					end if ;				
					
			
			when exec2lda => 
					Shadow <= '1' ;
					if ExternalReset = '1' then 
						next_state <= reset ; 
					else 
							RFLwrite <= '1' ;
							RFHwrite <='1' ; 
							PCplus1 <= '1' ; 
							EnablePC <= '1' ; 
							next_state <= fetch ; 
						 
					end if ; 
					
			when exec2sta =>
					Shadow <= '1' ; 
					if ExternalReset = '1' then 
						next_state <= reset ; 
					else 	 
						next_state <= incpc ;  
					end if ; 
					
					
			when incpc => 
					PCplus1 <= '1'  ;
					EnablePC <= '1'  ;
					next_state <= fetch  ;
			
			 
			
		 
			
			when others => 
					next_state <= reset ;
					
	
		end case ;

	end process ;	
	
	process(clk)
	begin
		if clk='1' and clk'event then
			--Regd_MemDataReady <= memDataReady ;
			current_state <= next_state ; 
		end if ; 
	end process ;
		
end RTL ; 