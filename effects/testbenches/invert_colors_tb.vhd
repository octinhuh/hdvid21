----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 11/04/2020 11:30:09 AM
-- Design Name: 
-- Module Name: invert_colors_tb - Behavioral
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
-- Description: 
-- 
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity invert_colors_tb is
--  Port ( );
end invert_colors_tb;

architecture Behavioral of invert_colors_tb is
    
    -- Module
    component invert_colors
    Port ( sel              : in STD_LOGIC;                                 -- Select
           rgb_in           : in STD_LOGIC_VECTOR(23 downto 0);             -- RGB (Input)
           rgb_out          : out STD_LOGIC_VECTOR(23 downto 0));           -- RGB (Output)
    end component;
    
    -- Clock Settings
    constant frequency      : INTEGER   := 100e6;                           -- f = 100 MHz
    constant period         : TIME      := 1000 ms / frequency;             -- T = 10 ns
    
    -- Signals
    signal clk, sel         : STD_LOGIC := '0';                             -- Clock and Select
    signal rgb_in, rgb_out  : STD_LOGIC_VECTOR(23 downto 0);                -- RGB (Input) and RGB (Output)
    
    -- DUT
    for dut : invert_colors use entity work.invert_colors(behavioral);

begin

    -- DUT Port Mapping
    dut : invert_colors port map(sel=>sel, rgb_in=>rgb_in, rgb_out=>rgb_out);
    
    -- Clock
    clk <= not clk after period / 2;
    
    -- Tests
    process begin
        -- Test: Don't Invert (00 00 00) -> (00 00 00)
        rgb_in <= X"000000";    -- Black
        sel <= '0';             -- Pass
        wait for period;
        -- Test: Invert (00 00 00) -> (FF FF FF)
        rgb_in <= X"000000";    -- Black
        sel <= '1';             -- Invert
        wait for period;
        -- Test: Invert (FF FF FF) -> (00 00 00)
        rgb_in <= rgb_out;      -- White
        sel <= '1';             -- Invert
        wait for period;
        -- Test: Invert (7F 7F 7F) -> (80 80 80)
        rgb_in <= X"7F7F7F";    -- Gray
        sel <= '1';             -- Invert
        wait for period;
        -- Test: Invert (80 80 80) -> (7F 7F 7F)
        rgb_in <= rgb_out;      -- Gray
        sel <= '1';             -- Invert
        wait for period;
        -- Test: Invert (00 99 33) -> (FF 66 CC)
        rgb_in <= X"009933";    -- Green
        sel <= '1';             -- Invert
        wait for period;
    end process;

end Behavioral;
