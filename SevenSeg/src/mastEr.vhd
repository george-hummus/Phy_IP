--do you hear the endless drumming?

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
--use IEEE.NUMERIC_STD.ALL;

entity mastEr is
    Port ( clk : in STD_LOGIC;
           btnC : in STD_LOGIC;
           seg : out STD_LOGIC_VECTOR (7 downto 0);
           an : out STD_LOGIC_VECTOR (3 downto 0));
end mastEr;

architecture Behavioral of mastEr is
    signal gate : STD_LOGIC;
    signal countconnector : STD_LOGIC_VECTOR (15 downto 0);
begin
    -- btnC is connected to the debouncer. Takes in clk signal and then output is connected to
    -- the gate node
    deBouncer_unit : entity work.deBouncer
        port map(
            clk => clk,
            btn_in => btnC,
            count_out => countconnector
            );
            
            
    --display takes in input from counter and displays a hex no. on the display
    -- corresponding to no. on times button is pressed
    disPlay_unit : entity work.disPlay
        port map(
            clk => clk,
            count_in => countconnector,
            an => an,
            seg => seg
            );

end Behavioral;
