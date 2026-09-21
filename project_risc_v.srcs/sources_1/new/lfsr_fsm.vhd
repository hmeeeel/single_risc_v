library ieee;
use ieee.std_logic_1164.all;

entity lfsr_fsm is
    port (
        clk, reset : in std_logic;
        x0, x1, x2, x3: in std_logic;
        lw_ai, lw_seed, state_xor, state_sll : out std_logic);
end;

architecture beh of lfsr_fsm is
    type state_type is (S0, S1, S2, S3);
    signal current_state, next_state : state_type;

begin

    process(clk, reset)
    begin
        if reset = '1' then
            current_state <= S0;
        elsif rising_edge(clk) then
            current_state <= next_state;
        end if;
    end process;


    process(current_state, x0, x1, x2)
    begin
        next_state <= current_state;
        
        case current_state is
            when S0 =>
                if x0 = '1' then next_state <= S1;
                end if;
                
            when S1 => next_state <= S2;
                
            when S2 =>
                if x1 = '1' then next_state <= S3;
                end if;
                
            when S3 => null; 
        end case;
    end process;


    process(current_state, x0, x1, x2, x3)
    begin
        lw_ai     <= '0';
        lw_seed   <= '0';
        state_xor <= '0';
        state_sll <= '0';
        
        case current_state is
            when S0 =>
                if x0 = '1' then lw_ai <= '1';
                end if;
                
            when S1 =>null;
                
            when S2 =>
                if x1 = '1' then  lw_seed <= '1';
                end if;
                
            when S3 =>
                if x2 = '1' then
                    if x3 = '1' then
                        state_xor <= '1';
                    else
                        state_sll <= '1';
                    end if;
                end if;
        end case;
    end process;

end;