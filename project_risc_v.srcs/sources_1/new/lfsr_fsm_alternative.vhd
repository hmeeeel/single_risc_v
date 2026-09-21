library ieee;
use ieee.std_logic_1164.all;

entity lfsr_fsm_alternative is
    port (
        clk, reset : in std_logic;
        x0, x1, x2, x3: in std_logic;
        lw_ai, lw_seed, state_xor,state_sll : out std_logic);
end;

architecture beh of lfsr_fsm_alternative is
    type state_type is (IDLE, RUN);
    signal current_state, next_state : state_type;
begin

    process(clk)
    begin
        if rising_edge(clk) then
            if reset = '1' then
                current_state <= IDLE;
            else
                current_state <= next_state;
            end if;
        end if;
    end process;

    process(current_state, x1)
    begin
        next_state <= current_state;
        if current_state = IDLE and x1 = '1' then
            next_state <= RUN;
        end if;
    end process;

    process(current_state, x0, x1, x2, x3)
    begin
        lw_ai   <= x0; 
        lw_seed <= x1; 
        
        state_xor <= '0';
        state_sll <= '0';
        
        if current_state = RUN and x2 = '1' then
            if x3 = '1' then
                state_xor <= '1';
            else
                state_sll <= '1';
            end if;
        end if;
    end process;


    --lw_ai     <= '1' when  x0 = '1' else '0';
    --lw_seed   <= '1' when (x0 = '0' and x1 = '1') else '0';
    --state_xor <= '1' when (x0 = '0' and x1 = '0' and x2 = '1' and x3 = '1') else '0';
    --state_sll <= '1' when (x0 = '0' and x1 = '0' and x2 = '1' and x3 = '0') else '0';
end architecture;