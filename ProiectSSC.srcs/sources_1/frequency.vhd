library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
use IEEE.NUMERIC_STD.all;

entity frequency is
    Port ( Clk      : in STD_LOGIC;
           Perioada : in integer;
           Clk_1Hz  : out STD_LOGIC);
end frequency;		  

architecture Behavioral of frequency is
signal Count : integer := 1;
signal Q     : STD_LOGIC;

begin    

	Clk_1Hz <= Q;

	process(Clk)
	begin
		if (Clk'event and Clk = '1') then
			Count <= Count + 1;
			if (Count = Perioada) then
				Count <= 1;
				Q <= not Q;
			end if;
		end if;
	end process;

end Behavioral;