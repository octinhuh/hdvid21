----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 11/20/2020 10:21:06 AM
-- Design Name: 
-- Module Name: ycbcr2rgb_tb - Behavioral
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

entity ycbcr2rgb_tb is
--  Port ( );
end ycbcr2rgb_tb;

architecture Behavioral of ycbcr2rgb_tb is

component ycbcr2rgb
    Port ( y : in STD_LOGIC_VECTOR (7 downto 0);
           cb : in STD_LOGIC_VECTOR (7 downto 0);
           cr : in STD_LOGIC_VECTOR (7 downto 0);
           r : out STD_LOGIC_VECTOR (7 downto 0);
           g : out STD_LOGIC_VECTOR (7 downto 0);
           b : out STD_LOGIC_VECTOR (7 downto 0));
    end component;
    
    signal y_in, cb_in, cr_in : std_logic_vector(7 downto 0);
    signal r_out, g_out, b_out : std_logic_vector(7 downto 0);
    
    for uut : ycbcr2rgb use entity work.ycbcr2rgb(behavioral);

begin

    uut : ycbcr2rgb port map(r=>r_out, g=>g_out, b=>b_out, y=>y_in, cb=>cb_in, cr=>cr_in);
    
    process begin
    
        y_in <= x"22";
        cb_in <= x"32";
        cr_in <= x"3a";
        
        wait for 10 ns;
        
        y_in <= x"FF";
        cb_in <= x"FF";
        cr_in <= x"FF";
        
        wait for 10 ns;
        
        y_in <= x"00";
        cb_in <= x"00";
        cr_in <= x"00";
        
    
        wait;
    end process;

end Behavioral;
