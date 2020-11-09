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
           cr : out STD_LOGIC_VECTOR (7 downto 0));
end rgb2ycbcr;

architecture Behavioral of rgb2ycbcr is

    constant real_mult : integer := 10; -- multiply real constants by this power of 2
    constant reg_len : integer := 18; -- length of the math buses

    -- values of K_R, K_G, K_B. (may not be needed depending on implementation
    -- assign them s.t. kr+kg+kb = 1
    constant kr : real range 0.0 to 1.0 := 0.299;
    constant kg : real range 0.0 to 1.0 := 0.587;
    constant kb : real range 0.0 to 1.0 := 0.114;
    
    constant mat_1_0 : real := -0.5 * kr / (1.0 - kb);
    constant mat_1_1 : real := -0.5 * kg / (1.0 - kb);
    constant mat_1_2 : real := 0.5;
    constant mat_2_0 : real := 0.5;
    constant mat_2_1 : real := -0.5 * kg / (1.0 - kr);
    constant mat_2_2 : real := -0.5 * kb / (1.0 - kr);
    
    -- integer forms of the color channels
    signal r_val, g_val, b_val : unsigned(r'length - 1 downto 0);
    
    signal y_val, cb_val, cr_val : unsigned(y'length - 1 downto 0);
    
--    function real_conv( real_num: real;
--                        power: integer := real_mult) return integer is
--    begin
--        return integer(real_num * real(2**power));
--    end function;
        
--    function int_real_mult( real_num: real;
--                            int_num: integer) return integer is
--    begin
--        return real_conv(real_num) * int_num / (2 ** real_mult);
--    end function;
    function real_conv( real_num: real;
                        power: integer := real_mult) return unsigned is
    begin
        return to_unsigned(integer(real_num * real(2**power)), reg_len);
    end function;
        
    function int_real_mult( real_num: real;
                            int_num: unsigned) return unsigned is
    variable temp : std_logic_vector(reg_len - 1 downto 0);
    variable conv : std_logic_vector(real_mult + reg_len - 3 downto 0);
    begin
        conv := std_logic_vector(real_conv(real_num) * int_num);
        temp := conv(reg_len - 1 downto 0);
        return unsigned(temp(temp'length - 1 downto real_mult));
    end function;

begin

    r_val <= unsigned(r);
    g_val <= unsigned(g);
    b_val <= unsigned(b);
    
    y_val <= int_real_mult(kr, r_val) + int_real_mult(kg, g_val) + int_real_mult(kb, b_val);
    cb_val <= 128 + int_real_mult(mat_1_0, r_val) + int_real_mult(mat_1_1, g_val) + int_real_mult(mat_1_2, b_val);
    cr_val <= 128 + int_real_mult(mat_2_0, r_val) + int_real_mult(mat_2_1, g_val) + int_real_mult(mat_2_2, b_val);
    
    y <= std_logic_vector(y_val);
    cb<= std_logic_vector(cb_val);
    cr<= std_logic_vector(cr_val);

end Behavioral;
