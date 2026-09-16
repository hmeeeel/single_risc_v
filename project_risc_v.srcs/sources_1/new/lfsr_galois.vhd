library ieee;
use ieee.std_logic_1164.all;

entity lfsr_galois is
    generic (
       POLY: std_logic_vector := x"8E"; --10001110
       N: natural := 8);
    port (
        CLK, CLR, EN  : in  std_logic;
        Din  : in  std_logic_vector (N-1 downto 0);
        Dout : out std_logic_vector (N-1 downto 0)
    );
end;

architecture behav of lfsr_galois is
    constant Ai: std_logic_vector(POLY'reverse_range) := POLY;
    signal d, d_new: std_logic_vector(Ai'range);
    signal feedback, SI: std_logic;
    
   constant SEED : std_logic_vector ( Ai'range ) := (0 => '1', others => '0');
--constant SEED : std_logic_vector ( Ai'range ) := "10001110";
begin
    feedback <= d(Ai'high);

    SREG: process (CLR, CLK, EN, d_new)
    begin
        if rising_edge(CLK) then
            if CLR = '1' then
                d <= SEED;
            elsif EN = '1' then
                d <= d_new;
            end if;
        end if;
    end process;

    PDNEW: process (d, feedback, SI)
        variable vdnew: std_logic_vector(Ai'range);
    begin
       vdnew(0) := feedback;
        
        for i in 0 to Ai'high-1 loop
            if Ai(i) = '1' then
                vdnew(i+1) := feedback xor d(i);
            else
                vdnew(i+1) := d(i);
            end if;
        end loop;
        
        d_new <= vdnew;
    end process;

    Dout <= d;

end;
