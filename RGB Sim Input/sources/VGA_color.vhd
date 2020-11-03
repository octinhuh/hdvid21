----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 10/22/2020 07:53:50 PM
-- Design Name: 
-- Module Name: VGA_color - Behavioral
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
-- Description: 
-- 
-- Dependencies: 
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
-- 
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.numeric_std.all;
-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity VGA_color is
  Port ( 
    rgb : out std_logic_vector(23 downto 0);
    pos_h,pos_v : in unsigned(10 downto 0) := "00000000000";
    blank: in std_logic;
    clk : in std_logic := '0'
  );
end VGA_color;

architecture Behavioral of VGA_color is
    signal blank_24 : std_logic_vector(23 downto 0);
begin


process(blank)
begin
    if blank = '0' then 
        blank_24 <= "000000000000000000000000";
    else 
        blank_24 <= "111111111111111111111111"; 
    end if;  

end process;

process
begin
    wait until clk='1';
    if(pos_v <= 239) then
        rgb <= "001111110000111100000011" and blank_24;
              --rrrrrrrrggggggggbbbbbbbb
    elsif (pos_v >= 240) and (pos_v <= 479) then
        rgb <= "000000110011111100001111" and blank_24;
              --rrrrrrrrggggggggbbbbbbbb 
    else 
        rgb <= "000011110000001100111111" and blank_24;
              --rrrrrrrrggggggggbbbbbbbb 
     end if;

end process;

end Behavioral;
