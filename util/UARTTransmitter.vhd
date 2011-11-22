library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

-- Dependencies: clkdiv.vhd (Generic clock division entity)
-- This entity represents an UART transmitter working in 8N1 mode with default 9600 bauds
-- In order to set the baudrate, set the CLOCKDIVRATIO generic to <master clock freq>/<desired baudrate>
-- The default is 9600 baud for a 100 MHz master clock
--
-- Usage: Connect UART_OUT to the pin/signal you want the UART output at
--	      DATA_IN is the next byte to transmit.
--	      The transmission is started on the TX_TRIGGER rising edge
--	      Note that the DATA_IN vector is not copied internally to save logic elements - therefore
--	        you must not override it before the transmission has been finished
--	      When the transmission has been finished, the TX_FINISHED output is driven high, so
-- 	        so you can use the rising_edge condition to get notified of the transmission finish.
--	      Note: It's not guaranteed that the current transaction is finished if TX_FINISHED = '1'.
-- 		Please use the rising_edge condition.
entity UARTTransmitter is
 generic (CLOCKDIVRATIO : integer := 10417);  -- Divisor
 port (CLK : in  STD_LOGIC;
		 DATA_IN : in STD_LOGIC_VECTOR (7 downto 0);
		 TX_TRIGGER : in STD_LOGIC;
		 TX_FINISHED : out STD_LOGIC;
		 UART_OUT : out STD_LOGIC
		 );
end UART;

architecture Behavioral of UARTTransmitter is
signal uartClock : std_logic;

-- Set by the transmitter process:
signal startTransmission : std_logic;
signal transmissionFinished : std_logic;
signal transmissionInProgress : std_logic;

begin
-- Update the seven segment content with 2 Hz frequency
uartClockGenerator : entity work.clkdiv generic map (DIVRATIO => CLOCKDIVRATIO)
	port map ( clkin => clk,
				  clkout => uartClock);
-- Starts the transmission when the data is changed
dataListener : process(clk)
begin
	if rising_edge(TX_TRIGGER) then
		TX_FINISHED <= '0';
		startTransmission <= '1';
	end if;
	-- Reset the start transmission signal
	if startTransmission = '1' and transmissionInProgress = '1' then
		startTransmission <= '0';
	end if;
	-- Set the TX finished signal if neccessary
	if transmissionFinished <= '1' then
		TX_FINISHED <= '1';
	end if;
end process;

-- Assigns a value to the UARTTransmitter output depending on the current state
txProcess : process(uartClock)
variable bitCounter : integer range 0 to 8 := 0;
begin
	if rising_edge(uartClock) then
		-- Start on the transmission start signal
		if startTransmission = '1' then
			transmissionInProgress <= '1';
			transmissionFinished <= '0';
			bitCounter := 0;
			UART_OUT <= '0';
		end if;
		-- Transmit the bits if neccessary
		if transmissionInProgress = '1' then
			UART_OUT <= DATA_IN(bitCounter);
			-- Check for counter overflow
			if bitCounter = 8 then
				UART_OUT <= '1';
				transmissionFinished <= '1';
				transmissionInProgress <= '0';
			else
				bitCounter := bitCounter + 1;
			end if;
		end if;
	end if;
end process;

end Behavioral;