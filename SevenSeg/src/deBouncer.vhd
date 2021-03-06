-- George made this, and is very proud

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity deBouncer is
    Port ( clk : in STD_LOGIC;
           btn_in : in STD_LOGIC;
           count_out : out STD_LOGIC_VECTOR (15 downto 0));
end deBouncer;

architecture Behavioral of deBouncer is
   signal counter_d, counter_q : UNSIGNED (15 downto 0); --sets up two nodes for flipflop
   signal counter_in_logic : STD_LOGIC_VECTOR (15 downto 0); 
   -- node to cast value from unsigned interger to std_logic_vector so can be displayed on leds
   signal bstore_d, bstore_q : STD_LOGIC;
   signal second_d, second_q : UNSIGNED (15 downto 0);
   
begin
    process(clk, counter_d, bstore_d,second_d) begin
        if(clk'event and clk='1') then --checks for rising edge on clock
        
        --register for the led counter
            counter_q <= counter_d; -- when rising edge is connected d copied to q
         
        --register for button presses (bstore)
            bstore_q <= bstore_d; 
            
        --flipflop for second counter
            second_q <= second_d;
            
        end if;
    end process;
       
    
bstore_d <= btn_in;


--button counter
counter_d <= counter_q +1 when (btn_in ='1' and bstore_q = '0') and second_q = to_unsigned(0,15) else
             counter_q; -- counts up by one with each rising edge of btnC press and when second counter is zero
             
-- de-bounce counter
second_d <= second_q +1 when (btn_in xor bstore_q) = '1' else
            -- dectects rising or lowering edge of button and starts counting up  
            second_q +1 when (second_q > to_unsigned(0,15)) else
            -- when second counter is above 0 then it continues counting until it reverts to zero again
            second_q; 
            

counter_in_logic <= std_logic_vector(counter_q); --casts q output to logic vector
count_out <= counter_in_logic;

end Behavioral;