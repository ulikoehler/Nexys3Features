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
    generic (DIVRATIO : integer := 4);  -- Division ratio
    port (
        clkin   : in std_logic;         -- Input clock
	rst	: in std_logic;		  -- Clock resets
        clkout  : out std_logic := '0'     -- Output clock
    );
end component;

signal uartClock : std_logic;
signal state : integer range 0 to 9 := 9;
signal dataNotifierBuffer : std_logic := '0'; 
signal uartClockReset : std_logic := '0';

begin
-- Update the seven segment content with 2 Hz frequency
uartClockGenerator : clkdiv_rst generic map (DIVRATIO => CLOCKDIVRATIO)
	port map ( clkin => clk, rst => uartClockReset, clkout => uartClock);

triggerListenerProcess : process(clk)
begin
	if UART_IN = '0' and state = 9 then
		state <= 0;
		uartClockReset <= '1';
	else
		if state = 9 then -- Waiting for next input
			dataNotifierBuffer <= '1';
		end if;
	end if;
	--Reset the data notification
	if dataNotifierBuffer = '1' then
		dataNotifierBuffer <= '0';
	end if;
	-- Reset the clock reset
	if uartClockReset <= '1' then
		uartClockReset <= '0';
	end if;
end process;

stateIncrementProcess : process(uartClock)
begin
	if rising_edge(uartClock) then
		if not(state = 9) then
		   state <= state + 1;
		end if;
	end if;
end process;

uartReceiverProcess : process(uartClock)
begin
	if rising_edge(uartClock) then
		if not (state = 0) and not (state = 9) then
			DATA_OUT(state - 1) <= not(UART_IN);
		end if;
	end if;
end process;

DATA_NOTIFIER <= dataNotifierBuffer;

end Behavioral;
