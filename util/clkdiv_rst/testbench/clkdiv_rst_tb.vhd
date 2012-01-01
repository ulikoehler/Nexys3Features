library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
 
entity clkdiv_rst_tb is
end entity; 
 
architecture TB of clkdiv_rst_tb is

    component clkdiv_rst
    generic (DIVRATIO : integer := 4);  -- Division ratio
    port (
        clkin   : in std_logic;         -- Input clock
	rst	: in std_logic;		  -- Clock resets
        clkout  : out std_logic := '0'        -- Output clock
    );
    end component;

signal masterClk : std_logic := '0';
signal rst : std_logic := '0';
signal clockToTest : std_logic := '1';

begin

	masterClk <= not masterClk after 5 ns; -- 100 MHz

	instance : clkdiv_rst port map(clkin => masterClk, rst => rst, clkout => clockToTest);
 
	rst <= '1' after 20 ns, '0' after 40 ns; 
end;
