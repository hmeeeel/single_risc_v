library ieee;
use ieee.std_logic_1164.all;

entity mux3 is 
    generic (n : natural := 31);
    port (a, b, c : in std_logic_vector (n downto 0);
          sel : in std_logic_vector (1 downto 0);
          y : out std_logic_vector (n downto 0));
end;

architecture beh of mux3 is 
signal sel_0, sel_1, sel_2 : std_logic;
signal sel_0_t, sel_1_t, sel_2_t, t1, t2, t0 : std_logic_vector (n downto 0);

begin
    sel_0 <= '1' when sel ="00" else '0';
    sel_1 <= '1' when sel = "01" else '0';
    sel_2 <= '1' when sel = "10" else '0';
    
    sel_0_t <= (others => sel_0);
    sel_1_t <= (others => sel_1);
    sel_2_t <= (others => sel_2);
    
    t0 <= sel_0_t and a;
    t1 <= sel_1_t and b;
    t2 <= sel_2_t and c;
    
    y <= t0 xor t1 xor t2;
end;