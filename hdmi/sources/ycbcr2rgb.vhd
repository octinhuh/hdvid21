----------------------------------------------------------------------------------
-- Company: HDVID21
-- Engineer: 
-- 
-- Create Date: 10/21/2020 02:08:45 PM
-- Design Name: 
-- Module Name: ycbcr2rgb - Behavioral
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
-- Description: Converts a Y'CbCr encoded signal into RGB
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

entity ycbcr2rgb is
    Port ( y : in STD_LOGIC_VECTOR (7 downto 0);
           cb : in STD_LOGIC_VECTOR (7 downto 0);
           cr : in STD_LOGIC_VECTOR (7 downto 0);
           r : out STD_LOGIC_VECTOR (7 downto 0);
           g : out STD_LOGIC_VECTOR (7 downto 0);
           b : out STD_LOGIC_VECTOR (7 downto 0));
end ycbcr2rgb;

architecture Behavioral of ycbcr2rgb is

    constant real_mult : integer := 10; -- multiply real constants by this power of 2
    constant reg_len : integer := 20; -- length of the math buses

    -- values of K_R, K_G, K_B. (may not be needed depending on implementation
    -- assign them s.t. kr+kg+kb = 1
    constant kr : real range 0.0 to 1.0 := 0.299;
    constant kg : real range 0.0 to 1.0 := 0.587;
    constant kb : real range 0.0 to 1.0 := 0.114;
    
    -- inverse color matrix
    constant m00 : signed := to_signed(integer(1.0 * real(2 ** real_mult)), reg_len);
    constant m01 : signed := to_signed(integer(0.0 * real(2 ** real_mult)), reg_len);
    constant m02 : signed := to_signed(integer((2.0-2.0*kr) * real(2 ** real_mult)), reg_len);
    constant m10 : signed := to_signed(integer(1.0 * real(2 ** real_mult)), reg_len);
    constant m11 : signed := to_signed(integer((-kb*(2.0-2.0*kb)/kg) * real(2 ** real_mult)), reg_len);
    constant m12 : signed := to_signed(integer((-kr*(2.0-2.0*kr)/kg) * real(2 ** real_mult)), reg_len);
    constant m20 : signed := to_signed(integer(1.0 * real(2 ** real_mult)), reg_len);
    constant m21 : signed := to_signed(integer((2.0-2.0*kb) * real(2 ** real_mult)), reg_len);
    constant m22 : signed := to_signed(integer(0.0 * real(2 ** real_mult)), reg_len);
    
    -- integer forms of the color channels
    signal y_val, cb_val, cr_val : signed(y'length downto 0);
    signal r_val, g_val, b_val : signed(m02'length + y_val'length - 1 downto 0);    
    
    

begin

    y_val <= signed('0' & unsigned(y));
    cb_val<= signed('0' & unsigned(cb)) - 128;
    cr_val<= signed('0' & unsigned(cr)) - 128;
    
    r_val <= (m00*y_val) + (m01*cb_val) + (m02*cr_val);
    g_val <= (m10*y_val) + (m11*cb_val) + (m12*cr_val);
    b_val <= (m20*y_val) + (m21*cb_val) + (m22*cr_val);
    
    process (r_val, g_val, b_val)
    begin
    
        if r_val(r_val'length - 1) = '1' then
            r <= x"00";
        else
            r <= std_logic_vector(r_val(real_mult + r'length - 1 downto real_mult));
        end if;
        
        if g_val(g_val'length - 1) = '1' then
            g <= x"00";
        else
            g <= std_logic_vector(g_val(real_mult + g'length - 1 downto real_mult));
        end if;
        
        if b_val(b_val'length - 1) = '1' then
            b <= x"00";
        else
            b <= std_logic_vector(b_val(real_mult + b'length - 1 downto real_mult));
        end if;
    
    end process;
    
    --r <= std_logic_vector(r_val(real_mult + r'length - 1 downto real_mult));
    --g <= std_logic_vector(g_val(real_mult + g'length - 1 downto real_mult));
    --b <= std_logic_vector(b_val(real_mult + b'length - 1 downto real_mult));

end Behavioral;
