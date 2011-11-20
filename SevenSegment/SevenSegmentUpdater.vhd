library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity SevenSegmentUpdater is
 Port ( DATA : in STD_LOGIC_VECTOR (31 downto 0);
		  CLK : in  STD_LOGIC;
		  SEVENSEGMENT_CATHODE : out  STD_LOGIC_VECTOR (7 downto 0);
		  SEVENSEGMENT_ANODE : out  STD_LOGIC_VECTOR (3 downto 0)
		 );
end SevenSegmentUpdater;

architecture Behavioral of SevenSegmentUpdater is
  signal clock100Hz: std_logic;
  signal segmentCounter : integer range 0 to 3;	
begin
-- Divides the main 100 MHz clock
oneKilohertzDiv : entity work.clkdiv generic map (DIVRATIO => 10000)
	port map ( clkin => CLK,
				  clkout => clock100Hz);			  
--

-- Not each single segment is adressable, so we have to iterate
-- over the digits (see the Nexys3 reference manual)
-- To select the content, the 32-bit sevensegmentData vector is used
sevenSegmentUpdaterProcess : process(clock100Hz)
begin
	if(rising_edge(clock100Hz)) then
			-- Increase the segment counter (=which of the four digits is set each clock cycle)
			if (segmentCounter = 3) then
				segmentCounter <= 0;
			else
				segmentCounter <= segmentCounter + 1;
			end if;
			
			if (segmentCounter = 0) then
				SEVENSEGMENT_ANODE <= "0111";
				SEVENSEGMENT_CATHODE <= DATA(31 downto 24);
			elsif (segmentCounter = 1) then
				SEVENSEGMENT_ANODE <= "1011";
				SEVENSEGMENT_CATHODE <= DATA(23 downto 16);
			elsif (segmentCounter = 2) then
				SEVENSEGMENT_ANODE <= "1101";
				SEVENSEGMENT_CATHODE <= DATA(15 downto 8);
			elsif (segmentCounter = 3) then
				SEVENSEGMENT_ANODE <= "1110";
				SEVENSEGMENT_CATHODE <= DATA(7 downto 0);
			else
				SEVENSEGMENT_ANODE <= "0000";
				SEVENSEGMENT_CATHODE <= "00000000";
			end if;
			-- Depending on the segment, select the correct configuration
			-- Prints 0123 on the display
	end if;
end process;
end Behavioral;