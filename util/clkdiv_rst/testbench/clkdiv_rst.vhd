library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
 
entity UARTTransmitter_TB is
end UARTTransmitter_TB; 
 
architecture TB of UARTTransmitter_TB is
    signal data : std_logic_vector(7 downto 0) := "01010101";
    signal txTrigger : std_logic := '0';
    signal txFinished : std_logic;
    signal uartOut : std_logic;
    signal clk : std_logic := '0';

    component UARTTransmitter
	 port (CLK : in  STD_LOGIC;
			 DATA_IN : in STD_LOGIC_VECTOR (7 downto 0);
			 TX_TRIGGER : in STD_LOGIC;
			 TX_FINISHED : out STD_LOGIC;
			 UART_OUT : out STD_LOGIC
			 );
    end component;

begin
    	transmitter: UARTTransmitter port map (CLK=>clk, DATA_IN=>data, TX_TRIGGER=>txTrigger, TX_FINISHED=>txFinished, UART_OUT=>uartOut);

	clkGenerator : process
	begin
		clk <= '0';
		wait for 5 ns;
		clk <= '1';
		wait for 5 ns;
	end process;
 
	trigger: process
	begin
		txTrigger <= '1';
		wait until txFinished = '0';
		wait;
	end process;
end;
