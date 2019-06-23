library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;

entity ProiectSSC is
    Port ( Clk     : in  STD_LOGIC;                         -- Clock, frecventa = 100MHz
           Reset   : in  STD_LOGIC;                         -- Buton de reset pentru CPU
           JB      : in  STD_LOGIC_VECTOR (7 downto 4);     -- Port de intrare pentru Pmod
           JA      : out STD_LOGIC_VECTOR (7 downto 0);     -- Port de iesire pentru Arduino
           Anod    : out STD_LOGIC_VECTOR (7 downto 0);     -- Port de iesire pentru anod
           Segment : out STD_LOGIC_VECTOR (7 downto 0);     -- Port de iesire pentru afisor
           Led     : out STD_LOGIC_VECTOR (15 downto 0));   -- Port de iesire pentru diode
end ProiectSSC;

architecture Behavioral of ProiectSSC is
constant Perioada       : integer := 10**8;                             -- Perioada pentru divizorul de frecventa -> 1s
signal Pozitie_led      : integer := 0;                                 -- Pozitia ledului la adresa caruia se salveaza frecventa
signal Clk_1Hz          : STD_LOGIC;                                    -- Semnal de ceas cu frecventa de 1Hz
signal ResetP, WE       : STD_LOGIC := '0';                             -- Semnal de reset pentru CPU si WriteEnable pentru memoria RAM
signal FWD, REV         : STD_LOGIC := '0';                             -- Sensul de rotatie al comutatorului rotativ
signal Frecventa_16     : STD_LOGIC_VECTOR (31 downto 0);               -- Frecventa de afisat in baza 16
signal Frecventa_10     : STD_LOGIC_VECTOR (31 downto 0);               -- Frecventa de afisat in baza 10
signal Count_4stari     : STD_LOGIC_VECTOR (15 downto 0) := x"0001";    -- Counter incrementat/decrementat la fiecare schimbare de stare a comutatorului rotativ
signal Adresa_memorie   : STD_LOGIC_VECTOR (5 downto 0) := b"000001";   -- Adresa de scriere pentru memoria RAM
signal Memorie_output   : STD_LOGIC_VECTOR (7 downto 0);                -- Valoarea citita din memoria RAM
signal Frecventa_output : STD_LOGIC_VECTOR (7 downto 0);                -- Counter incrementat/decrementat la fiecare ciclu de patru stari al comutatorului rotativ

begin

    ResetP <= not Reset;
    Frecventa_output <= Count_4stari(9 downto 2);
    
    Pozitie_led <= conv_integer(Adresa_memorie(5 downto 2)); 
    
    Frecventa_16 <= x"0000036B" + (x"0000" &  Frecventa_output) when JB(7) = '0' else   --  |---- 087.5| <-> |---- 113.0| 
                    x"0000036B" + (x"0000" &  Memorie_output);

    JA <= Frecventa_output when JB(7) = '0' else    -- Trimite 0 - 255 catre Arduino
          Memorie_output;          
            
    pozitie_leduri: process(Pozitie_led, JB(7))             -- Se aprinde ledul pozitiei la care se memoreaza o frecventa, iar celelalte se sting
    begin 
        if (JB(7) = '1') then
            for i in 0 to 15 loop
                if (i = Pozitie_led) then
                    Led(i) <= '1';
                else
                    Led(i) <= '0';
                end if;      
            end loop;
        else
            Led <= x"0000";
        end if;
    end process;
                      
    frecventa_1Hz: process(Clk_1Hz)                        -- La fiecare secunda, daca comutatorul rotativ este apasat, se activeaza WriteEnable
    begin
        if (Clk_1Hz'event and Clk_1Hz = '1') then
            if(JB(6) = '1') then
                WE <= '1';
            else
                WE <= '0';
            end if;  
        end if; 
    end process;                  
                
    numarator: process(Clk, JB(7))                     -- Se numara in functie de starile comutatorului rotativ
    begin
        if (Clk'event and Clk = '1') then
            if(JB(7) = '0') then
                if(FWD = '1') then
                    Count_4stari <= Count_4stari - 1;
                end if;
                if(REV = '1') then
                    Count_4stari <= Count_4stari + 1;
                end if;
            else
                if(FWD = '1') then
                    Adresa_memorie <= Adresa_memorie - 1;
                end if;
                if(REV = '1') then
                    Adresa_memorie <= Adresa_memorie + 1;
                end if;
            end if;
        end if;
    end process;

	display: entity WORK.displ7seg port map (
                      Clk     => Clk,
                      Reset   => ResetP,
                      Data    => Frecventa_10,
                      Anod    => Anod,
                      Segment => Segment);
    
    convertor: entity WORK.display_decimal port map (
                      D_in  => Frecventa_16,
                      Q_out => Frecventa_10);

    rotary_encoder: entity WORK.rotary_encoder port map (
                      Clk => Clk,
                      A   => JB(4),
                      B   => JB(5),
                      FWD => FWD,
                      REV => REV); 
                      
    memorie_ram: entity WORK.ram_memory port map (
                      Clk => Clk,
                      WE  => WE,
                      A   => Adresa_memorie(5 downto 2),
                      DI  => Frecventa_output,
                      DO  => Memorie_output); 
    
    divizor_de_frecventa: entity WORK.frequency port map (
                      Clk      => Clk,
                      Perioada => Perioada,
                      Clk_1Hz  => Clk_1Hz); 
    
end Behavioral;