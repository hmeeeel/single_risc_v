library ieee;
use ieee.std_logic_1164.all;

entity fdre is
    generic (n : natural := 31);
    port (r, clk : in std_logic;
          d : in std_logic_vector (n downto 0);
          q : out std_logic_vector (n downto 0));
end;

architecture beh of fdre is
signal store : std_logic_vector (n downto 0) := (others => '0');
begin
    process(r, clk, d)
    begin
        if rising_edge(clk) then
            if r = '1' then store <= (others => '0');
            else store <= d;
            end if;
        end if;
    end process;

    q <= store;
end;