library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity freq is
    generic (K : unsigned(31 downto 0) := x"00000010");
    port (CLK : in  std_logic;
          RST : in  std_logic;
          EN  : in  std_logic;
          Q   : out std_logic);
end;

architecture beh of freq is
--constant k_t : natural := K/2;
--constant cnt : natural := natural(ceil(log2(real(k_t))))-1;

    constant k_t : unsigned(K'range) := shift_right(K, 1) - 1;
    signal cnt_prev, cnt_nxt : unsigned(K'range) := (others => '0');
    signal q_prev, q_nxt: std_logic := '0';

begin

    process(CLK)
    begin
        if rising_edge(CLK) then
            if RST = '1' then
                cnt_prev <= (others => '0');
                q_prev   <= '0';
            else
                cnt_prev <= cnt_nxt;
                q_prev   <= q_nxt;
            end if;
        end if;
    end process;

    process(cnt_prev, q_prev, EN)
    begin
        cnt_nxt <= cnt_prev;
        q_nxt   <= q_prev;

        if EN = '1' then
            if cnt_prev >= k_t then
                cnt_nxt <= (others => '0');
                q_nxt   <= not q_prev;
            else
                cnt_nxt <= cnt_prev + 1;
            end if;
        end if;
    end process;

    Q <= q_prev;

end;


