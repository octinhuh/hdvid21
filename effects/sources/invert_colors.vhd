----------------------------------------------------------------------------------
-- Company: HDVID21
-- Engineer: Todd
-- 
-- Create Date: 11/04/2020 10:20:44 AM
-- Design Name: Invert Colors
-- Module Name: invert_colors - Behavioral
-- Project Name: HDVID21
-- Target Devices: 
-- Tool Versions: 
-- Description: Inverts or passes an RGB stream depending on the setting of a select signal
-- 
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Ports
entity invert_colors is
    Port ( sel      : in STD_LOGIC;                                 -- Select
           rgb_in   : in STD_LOGIC_VECTOR(23 downto 0);             -- RGB (Input)
           rgb_out  : out STD_LOGIC_VECTOR(23 downto 0));           -- RGB (Output)
end invert_colors;

-- Behavior
architecture Behavioral of invert_colors is

begin

-- Invert?
process(rgb_in, sel) begin
    if sel = '1' then
        rgb_out <= rgb_in XOR X"FFFFFF";    -- Invert : Output = (Input XOR 0xFFFFFF)
    else
        rgb_out <= rgb_in;                  -- Pass   : Output = Input
    end if;
end process;

end Behavioral;
