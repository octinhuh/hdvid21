----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 11/02/2020 02:18:39 PM
-- Design Name: 
-- Module Name: fade_to_black_tb - Behavioral
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

entity fade_to_black_tb is
--  Port ( );
end fade_to_black_tb;

architecture Behavioral of fade_to_black_tb is

    component fade_to_black
    port(
        clk : in std_logic;
        en  : in std_logic;
        rgb_in : in std_logic_vector(23 downto 0); 
        rgb_out: out std_logic_vector(23 downto 0);
        r_out_8, g_out_8, b_out_8: out std_logic_vector(7 downto 0)
    );
    end component;

    signal rgb_in: std_logic_vector(23 downto 0);
    signal rgb_out: std_logic_vector(23 downto 0);
    signal clk, en: std_logic;
    signal r_out_8, g_out_8, b_out_8: std_logic_vector(7 downto 0);
    for uut : fade_to_black use entity work.fade_to_black(behavioral);

begin

    uut : fade_to_black port map(clk=>clk, en=>en, rgb_in=>rgb_in , rgb_out=>rgb_out, r_out_8=>r_out_8, g_out_8=>g_out_8, b_out_8=>b_out_8);

process begin

    rgb_in <= x"fff5e6";
    clk<='1';
    en <='1';
    wait for 10 ns;


    rgb_in<=x"3578BE";    
    clk <= '1'; 
    en <= '0';
    wait for 10 ns;

    clk <= '0';
    en <= '1';
    wait for 10 ns;

    rgb_in<=x"1257CE";    
    clk <= '1';
    
    wait for 10 ns;
wait;

end process;

end Behavioral;
