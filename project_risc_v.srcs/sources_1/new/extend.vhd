library ieee;
use ieee.std_logic_1164.all;

entity extend is
    port ( s : in std_logic_vector (2 downto 0);
           instr : in std_logic_vector (31 downto 7);
           y : out std_logic_vector (31 downto 0));
end;

architecture beh of extend is
    signal sgn : std_logic_vector(19 downto 0);
begin

    sgn <= (others => instr(31));
    with s select
        y <= sgn & instr(31 downto 20)                                                       when "000", -- I
             sgn & instr(31 downto 25) & instr(11 downto 7)                                  when "001", -- S
             instr(31 downto 12) & X"000"                                                    when "010", -- U
             sgn(11 downto 0) & instr(19 downto 12) & instr(20) & instr(30 downto 21) & '0'  when "011", -- J
             sgn & instr(7) & instr(30 downto 25) & instr(11 downto 8) & '0'                 when "100", -- B
             (others => '0')                                                                 when others;
end;    