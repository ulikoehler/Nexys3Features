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
		 TX_FINISHED : out STD_LOGIC := '1';
		 UART_OUT : out STD_LOGIC := '1'
		 );
end UARTTransmitter;

architecture Behavioral of UARTTransmitter is
component clkdiv
    generic (DIVRATIO : integer := 4);  -- Division ratio
    port (
        clkin     : in std_logic;         -- Input clock
        clkout  : out std_logic         -- Output clock
    );
end component;

signal uartClock : std_logic;
signal state : integer range 0 to 9 := 9;

begin
-- Update the seven segment content with 2 Hz frequency
uartClockGenerator : clkdiv generic map (DIVRATIO => CLOCKDIVRATIO)
	port map ( clkin => clk, clkout => uartClock);

triggerListenerProcess : process(uartClock)
variable txTriggerReset : std_logic; -- Set to true when the TX trigger was set to zero
begin
	if TX_TRIGGER = '1' and state = 9 and txTriggerReset = '1' then
		txTriggerReset := '0';
		TX_FINISHED <= '0';
		state <= 0;
	elsif TX_TRIGGER = '0' then
		txTriggerReset := '1';
	else
		if state = 9 then
			TX_FINISHED <= '1';
		else 
			state <= state + 1;
		end if;
	end if;
end process;

with state select
UART_OUT <= '0' when 0, --start
	    DATA_IN(0) when 1,
	    DATA_IN(1) when 2,
	    DATA_IN(2) when 3,
	    DATA_IN(3) when 4,
	    DATA_IN(4) when 5,
	    DATA_IN(5) when 6,
	    DATA_IN(6) when 7,
	    DATA_IN(7) when 8,
	    '1' when 9; --stop

end Behavioral;
