-- Good Moooornnnig Vietnam!

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity disPlay is
    Port ( clk : in STD_LOGIC;
           count_in : in STD_LOGIC_VECTOR (15 downto 0);
           an : out STD_LOGIC_VECTOR (3 downto 0);
           seg : out STD_LOGIC_VECTOR (7 downto 0));
end disPlay;

architecture Behavioral of disPlay is

   signal counter_d, counter_q : UNSIGNED (31 downto 0); --sets up two nodes for flipflop
   signal counter_in_logic : STD_LOGIC_VECTOR (31 downto 0); 
   signal anode_select : STD_LOGIC_VECTOR (1 downto 0); -- shows which anode is selected from counter
   signal bin : STD_LOGIC_VECTOR (3 downto 0); --binary word from switches
   signal hex : STD_LOGIC_VECTOR (7 downto 0); --the hexidecimal number to be displayed on 7-seg
   
   
begin --32 bit counter
    process(clk, counter_d) begin --describes the 32-bit flipflop
        if(clk'event and clk='1') then --checks for rising edge on clock
            counter_q <= counter_d; -- when rising edge is connected q copied to d
        end if; -- cant assign d to q outside this process (can do the otherway around tho)
    end process;

counter_d <= counter_q +1; -- counts up by one 

counter_in_logic <= std_logic_vector(counter_q);
anode_select <= counter_in_logic(16 downto 15);
--end of counter

bin <= count_in(3 downto 0) when anode_select = "00" else
       count_in(7 downto 4) when anode_select="01" else
       count_in(11 downto 8) when anode_select="10" else
       count_in(15 downto 12) when anode_select="11" else
       "0000"; --needs to be this way around so the 1st word (0 to 3) is diplayed on rightmost digit etc.

hex <= "11000000" when bin = "0000" else
       "11111001" when bin = "0001" else
       "10100100" when bin = "0010" else
       "10110000" when bin = "0011" else
       "10011001" when bin = "0100" else
       "10010010" when bin = "0101" else
       "10000010" when bin = "0110" else
       "11111000" when bin = "0111" else
       "10000000" when bin = "1000" else
       "10010000" when bin = "1001" else
       "00100011" when bin = "1010" else
       "10000011" when bin = "1011" else
       "10100111" when bin = "1100" else
       "10100001" when bin = "1101" else
       "10000100" when bin = "1110" else
       "10001110" when bin = "1111" else
       "00000000"; --each hex no. for display from 4-bit binary
       -- had to invert as i found these combinations use vectors in from (a to b)
       -- where shoudl be using vectors (b downto a)
       
seg <= hex;

an <= "1110" when anode_select="00" else
      "1101" when anode_select="01" else
      "1011" when anode_select="10" else
      "0111" when anode_select="11" else
      "1111"; --counter addresses each digit individually

end Behavioral;