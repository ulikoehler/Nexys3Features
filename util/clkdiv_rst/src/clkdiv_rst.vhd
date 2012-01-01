-- Description: Clock divider by a given ratio with reset
-- 			Based on Thientu Ho's work: http://www.fpgacore.com/archives/43
-- Author: Uli Köhler
-- Date: 2/28/2010

library IEEE;
use IEEE.std_logic_1164.all;

entity clkdiv_rst is
    generic (DIVRATIO : integer := 4);  -- Division ratio
    port (
        clkin     : in std_logic;         -- Input clock
		  rst			: in std_logic;		  -- Clock resets
        clkout  : out std_logic         -- Output clock
    );
end entity clkdiv_rst;

architecture Behaviour of clkdiv_rst is
signal clkoutBuffer : std_logic;  -- Impossible to read output port, so it's buffered here
begin
    -- Implements 50% duty cycle (but only if the DIVRATIO parameter is divisible by two)
    clkdiv_proc : process (clkin)
    variable counter : integer range 0 to DIVRATIO-1;
    begin
		  if rst='0' then          -- initialize power up reset conditions
				clkoutBuffer <= '0';
            count := 0;
        if rising_edge(clkin) then
            if counter=DIVRATIO/2-1 then      -- Toggle output to achieve 50% duty cycle
                clkoutBuffer <= not clkoutBuffer;
                counter := counter + 1;
            elsif counter=DIVRATIO-1 then -- Overflow --> Toggle and reset
                clkoutBuffer <= not clkoutBuffer;
                counter := 0;
            else
                counter := counter + 1;
            end if;
        end if;
    end process;

    clkout <= clkoutBuffer;
end Behaviour;