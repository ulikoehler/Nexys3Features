library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity FourDigitCounter is
 Port (CLK : in  STD_LOGIC;
		  SEVENSEGMENT_CATHODE : out  STD_LOGIC_VECTOR (7 downto 0);
		  SEVENSEGMENT_ANODE : out  STD_LOGIC_VECTOR (3 downto 0)
		 );
end FourDigitCounter;

architecture Behavioral of FourDigitCounter is
signal currentData : std_logic_vector (31 downto 0); -- This signal is fed into the seven segment driver (SevenSegmentUpdater)
signal twoHertzClock : std_logic;
signal ones, tens, hundreds, thousands: integer range 0 to 9;
begin
-- The entity which sets the appropriate pin states
updater : entity work.SevenSegmentUpdater
	port map ( DATA => currentData,
				  CLK => CLK,
				  SEVENSEGMENT_CATHODE => SEVENSEGMENT_CATHODE,
				  SEVENSEGMENT_ANODE => SEVENSEGMENT_ANODE);
				  
-- Update the seven segment content with 2 Hz frequency
twoHertzDiv : entity work.clkdiv generic map (DIVRATIO => 50000000)
	port map ( clkin => clk,
				  clkout => twoHertzClock);
				  

-- The process which counts all the digits
-- The individual digits are counted separately
-- Because it's much easier than separating them afterwards
counter : process(twoHertzClock)
begin
	if(rising_edge(twoHertzClock)) then
		if(ones = 9) then
			ones <= 0;
			if tens = 9 then
				tens <= 0;
				if hundreds = 9 then
					hundreds <= 0;
					if thousands = 9 then
						thousands <= 0;
					else
						thousands <= thousands + 1;
					end if;
				else
					hundreds <= hundreds + 1;
				end if;
			else
				tens <= tens + 1;
			end if;
		else
			ones <= ones + 1;
		end if;
	end if;
end process;

-- First digit
with ones select
	currentData(31 downto 24) <= "11111001" when 1,
										  "10100100" when 2,
										  "10110000" when 3,
										  "10011001" when 4,
										  "10010010" when 5,
										  "10000010" when 6,
										  "11111000" when 7,
										  "10000000" when 8,
										  "10010000" when 9,
										  "11000000" when 0,
										  "11111111" when others;

-- Second digit			  
with tens select
	currentData(23 downto 16) <= "11111001" when 1,
										  "10100100" when 2,
										  "10110000" when 3,
										  "10011001" when 4,
										  "10010010" when 5,
										  "10000010" when 6,
										  "11111000" when 7,
										  "10000000" when 8,
										  "10010000" when 9,
										  "11000000" when 0,
										  "11111111" when others;
-- Third digit			  
with hundreds select
	currentData(15 downto 8) <=  "11111001" when 1,
										  "10100100" when 2,
										  "10110000" when 3,
										  "10011001" when 4,
										  "10010010" when 5,
										  "10000010" when 6,
										  "11111000" when 7,
										  "10000000" when 8,
										  "10010000" when 9,
										  "11000000" when 0,
										  "11111111" when others;
-- Fourth digit	  
with thousands select
	currentData(7 downto 0) <=   "11111001" when 1,
										  "10100100" when 2,
										  "10110000" when 3,
										  "10011001" when 4,
										  "10010010" when 5,
										  "10000010" when 6,
										  "11111000" when 7,
										  "10000000" when 8,
										  "10010000" when 9,
										  "11000000" when 0,
										  "11111111" when others;

end Behavioral;
