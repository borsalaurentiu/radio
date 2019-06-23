
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity ram_memory is
    port (Clk : in  STD_LOGIC;
          WE  : in  STD_LOGIC;
          A   : in  STD_LOGIC_VECTOR (3 downto 0);
          DI  : in  STD_LOGIC_VECTOR (7 downto 0);
          DO  : out STD_LOGIC_VECTOR (7 downto 0));
end ram_memory;

architecture Behavioral of ram_memory is
    type ram_type is array (15 downto 0) of STD_LOGIC_VECTOR (7 downto 0);
    signal RAM : ram_type := (others => x"00");
    
begin

    DO <= RAM(to_integer(unsigned(A)));

    process (Clk)
    begin
        if (Clk'event and Clk = '1') then
            if (WE = '1') then
                RAM(to_integer(unsigned(A))) <= DI;
            end if;
        end if;
    end process;
    
end Behavioral;


