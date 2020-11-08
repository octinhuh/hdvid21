----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 11/06/2020 11:17:26 AM
-- Design Name: 
-- Module Name: rgb2ycbcr_tb - Behavioral
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

entity rgb2ycbcr_tb is
--  Port ( );
end rgb2ycbcr_tb;

architecture Behavioral of rgb2ycbcr_tb is

    component rgb2ycbcr
    Port ( r : in STD_LOGIC_VECTOR (7 downto 0);
           g : in STD_LOGIC_VECTOR (7 downto 0);
           b : in STD_LOGIC_VECTOR (7 downto 0);
           y : out STD_LOGIC_VECTOR (7 downto 0);
           cb : out STD_LOGIC_VECTOR (7 downto 0);
           cr : out STD_LOGIC_VECTOR (7 downto 0));
    end component;
    
    signal r_in, g_in, b_in : std_logic_vector(7 downto 0);
    signal y_out, cb_out, cr_out : std_logic_vector(7 downto 0);
    
    for uut : rgb2ycbcr use entity work.rgb2ycbcr(behavioral);

begin

    uut : rgb2ycbcr port map(r=>r_in, g=>g_in, b=>b_in, y=>y_out, cb=>cb_out, cr=>cr_out);
    
    process begin
    
        r_in <= x"22";
        g_in <= x"32";
        b_in <= x"3a";
        
        wait for 10 ns;
        
        r_in <= x"FF";
        g_in <= x"FF";
        b_in <= x"FF";
        
        wait for 10 ns;
        
        r_in <= x"00";
        g_in <= x"00";
        b_in <= x"00";
        
    
        wait;
    end process;


end Behavioral;
