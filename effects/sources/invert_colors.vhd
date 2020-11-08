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
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

-- Ports
entity invert_colors is
    Port ( clk      : in STD_LOGIC;                                 -- Clock
           sel      : in STD_LOGIC;                                 -- Select
           rgb_in   : in STD_LOGIC_VECTOR(23 downto 0);             -- RGB (Input)
           rgb_out  : out STD_LOGIC_VECTOR(23 downto 0));           -- RGB (Output)
end invert_colors;

-- Behavior
architecture Behavioral of invert_colors is
    -- Signal(s)
    signal rgb      : STD_LOGIC_VECTOR(23 downto 0);                -- RGB

begin

-- Output
process(clk) begin
    if rising_edge(clk) then
        rgb_out <= rgb;
    end if;
end process;

-- Invert?
process(rgb_in, sel) begin
    if sel = '1' then
        rgb <= rgb_in XOR X"FFFFFF";    -- Invert : Output = (Input XOR FFFFFF)
    else
        rgb <= rgb_in;                  -- Pass   : Output = Input
    end if;
end process;

end Behavioral;
