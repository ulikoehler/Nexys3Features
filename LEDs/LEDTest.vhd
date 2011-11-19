
entity LEDTest is
 Port (CLK : in  STD_LOGIC;
		BTN : in  STD_LOGIC_VECTOR (4 downto 0);
		LED : out  STD_LOGIC_VECTOR (7 downto 0);
	);
end LEDTest;

architecture Behavioral of SevenSegmentTest is
signal oneHertzClock : bit := '0';

clockdivider : process(clk)
variable cnt : integer range 0 to 100000000;
	begin
		if(rising_edge(clk)) then
			if(cnt=100000000) then
				cnt:=0;
				oneHertzClock<='0';
			elsif(cnt=50000000) then
				cnt := cnt+1;
				oneHertzClock<='1';
			else
				cnt := cnt+1;
			end if;
		end if;
end process;

with oneHertzClock select LED <= "00110011" when '0', "11001100" when '1', "11111111" when others;

end Behavioral;