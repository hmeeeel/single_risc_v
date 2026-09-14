library ieee;
use ieee.std_logic_1164.all;

entity extend is
    port ( s : in std_logic_vector (2 downto 0);
           instr : in std_logic_vector (31 downto 7);
           y : out std_logic_vector (31 downto 0));
end;

architecture beh of extend is
begin
    process (s, instr)
    variable res : std_logic_vector (31 downto 0);
    begin
    case s is

       --I - LW
       --  when "00" => res := ((31 downto 12 => instr(31)) & instr(31 downto 20));
       when "000" => res(31 downto 12) := (others => instr(31));
                    res(11 downto 0) := instr(31 downto 20);

       -- S
       -- when "01" => res := ((31 downto 12 => instr(31)) & instr(31 downto 25) & instr(11 downto 7));
       when "001" => res(31 downto 12) := (others => instr(31));
                    res(11 downto 5) := instr (31 downto 25);
                    res (4 downto 0) := instr (11 downto 7);

        --U
       -- when "10" => res:= instr(31 downto 12) & b"000000000000";
       when "010" => res(31 downto 12) := instr (31 downto 12);
                    res (11 downto 0) := (others => '0');

       --J стр 409
       --when "11" => res:= (31 downto 20 => instr(31)) & instr (19 downto 12) & instr(20) & instr (30 downto 21) & '0';
        when "011" => res (31 downto 20) := (others => instr(31));
                     res (19 downto 12) := instr (19 downto 12);
                     res (11) := instr(20);
                     res(10 downto 1) := instr(30 downto 21);
                     res(0) := '0';

       -- B beq/bne/blt/bge/bltu/bgeu
       when "100" => res(31 downto 12) := (others => instr(31));
            res(11) := instr(7);
            res(10 downto 5) := instr(30 downto 25);
            res(4 downto 1) := instr(11 downto 8);
            res(0) := '0';


       when others => res := (others => '0');
      end case;
      
      y <= res;
    end process;
end;