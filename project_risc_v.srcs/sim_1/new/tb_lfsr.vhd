library ieee;
use ieee.std_logic_1164.all;

entity tb_lfsr is
end;

architecture beh of tb_lfsr is

    component top
        port (
            clk, reset : in std_logic;
            sw_i : in std_logic_vector(15 downto 0);
            led_o : out std_logic_vector(15 downto 0)
        );
    end component;

    constant T : time := 10 ns;

    signal clk, reset : std_logic := '0';
    signal sw_i, led_o : std_logic_vector(15 downto 0);

begin

    DUT : top
        port map (
            clk   => clk,
            reset => reset,
            sw_i  => sw_i,
            led_o => led_o
        );

    clk <= not clk after T / 2;

    process
    begin
        sw_i <= X"008E";
        reset <= '1';
        wait for 2 * T;

        reset <= '0';
        wait for 100 * T;
        wait;

    end process;

end;