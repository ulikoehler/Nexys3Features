library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
 
entity UARTReceiver_TB is
end entity; 
 
architecture TB of UARTReceiver_TB is
    signal data : std_logic_vector(7 downto 0) := "00000000"; 
    signal uartTestSignal : std_logic := '1';
    signal dataNotifier : std_logic := '0';
    signal clk : std_logic := '0';

    component UARTReceiver
	 port (CLK : in  STD_LOGIC;
			 DATA_OUT : out STD_LOGIC_VECTOR (7 downto 0);
			 DATA_NOTIFIER : out STD_LOGIC;
			 UART_IN : in STD_LOGIC
			 );
    end component;

begin
    	receiver: UARTReceiver port map (CLK=>clk, DATA_OUT=>data, DATA_NOTIFIER => dataNotifier, UART_IN => uartTestSignal);

	-- Clock generator
	clk <= not clk after 5 ns;

	-- UART test signal generator "01010101"
	uartTestSignal <= '0' after 979 ns,
			  '1' after 105 us,
			  '0' after 209 us,
			  '1' after 313 us,
			  '0' after 417 us,
			  '1' after 512 us,
			  '0' after 625 us,
			  '1' after 729 us,
			  '0' after 833 us,
			  '1' after 937 us;
end;
