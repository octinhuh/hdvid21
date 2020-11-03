----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 10/30/2020 03:22:23 PM
-- Design Name: 
-- Module Name: VGA_sim - Behavioral
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

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity VGA_sim is
--  Port ( );
end VGA_sim;

architecture Behavioral of VGA_sim is
    component VGA_Top
     Port ( 
    clk : in std_logic;
    hsync, vsync, blank : out std_logic;
    pix_clk : out std_logic;
    rgb_out : out std_logic_vector(23 downto 0)
    );
    end component;
    
    signal clk: std_logic := '0';
    signal hsync, vsync, blank, pix_clk : std_logic;
    signal rgb_out : std_logic_vector(23 downto 0);
    
begin

uut: VGA_Top port map(clk => clk,
                      hsync => hsync,
                      vsync => vsync, 
                      blank => blank,
                      pix_clk => pix_clk,
                      rgb_out => rgb_out
                      );
                      
clk <= not clk after 6.67 ns; 

end Behavioral;
