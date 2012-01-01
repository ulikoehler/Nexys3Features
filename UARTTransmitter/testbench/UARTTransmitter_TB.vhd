library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
 
entity UARTTransmitter_TB is
end entity; 
 
architecture TB of UARTTransmitter_TB is
 
    component UARTTransmitter
    port( cout:		out std_logic_vector(7 downto 0);
	    up_down:	in std_logic;
	    reset:		in std_logic;
	    clk:		in std_logic
 
    );
    end component;
 
    signal data:    std_logic_vector(7 downto 0);
    signal txTrigger: std_logic;
    signal txFinished:   std_logic;
    signal uartOut:   std_logic;
    signal clk:     std_logic;
 
begin
 
    transmitter: entity UARTTransmitter port map (clk, data, txTrigger, txTrigger, uartOut);
 
	clkGenerator : process
	begin
		clk <= '0';
		wait for 5 ns;
		clk <= '1';
		wait for 5 ns;
	end process;
 
	process
	begin
		data <= "01010101";
		txTrigger <= '1';
		wait for 100 ms;
	end process;
end;
