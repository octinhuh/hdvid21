----------------------------------------------------------------------------------
-- Company: HDVID21
-- Engineer: 
-- 
-- Create Date: 10/24/2020 10:34:05 PM
-- Design Name: 
-- Module Name: luma_scaler - Behavioral
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
-- Description: Scales a luma channel by a given value
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

entity luma_scaler is
    Port (
           y_in : in STD_LOGIC_VECTOR (7 downto 0);
           scale : in STD_LOGIC_VECTOR (7 downto 0); -- signed value to increase/decrease luma by
           y_out : out STD_LOGIC_VECTOR (7 downto 0));
end luma_scaler;

architecture Behavioral of luma_scaler is
    
    signal y_int, scale_int : integer;
    
    constant y_max : integer := 255; -- JPEG maximum
    constant y_min : integer := 0; -- JPEG minimum

begin
    
    y_int <= to_integer(unsigned(y_in));
    scale_int <= to_integer(signed(scale));
    
    process (y_int, scale_int) begin
    
        if y_int + scale_int > y_max then
            y_out <= std_logic_vector(to_unsigned(y_max, y_out'length));
        elsif y_int + scale_int < y_min then
            y_out <= std_logic_vector(to_unsigned(y_min, y_out'length));
        else
            y_out <= std_logic_vector(to_unsigned(y_int + scale_int, y_out'length));
        end if;
    end process;

end Behavioral;