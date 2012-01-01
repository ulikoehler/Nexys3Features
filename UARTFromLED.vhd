library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

-- This entity (intended as toplevel) transmits the byte set by the eight switches
-- over UART every half second. Additionally all LEDs above the switches mirror the switch state.
entity UARTTransmitterTest is
 Port (CLK : in  STD_LOGIC;
		  UART_TXD : out  STD_LOGIC;
		  LED : out STD_LOGIC_VECTOR(7 downto 0);
		  SW : in STD_LOGIC_VECTOR(7 downto 0)
		 );
end UARTTransmitterTest;

architecture Behavioral of UARTTransmitterTest is
signal data : std_logic_vector(7 downto 0);
signal tx_finished : std_logic;
signal twoHertzClock : std_logic;
begin
				  
-- Update the seven segment content with 2 Hz frequency
twoHertzDiv : entity work.clkdiv generic map (DIVRATIO => 50000000)
	port map ( clkin => clk,
				  clkout => twoHertzClock);
				  
-- Update the UART transmitter data with 2 Hz frequency
-- The data is 
uart : entity work.UART
	port map ( CLK => CLK, DATA_IN => SW, UART_OUT => UART_TXD, TX_FINISHED => tx_finished, TX_TRIGGER => twoHertzClock);

-- Update the LEDs when the switches change
process(clk)
begin
	if rising_edge(clk) then
		LED <= SW;
	end if;
end process;

end Behavioral;
