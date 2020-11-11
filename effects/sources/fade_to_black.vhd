----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 11/02/2020 11:21:08 AM
-- Design Name: 
-- Module Name: fade_to_black - Behavioral
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
use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity fade_to_black is
  Port ( 
    clk: in std_logic;
    en: in std_logic;
    rgb_in : in  std_logic_vector(23 downto 0);
    rgb_out: out std_logic_vector(23 downto 0);
    r_out_8: out std_logic_vector(7 downto 0);
    g_out_8: out std_logic_vector(7 downto 0);
    b_out_8: out std_logic_vector(7 downto 0)
    );
    
end fade_to_black;

architecture Behavioral of fade_to_black is
    
    signal r_temp_12, b_temp_12, g_temp_12: std_logic_vector(11 downto 0):= x"000";
    signal r_temp_8: std_logic_vector(7 downto 0):= rgb_in(23 downto 16); 
    signal g_temp_8: std_logic_vector(7 downto 0):= rgb_in(15 downto 8); 
    signal b_temp_8:  std_logic_vector(7 downto 0):= rgb_in(7 downto 0);

    constant mult: std_logic_vector(3 downto 0):= "1100";
begin

    process (clk, en) begin
    
    --do a fade
    if (clk = '1') and (en = '1') then
    
        r_temp_8 <= rgb_in(23 downto 16);
        g_temp_8 <= rgb_in(15 downto 8);
        b_temp_8 <= rgb_in(7 downto 0);
    
       -- r_temp_12(7 downto 0) <= r_temp_8;
       -- g_temp_12(7 downto 0) <= g_temp_8;
       -- b_temp_12(7 downto 0) <= b_temp_8;
       -- r_temp_12 <= std_logic_vector(unsigned(r_temp_8) * unsigned(mult));  
       -- g_temp_12 <= std_logic_vector(unsigned(g_temp_8) * unsigned(mult));  
       -- b_temp_12 <= std_logic_vector(unsigned(b_temp_8) * unsigned(mult));    
  
--        r_temp_8 <= r_temp_12(11 downto 4);
--        g_temp_8 <= g_temp_12(11 downto 4);
--        b_temp_8 <= b_temp_12(11 downto 4);
          
    --      r_out <= r_temp_8;
      --    g_out <= g_temp_8;
        --  b_out <= b_temp_8;
          
          rgb_out(23 downto 16) <= r_temp_8;
          rgb_out(15 downto 8) <= g_temp_8;
          rgb_out(7 downto 0) <= b_temp_8; 
          
          r_out_8 <= r_temp_8;
          g_out_8 <= g_temp_8;
          b_out_8 <= b_temp_8;
          
    else
        rgb_out(23 downto 16) <= r_temp_8;
        rgb_out(15 downto 8) <= g_temp_8;
        rgb_out(7 downto 0) <= b_temp_8;
    end if;
    end process;
    
--    rgb_out(23 downto 16) <= r_temp_8;   
--    rgb_out(15 downto 8) <= g_temp_8;
--    rgb_out(7 downto 0) <= b_temp_8;
    --rgb_out <= rgb_in;
end Behavioral;
