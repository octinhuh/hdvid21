
----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 10/22/2020 09:52:56 PM
-- Design Name: 
-- Module Name: VGA_Top - Behavioral
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

entity VGA_Top is
 Port ( 
    clk : in std_logic := '0'; --150 MHz
    hsync, vsync, blank : out std_logic;
    pix_clk : out std_logic := '0';
    rgb_out : out std_logic_vector(23 downto 0)
  
 );
end VGA_Top;

architecture Behavioral of VGA_Top is
    component VGA_color
        port (
        rgb : out std_logic_vector(23 downto 0);
        pos_h,pos_v : in unsigned(10 downto 0);
        blank,clk : in std_logic
        );
    end component;
    component vga_sync 
    Port ( 
        clk : in std_logic; --150 MHz
        hsync, vsync, pix_clk, blank : out std_logic;
        hcount, vcount : out unsigned(10 downto 0)  
    );
    end component;
    signal h_count,v_count : unsigned(10 downto 0) := "00000000000";
    signal h_sync, v_sync : std_logic := '0';
    signal blank_sig : std_logic;
begin
    vsync <= v_sync;
    hsync <= h_sync;
    blank <= blank_sig;
    vga_sync1 : vga_sync port map(clk => clk, hsync => h_sync, vsync => v_sync, pix_clk => pix_clk, blank => blank_sig, hcount => h_count, vcount => v_count);
    VGA_color1 : VGA_color port map(rgb => rgb_out, pos_h => h_count, pos_v => v_count, blank => blank_sig, clk => clk);
end Behavioral;
