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
    constant reg_len : integer := 20; -- length of the math buses

    -- values of K_R, K_G, K_B. (may not be needed depending on implementation
    -- assign them s.t. kr+kg+kb = 1
    constant kr : real range 0.0 to 1.0 := 0.299;
    constant kg : real range 0.0 to 1.0 := 0.587;
    constant kb : real range 0.0 to 1.0 := 0.114;
    
    -- color matrix
    constant m00 : signed := to_signed(integer(kr * real(2 ** real_mult)), reg_len);
    constant m01 : signed := to_signed(integer(kg * real(2 ** real_mult)), reg_len);
    constant m02 : signed := to_signed(integer(kb * real(2 ** real_mult)), reg_len);
    constant m10 : signed := to_signed(integer(-0.5 * kr / (1.0 - kb) * real(2 ** real_mult)), reg_len);
    constant m11 : signed := to_signed(integer((-kb*(2.0-2.0*kb)/kg) * real(2 ** real_mult)), reg_len);
    constant m12 : signed := to_signed(integer(0.5 * real(2 ** real_mult)), reg_len);
    constant m20 : signed := to_signed(integer(0.5 * real(2 ** real_mult)), reg_len);
    constant m21 : signed := to_signed(integer(-0.5 * kg / (1.0 - kr) * real(2 ** real_mult)), reg_len);
    constant m22 : signed := to_signed(integer(-0.5 * kb / (1.0 - kr) * real(2 ** real_mult)), reg_len);
    
    -- integer forms of the color channels
    signal r_val, g_val, b_val : signed(r'length downto 0);
    signal y_val, cb_val, cr_val : signed(m02'length + r_val'length - 1 downto 0);

begin

    r_val <= signed('0' & unsigned(r));
    g_val <= signed('0' & unsigned(g));
    b_val <= signed('0' & unsigned(b));
    
    y_val <= (m00*r_val) + (m01*g_val) + (m02*b_val);
    cb_val <= (m10*r_val) + (m11*g_val) + (m12*b_val) + (128 * (2 ** real_mult));
    cr_val <= (m20*r_val) + (m21*g_val) + (m22*b_val) + (128 * (2 ** real_mult));
    
    process (y_val, cb_val, cr_val)
    begin
    
        if y_val(y_val'length - 1) = '1' then
            y <= x"00";
        else
            y <= std_logic_vector(y_val(real_mult + y'length - 1 downto real_mult));
        end if;
        
        if cb_val(cb_val'length - 1) = '1' then
            cb <= x"00";
        else
            cb <= std_logic_vector(cb_val(real_mult + cb'length - 1 downto real_mult));
        end if;
        
        if cr_val(cr_val'length - 1) = '1' then
            cr <= x"00";
        else
            cr <= std_logic_vector(cr_val(real_mult + cr'length - 1 downto real_mult));
        end if;
    
    end process;

end Behavioral;
