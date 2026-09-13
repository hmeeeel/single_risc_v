library ieee;
use ieee.std_logic_1164.all;

entity mux2 is
    generic (n : natural := 31);
    port (a, b : in std_logic_vector(n downto 0);  
          sel : in std_logic; 
          y : out std_logic_vector(n downto 0) );
end;

architecture beh of mux2 is
signal sel_t, t1, t2  : std_logic_vector(n downto 0);
begin
   -- y <= a when sel = '1' else b;
   
   -- mux = nS*a + S*b
    sel_t <= (others => sel);
    t1 <= sel_t and a;
    t2 <= (not sel_t) and b;
    y <= t1 xor t2;
end;