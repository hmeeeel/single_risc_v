library ieee;
use ieee.std_logic_1164.all;

entity tb is
end;

architecture beh of tb is
    component top
    port (clk, reset : in std_logic;
          sw_i : in std_logic_vector (15 downto 0);
          led_o : out std_logic_vector (15 downto 0));
    end component;

    constant T : time := 10 ns;
    constant LOOP_T : time := 4 * T; -- 1 проход lui-lw-sw-jal = 4 такта

    signal clk, reset : std_logic := '0';
    signal sw_i, led_o : std_logic_vector(15 downto 0);

begin

    DUT : top port map (clk => clk, reset => reset, sw_i => sw_i, led_o => led_o);

    clk <= not clk after T / 2;

    process
    begin

        sw_i  <= X"FFFF";
        reset <= '1'; --PC=0 LED 0x0000
        wait for 2 * T;
        reset <= '0';
        wait for 1 ns;

        sw_i <= X"0000";
        wait for 2 * LOOP_T;
       
        sw_i <= "0000000000000010";
        wait for 2 * LOOP_T;
        

        sw_i <= X"FFFF";
        wait for 2 * LOOP_T;
       

        wait for T; -- LED = FFFF
       
        -- LED не имеет своего входа reset
        reset <= '1';
        wait for 15 ns; -- LED = FFFF
       
        sw_i <= X"1234"; -- мен  SW прямо во время сброса
        wait for 15 ns;
        
        
        reset <= '0';
        wait for 2 * LOOP_T; -- LED = 1234
    end process;

end;
