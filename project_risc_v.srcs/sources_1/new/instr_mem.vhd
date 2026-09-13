library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity instr_mem is
    port (pc : in std_logic_vector (31 downto 0);
          instr : out std_logic_vector(31 downto 0));
end;

--0x00000000   
--0x00000004  0100
--0x00000008  1000
--0x0000000С  1100

architecture beh of instr_mem is 
    type rom_t is array (3 downto 0) of std_logic_vector(31 downto 0);
    constant rom: rom_t := (
                            0 => x"C0000337",
                            1=> x"00032283",
                            2 => x"00532223",
                            3 => x"FF5FF06F");
begin 
    instr <= rom (to_integer(unsigned(pc(3 downto 2))));
end;
