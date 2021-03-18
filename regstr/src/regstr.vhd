--some-fin tuna-ble

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity regstr is
    Port ( clk_in : in STD_LOGIC;
           sound_out : out STD_LOGIC;
           start, enable : in STD_LOGIC; --enable and ready from ADC
           data_in: in STD_LOGIC_VECTOR(15 downto 0); --data in from ADC
           drpaddress: out STD_LOGIC_VECTOR(6 downto 0); --adress for ADC
           di_out: out STD_LOGIC_VECTOR(15 downto 0); -- port on ADC
           dwe_out: out STD_LOGIC; -- port on ADC tied low
           VN_OUT, VP_OUT: out STD_LOGIC; -- port on ADC tied low
           reseter: out STD_LOGIC -- port on ADC tied low
           );
end regstr;

architecture Behavioral of regstr is
    
    signal databuffer_d, databuffer_q: STD_LOGIC_VECTOR(15 downto 0);
    signal counter_d, counter_q: UNSIGNED(15 downto 0);
     -- for counting to 1/2 period of square wave
    signal wav_d, wav_q: STD_LOGIC; --nodes for square wave register
    -- setting up nodes
    
begin

--ports for XADC
drpaddress <= "0011110";
di_out <= "0000000000000000";
dwe_out <= '0';
VN_OUT <= '0';
VP_OUT <= '0';
reseter <= '0';


    process(clk_in, databuffer_d) begin
        if(clk_in'event and clk_in ='1') then --on every rising clock edge
            databuffer_q <= databuffer_d; --copy d to q in databuffer
            counter_q <= counter_d; --copy d to q in counter
            wav_q <= wav_d; --remembers square wave value
        end if;
    end process;
    
databuffer_d <= data_in when start = '1' else --output from adc is put on data buffer when signal is converted
                databuffer_q;

counter_d <= counter_q +1 when counter_q < unsigned(databuffer_q) else
             to_unsigned(0,16); -- counts up by one when below 1/2 period (otherwise resets)
             --1/2 period ~ is controlled by the voltage read from the ADC
             
wav_d <= not(wav_q) when counter_d = to_unsigned(0,16) and counter_q > to_unsigned(0,16) else
         wav_q; --flips the signal at each 1/2 period (i.e., when counter is reset)

sound_out <= wav_d;
                            

end Behavioral;