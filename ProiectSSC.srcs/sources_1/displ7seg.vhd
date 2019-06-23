library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.all;
use IEEE.STD_LOGIC_ARITH.all;

entity displ7seg is
    Port ( Clk     : in  STD_LOGIC;
           Reset   : in  STD_LOGIC;
           Data    : in  STD_LOGIC_VECTOR (31 downto 0);
           Anod    : out STD_LOGIC_VECTOR (7 downto 0);
           Segment : out STD_LOGIC_VECTOR (7 downto 0));
end displ7seg;

architecture Behavioral of displ7seg is

constant Count     : integer := 2**20;
signal NumarIntreg : integer range 0 to Count - 1 := 0;
signal NumarVector : STD_LOGIC_VECTOR (19 downto 0) := (others => '0');    
signal Selectie    : STD_LOGIC_VECTOR (2 downto 0)  := (others => '0');
signal Hex         : STD_LOGIC_VECTOR (3 downto 0)  := (others => '0');
signal Point       : STD_LOGIC_VECTOR (7 downto 0);

begin

    Point       <= x"7F" when Selectie = "001" else x"FF";
    Selectie    <= NumarVector(19 downto 17);
    NumarVector <= conv_std_logic_vector(NumarIntreg, 20);
    
    Anod <= "11111110" when Selectie = "000" else
            "11111101" when Selectie = "001" else
            "11111011" when Selectie = "010" else
            "11110111" when Selectie = "011" else
            "11101111" when Selectie = "100" else
            "11011111" when Selectie = "101" else
            "10111111" when Selectie = "110" else
            "01111111" when Selectie = "111" else
            "11111111";

    Hex <= Data (3  downto  0) when Selectie = "000" else
           Data (7  downto  4) when Selectie = "001" else
           Data (11 downto  8) when Selectie = "010" else
           Data (15 downto 12) when Selectie = "011" else
           Data (19 downto 16) when Selectie = "100" else
           Data (23 downto 20) when Selectie = "101" else
           Data (27 downto 24) when Selectie = "110" else
           Data (31 downto 28) when Selectie = "111" else
           X"0";

    Segment <= "11111001" and Point when Hex = x"1" else            -- 1
               "10100100" and Point when Hex = x"2" else            -- 2
               "10110000" and Point when Hex = x"3" else            -- 3
               "10011001" and Point when Hex = x"4" else            -- 4
               "10010010" and Point when Hex = x"5" else            -- 5
               "10000010" and Point when Hex = x"6" else            -- 6
               "11111000" and Point when Hex = x"7" else            -- 7
               "10000000" and Point when Hex = x"8" else            -- 8
               "10010000" and Point when Hex = x"9" else            -- 9
               "10001000" and Point when Hex = x"A" else            -- A
               "10000011" and Point when Hex = x"B" else            -- b
               "11000110" and Point when Hex = x"C" else            -- C
               "10100001" and Point when Hex = x"D" else            -- d
               "10000110" and Point when Hex = x"E" else            -- E
               "10111111" and Point when Hex = x"F" else            -- -
               "11000000" and Point;                                -- 0

    process (Clk)
    begin
        if (Clk'event and Clk = '1') then
            if (Reset = '1') then
                NumarIntreg <= 0;
            elsif (NumarIntreg = Count - 1) then
                NumarIntreg <= 0;
            else
                NumarIntreg <= NumarIntreg + 1;
            end if;
        end if;
    end process;

end Behavioral;
