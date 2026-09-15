library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity instr_mem is
    port (pc : in std_logic_vector (31 downto 0);
          instr : out std_logic_vector(31 downto 0));
end;

architecture beh of instr_mem is 
    type rom_t is array (10 downto 0) of std_logic_vector(31 downto 0);
    constant rom: rom_t := (
                            0  => x"c0000e37",
                            1  => x"000e2283",
                            2  => x"0ff2f293",
                            3  => x"00100313",
                            4  => x"006e2223",
                            5  => x"00735393",
                            6  => x"00131313",
                            7  => x"0ff37313",
                            8  => x"00038463",
                            9  => x"00534333",
                            10 => x"fe9ff06f"
                            );
begin 
    instr <= rom (to_integer(unsigned(pc(7 downto 2))));
end;
