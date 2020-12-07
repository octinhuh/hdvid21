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
use IEEE.NUMERIC_STD.ALL;
use IEEE.std_logic_unsigned.all;
-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values


-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity fade_to_black is
  Port ( 
    clk: in std_logic;
    en: in std_logic;
    int_clk : in std_logic; 
    r_in_8 : in  std_logic_vector(7 downto 0);
    g_in_8 : in  std_logic_vector(7 downto 0);
    b_in_8 : in  std_logic_vector(7 downto 0);
    
--    rgb_out: out std_logic_vector(23 downto 0);
    r_out_8: out std_logic_vector(7 downto 0);
    g_out_8: out std_logic_vector(7 downto 0);
    b_out_8: out std_logic_vector(7 downto 0)
    );
    
end fade_to_black;

architecture Behavioral of fade_to_black is
    signal temp_r,temp_g,temp_b : std_logic_vector(7 downto 0);
    signal cnt : unsigned(7 downto 0) := "00000000";
    signal modifier : std_logic_vector(3 downto 0) := "1000";
begin
process(clk,en)
begin
    if(en = '1' and clk = '1') then
            if(modifier /= "0000") then
                modifier <= modifier - '1';
                end if;
     end if;
    
end process;    
process(int_clk)
begin
    if(modifier = "1000") then
        temp_r <= r_in_8;  
        temp_g <= g_in_8;  
        temp_b <= b_in_8;
    elsif(modifier = "0111") then
        temp_r <= "0" & r_in_8(7 downto 1);  
        temp_g <= "0" & g_in_8(7 downto 1);  
        temp_b <= "0" & b_in_8(7 downto 1);
    elsif(modifier = "0110") then
        temp_r <= "00" & r_in_8(7 downto 2);  
        temp_g <= "00" & g_in_8(7 downto 2);  
        temp_b <= "00" & b_in_8(7 downto 2);  
    elsif(modifier = "0101") then
        temp_r <= "000" & r_in_8(7 downto 3);  
        temp_g <= "000" & g_in_8(7 downto 3);  
        temp_b <= "000" & b_in_8(7 downto 3);  
    elsif(modifier = "0100") then
        temp_r <= "0000" & r_in_8(7 downto 4);  
        temp_g <= "0000" & g_in_8(7 downto 4);  
        temp_b <= "0000" & b_in_8(7 downto 4);
    elsif(modifier = "0011") then
        temp_r <= "00000" & r_in_8(7 downto 5);  
        temp_g <= "00000" & g_in_8(7 downto 5);  
        temp_b <= "00000" & b_in_8(7 downto 5);
    elsif(modifier = "0010") then
        temp_r <= "000000" & r_in_8(7 downto 6);  
        temp_g <= "000000" & g_in_8(7 downto 6);  
        temp_b <= "000000" & b_in_8(7 downto 6);
    elsif(modifier = "0001") then
        temp_r <= "0000000" & r_in_8(7);  
        temp_g <= "0000000" & g_in_8(7);  
        temp_b <= "0000000" & b_in_8(7);
    elsif(modifier = "0000") then 
        temp_r <= "00000000"; 
        temp_g <= "00000000"; 
        temp_b <= "00000000"; 
    end if;
end process;
    r_out_8 <= temp_r;
    g_out_8 <= temp_g;
    b_out_8 <= temp_b;
end Behavioral;
