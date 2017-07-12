library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity portManager is
	generic (blocksize : integer := 64);

	port (clk, ReadIO, WriteIO : in std_logic;
		addressbus: in std_logic_vector (15 downto 0);
		databus : inout std_logic_vector (15 downto 0)
		);
end entity;

architecture behavioral of portManager is
	type mem is array (0 to blocksize - 1) of std_logic_vector (15 downto 0);
begin
  	process (clk)
		variable buffermem : mem := (others => (others => '0'));
		variable ad : integer;
		variable init : boolean := true;
	begin
		if init = true then
	
			-- initialization
			buffermem(0) := "0000000000000110";


     
			init := false;
		end if;

		if  clk'event and clk = '1' then
			ad := to_integer(unsigned(addressbus));

			if ReadIO = '1' then -- Readiing :)
				if ad >= blocksize then
					databus <= (others => 'Z');
				else
					databus <= buffermem(ad);
				end if;
			elsif WriteIO = '1' then -- Writing :)
				
				if ad < blocksize then
					buffermem(ad) := databus;
				end if;
			elsif ReadIO = '0' then
				databus <= (others => 'Z');
			end if;
		end if;
	end process;
end architecture behavioral;
