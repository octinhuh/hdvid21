----------------------------------------------------------------------------------
-- Company: HDVID21
-- Engineer: 
-- 
-- Create Date: 10/21/2020 01:49:05 PM
-- Design Name: 
-- Module Name: rgb2ycbcr - Behavioral
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
-- Description: Converts an RGB signal into Y'CbCr encoding
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
use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity rgb2ycbcr is
    Port ( r : in STD_LOGIC_VECTOR (7 downto 0);
           g : in STD_LOGIC_VECTOR (7 downto 0);
           b : in STD_LOGIC_VECTOR (7 downto 0);
           y : out STD_LOGIC_VECTOR (7 downto 0);
           cb : out STD_LOGIC_VECTOR (7 downto 0);
           cr : out STD_LOGIC_VECTOR (7 downto 0);
           clk : in STD_LOGIC; -- device clock
           pixel_clk : in STD_LOGIC);
end rgb2ycbcr;

architecture Behavioral of rgb2ycbcr is

    -- values of K_R, K_G, K_B. (may not be needed depending on implementation
    -- assign them s.t. kr+kg+kb = 1
    constant kr : real range 0.0 to 1.0 := 0.257;
    constant kg : real range 0.0 to 1.0 := 0.504;
    constant kb : real range 0.0 to 1.0 := 0.098;
    
    -- integer forms of the color channels
    signal r_val : integer;
    signal g_val : integer;
    signal b_val : integer;
    
    signal y_val : integer;
    signal cb_val: integer;
    signal cr_val: integer;

begin

    r_val <= to_integer(unsigned(r));
    b_val <= to_integer(unsigned(g));
    g_val <= to_integer(unsigned(b));
    
    -- conversion goes here
    
    y <= std_logic_vector(to_unsigned(y_val, y'length));
    cb<= std_logic_vector(to_unsigned(cb_val, cb'length));
    cr<= std_logic_vector(to_unsigned(cr_val, cr'length));

end Behavioral;
