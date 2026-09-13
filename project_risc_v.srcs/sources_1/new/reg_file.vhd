library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity reg_file is
    generic (
        N: natural := 32;
        A: natural := 5);
    Port (
        CLK, CLR: in  std_logic;
        WE : in  std_logic;
        WA, RA1, RA2 : in  std_logic_vector(A - 1 downto 0);
        WDP: in  std_logic_vector(N - 1 downto 0);
        RDP1, RDP2 : out std_logic_vector(N - 1 downto 0));
end;

architecture beh of reg_file is
    constant M : natural := 2 ** A;
    constant ZEROS : std_logic_vector(N - 1 downto 0) := (others => '0');

    subtype t_reg_word is std_logic_vector(N - 1 downto 0);
    type    t_reg_file is array (1 to M - 1) of t_reg_word;
    signal REG_FILE : t_reg_file := (others => ZEROS);
begin

    pwr: process (CLK)
    begin
    if rising_edge(CLK) then
         if CLR = '1' then
           for i in 1 to m-1 loop -- risc-v
                reg_file(i)<= ZEROS;
            end loop;
            elsif WE = '1' then if to_integer(unsigned(WA)) > 0 then REG_FILE(to_integer(unsigned(WA))) <= WDP; --single write port adress decoder
            end if;
         end if;
    end if;
    end process;
    
    -- double read port 
    --is_x - для симуляции
    RDP2 <= ZEROS when (RA2 = "00000" or is_x(RA2)) else 
            WDP when (WE = '1' and RA2 = WA) else -- конвеерн арх-та
            REG_FILE(to_integer(unsigned(RA2)));
    RDP1 <= ZEROS when (RA1 = "00000" or is_x(RA1)) else WDP when (WE = '1' and RA1 = WA) else REG_FILE(to_integer(unsigned(RA1)));
end;