library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity UARTReceiver is
 generic (CLOCKDIVRATIO : integer := 10417);  -- Divisor
 port (CLK : in  STD_LOGIC;
		 DATA_OUT : out STD_LOGIC_VECTOR (7 downto 0) := "00000000";
		 DATA_NOTIFIER : out STD_LOGIC := '0';
		 UART_IN : in STD_LOGIC
		 );
end UARTReceiver;

architecture Behavioral of UARTReceiver is
component clkdiv_rst
    generic (DIVRATIO : integer := 10417);  -- Division ratio
    port (
        clkin   : in std_logic;         -- Input clock
	rst	: in std_logic;		  -- Clock resets
        clkout  : out std_logic     -- Output clock
    );
end component;

signal uartClock : std_logic;
signal state : integer range 0 to 8 := 8;
signal dataNotifierBuffer : std_logic := '0'; 
signal uartClockReset : std_logic := '0';
signal startReceiving : std_logic := '0'; -- Triggers the state reset
signal finishedReceiving : std_logic := '0'; -- Used not to trigger the data notification signal repeatedly
signal uartInBuffer : std_logic := '1'; -- Used not to reset the clock while the signal is still low from data

begin
uartClockGenerator : clkdiv_rst generic map (DIVRATIO => CLOCKDIVRATIO)
	port map ( clkin => clk, rst => uartClockReset, clkout => uartClock);

triggerListenerProcess : process(clk)
variable uartResetBuffer : std_logic := '0';
begin
	uartInBuffer <= UART_IN;
	if UART_IN = '0' and startReceiving = '0' and state = 8 and uartInBuffer = '1' then -- Data transmission start condition
		startReceiving <= '1';
		uartClockReset <= '1';
		finishedReceiving <= '0';
	else -- No data transmission starts at this point
		if state = 8 and finishedReceiving = '0' and UART_IN = '1' then -- Start to wait for next input
			dataNotifierBuffer <= '1';
			finishedReceiving <= '1';
		end if;
	end if;
	--Reset the data notification
	if dataNotifierBuffer = '1' then
		dataNotifierBuffer <= '0';
	end if;
	-- Reset the clock reset
	-- This needs to be buffered in order to last long enough to have any effect (simulated)
	if uartClockReset <= '1' then
		if uartResetBuffer = '1' then
			uartClockReset <= '0';
			uartResetBuffer := '0';
		else
			uartResetBuffer := '1';
		end if;
	else
		uartResetBuffer := '0';
	end if;
	-- Reset the start receive signal if the receiver process has received the notification
	if startReceiving = '1' and not (state = 8) then
		startReceiving <= '0';
	end if;
end process;

uartReceiverProcess : process(uartClock)
begin
	if uartClock = '1' then
		-- Read the data if the state is a data-read state (8 is no data-read state!)
		if not (state = 8) then
			DATA_OUT(state) <= not(UART_IN);
		end if;
		-- Check if we should start ot receive data
		if state = 8 then
			if startReceiving = '1' then
				state <= 0; -- Reading the data is deferred by one UART clock cycle, so at the next clock cycle UART_IN == data!
			end if;
		else -- Increment the counter if it's a data-read state
		   state <= state + 1;
		end if;
	end if;
end process;

DATA_NOTIFIER <= dataNotifierBuffer;

end Behavioral;
