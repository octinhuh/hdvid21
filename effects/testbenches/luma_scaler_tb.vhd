----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 10/24/2020 11:22:25 AM
-- Design Name: 
-- Module Name: luma_scaler_tb - Behavioral
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

entity luma_scaler_tb is
--  Port ( );
end luma_scaler_tb;

architecture Behavioral of luma_scaler_tb is

    component luma_scaler
    port (
        y_in : in STD_LOGIC_VECTOR (7 downto 0);
        scale : in STD_LOGIC_VECTOR (7 downto 0); -- signed value to increase/decrease luma by
        y_out : out STD_LOGIC_VECTOR (7 downto 0)
    );
    end component;
    
    signal y_in, scale, y_out : std_logic_vector(7 downto 0);
    
    for uut : luma_scaler use entity work.luma_scaler(behavioral);

begin

    uut : luma_scaler port map(y_in=>y_in, scale=>scale, y_out=>y_out);
    
    process begin
    
        y_in <= x"00";
        scale <= x"00";
        wait for 10 ns;
        
        y_in <= x"52";
        wait for 10 ns;
        
        scale <= x"52";
        wait for 10 ns;
        
        scale <= x"A0"; -- results in negative luma => sets to 0
        wait for 10 ns;
        
        y_in <= x"7F";
        scale <= x"00";
        wait for 10 ns;
        
        scale <= x"02"; -- should become 0x81
        wait for 10 ns;
        
        y_in <= x"FE"; -- should become max value 0xFF
        
        wait;
    
    end process;


end Behavioral;
