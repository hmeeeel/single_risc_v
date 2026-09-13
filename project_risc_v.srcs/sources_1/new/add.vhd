library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

-- 295-299
entity add is
    port (a, b : in std_logic_vector(31 downto 0); 
          s : out std_logic_vector(31 downto 0)); 
end;

architecture beh of add is
begin
   s <= std_logic_vector(unsigned(a)+unsigned(b));
end;
