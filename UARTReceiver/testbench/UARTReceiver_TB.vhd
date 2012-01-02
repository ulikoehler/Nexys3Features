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

	-- UART test signal generator "01010101" - Hex AA
	uartTestSignal <= -- Start bit
			  '0' after 979 ns, 
                          -- Data
			  '1' after 105 us,
			  '0' after 209 us,
			  '1' after 313 us,
			  '0' after 417 us,
			  '1' after 512 us,
			  '0' after 625 us,
			  '1' after 729 us,
			  '0' after 833 us,
			  --Stop bit
			  '1' after 937 us,
			  -- UART test signal generator "11110010"
			  -- Start bit
			  '0' after 1114 us,
                          -- Data
			  '0' after 1218 us,
			  '0' after 1322 us,
			  '0' after 1426 us,
			  '0' after 1530 us,
			  '1' after 1634 us,
			  '1' after 1738 us,
			  '0' after 1842 us,
			  '1' after 1946 us,
			  --Stop bit
			  '1' after 2050 us;
end;
