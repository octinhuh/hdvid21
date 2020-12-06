----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 11/02/2020 01:48:37 PM
-- Design Name: 
-- Module Name: RGB_splitter - Behavioral
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

entity RGB_combiner is
  Port ( 
    RGB_out : out std_logic_vector(23 downto 0);
    R,B,G : in std_logic_vector(7 downto 0)
  );
end RGB_combiner;

architecture Behavioral of RGB_combiner is

begin
     RGB_out (23 downto 16) <= R;
     RGB_out (15 downto 8) <= G;
     RGB_out (7 downto 0) <= B;

end Behavioral;
