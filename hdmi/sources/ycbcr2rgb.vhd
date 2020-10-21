----------------------------------------------------------------------------------
-- Company: HDVID21
-- Engineer: 
-- 
-- Create Date: 10/21/2020 02:08:45 PM
-- Design Name: 
-- Module Name: ycbcr2rgb - Behavioral
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
-- Description: Converts a Y'CbCr encoded signal into RGB
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

entity ycbcr2rgb is
    Port ( y : in STD_LOGIC_VECTOR (7 downto 0);
           cb : in STD_LOGIC_VECTOR (7 downto 0);
           cr : in STD_LOGIC_VECTOR (7 downto 0);
           r : out STD_LOGIC_VECTOR (7 downto 0);
           g : out STD_LOGIC_VECTOR (7 downto 0);
           b : out STD_LOGIC_VECTOR (7 downto 0);
           clk : in STD_LOGIC; -- device clock
           pixel_clk : in STD_LOGIC);
end ycbcr2rgb;

architecture Behavioral of ycbcr2rgb is

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

    y_val <= to_integer(unsigned(y));
    cb_val<= to_integer(unsigned(cb));
    cr_val<= to_integer(unsigned(cr));
    
    -- conversion goes here
    
    r <= std_logic_vector(to_unsigned(r_val, r'length));
    g <= std_logic_vector(to_unsigned(g_val, g'length));
    b <= std_logic_vector(to_unsigned(b_val, b'length));

end Behavioral;
