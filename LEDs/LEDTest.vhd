library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity LEDTest is
 Port (CLK : in  STD_LOGIC;
		 LED : out  STD_LOGIC_VECTOR (7 downto 0)
		 );
end LEDTest;

architecture Behavioral of LEDTest is
  signal oneHertzClock : std_logic;
begin
-- Divides the main 100 MHz clock to one hertz -> one state change every half second (50% duty cycle)
oneHertzDiv : entity work.clkdiv generic map (DIVRATIO => 100000000)
	port map ( clkin => clk,
				  clkout => oneHertzClock);
  
-- Switch the LED - both clock states are used, so it blinks every half second
with oneHertzClock select LED <= "00110011" when '0', "11001100" when '1', "11111111" when others;

end Behavioral;
