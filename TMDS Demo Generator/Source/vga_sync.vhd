----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 10/22/2020 07:58:28 PM
-- Design Name: 
-- Module Name: vga_sync2 - Behavioral
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

entity vga_sync is
   Port ( 
        clk : in std_logic := '0'; --150 MHz
        hsync, vsync, pix_clk, blank : out std_logic := '0';
        hcount, vcount : out unsigned(10 downto 0) := "00000000000"  
   );
end vga_sync;

architecture Behavioral of vga_sync is
    signal video_on_int, video_on_v, video_on_h : std_logic;
    signal h_count, v_count : unsigned(10 downto 0) := "00000000000";
    signal horiz_sync,vert_sync : std_logic;

-- Horizontal Timing Constants  
	constant h_pixels_across: 	natural := 1280;
	constant h_sync_low: 		natural := 1390;
	constant h_sync_high: 		natural := 1430;
	constant h_end_count: 		natural := 1650;
-- Vertical Timing Constants
	constant v_pixels_down: 	natural := 720;
	constant v_sync_low: 		natural := 725;
	constant v_sync_high: 		natural := 730;
	constant v_end_count: 		natural := 750;
	
begin	
video_on_int <= (video_on_v and video_on_h);
blank <= video_on_int; 
pix_clk <= clk;
hcount <= h_count;
vcount <= v_count;
process
begin
    wait until clk='1';
    --Horizontal
    if(h_count = h_end_count) then
        h_count <= "00000000000";
    else
        h_count <= h_count + 1;
    end if;
    
    if h_count <= h_sync_high and h_count >= h_sync_low then
        horiz_sync <= '0';
    else
        horiz_sync <= '1';
    end if;
    
    --Vertical 
    if v_count >= v_end_count and h_count >= h_sync_low then
        v_count <= "00000000000";
    elsif (h_count = h_sync_low) then
        v_count <= v_count + 1;
    end if;
    
    if v_count <= v_sync_high and v_count >= v_sync_low then
        vert_sync <= '0';
    else
        vert_sync <= '1';
    end if;
    
    --Video Signals
    if h_count < h_pixels_across then
        video_on_h <= '1';
        
    else
        video_on_h <= '0';
    end if;
    
    --Vertical Video Signals
    if v_count <= v_pixels_down then
        video_on_v <= '1';     
    else
        video_on_v <= '0';
    end if;
    
    hsync <= not horiz_sync;
    vsync <= not vert_sync;
    
end process;

end Behavioral;
