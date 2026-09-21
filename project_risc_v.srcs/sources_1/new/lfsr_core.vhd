library ieee;
use ieee.std_logic_1164.all;

entity lfsr_core is
    port (state, Ai : in std_logic_vector(7 downto 0);
          feedback : out std_logic;
          state_fb, state_nfb : out std_logic_vector(7 downto 0));
end;

architecture comb of lfsr_core is
begin
    feedback  <= state(7);
    state_fb  <= (state(6 downto 0) & '0') xor Ai;
    state_nfb <= (state(6 downto 0) & '0');
end;