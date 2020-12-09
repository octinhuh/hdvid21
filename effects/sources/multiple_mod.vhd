----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 12/08/2020 10:34:11 AM
-- Design Name: 
-- Module Name: multiple_mod - Behavioral
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

entity multiple_mod is
    port(
    inv_sel : in std_logic;
    lum_scale : in std_logic_vector(8 downto 0);
    cb_scale,cr_scale : in std_logic_vector(7 downto 0);
    r,g,b : in std_logic_vector(7 downto 0);
    r_out,g_out,b_out : out std_logic_vector(7 downto 0)); 
end multiple_mod;

architecture Behavioral of multiple_mod is
    component invert_colors
    Port ( sel      : in STD_LOGIC;                                 -- Select
           rgb_in   : in STD_LOGIC_VECTOR(23 downto 0);             -- RGB (Input)
           rgb_out  : out STD_LOGIC_VECTOR(23 downto 0));           -- RGB (Output)
    end component;
    component chroma_scaler 
    Port ( 
            -- Inputs
            cb_in    : in STD_LOGIC_VECTOR (7 downto 0);     -- Cb (in)
            cr_in    : in STD_LOGIC_VECTOR (7 downto 0);     -- Cr (in)
            scale_cb : in STD_LOGIC_VECTOR (7 downto 0);     -- Scaling offset
            scale_cr : in STD_LOGIC_VECTOR (7 downto 0); 
            -- Outputs
            cb_out   : out STD_LOGIC_VECTOR (7 downto 0);    -- Cb (out)
            cr_out   : out STD_LOGIC_VECTOR (7 downto 0));   -- Cr (out)
end component;
component ycbcr2rgb
    Port ( y : in STD_LOGIC_VECTOR (7 downto 0);
           cb : in STD_LOGIC_VECTOR (7 downto 0);
           cr : in STD_LOGIC_VECTOR (7 downto 0);
           r : out STD_LOGIC_VECTOR (7 downto 0);
           g : out STD_LOGIC_VECTOR (7 downto 0);
           b : out STD_LOGIC_VECTOR (7 downto 0));
end component;
component rgb2ycbcr
    Port ( r : in STD_LOGIC_VECTOR (7 downto 0);
           g : in STD_LOGIC_VECTOR (7 downto 0);
           b : in STD_LOGIC_VECTOR (7 downto 0);
           y : out STD_LOGIC_VECTOR (7 downto 0);
           cb : out STD_LOGIC_VECTOR (7 downto 0);
           cr : out STD_LOGIC_VECTOR (7 downto 0));
end component;
component luma_scaler
    Port (
           y_in : in STD_LOGIC_VECTOR (7 downto 0);
           scale : in STD_LOGIC_VECTOR (8 downto 0); -- signed value to increase/decrease luma by
           y_out : out STD_LOGIC_VECTOR (7 downto 0));
end component;

    signal r_inv, g_inv, b_inv : std_logic_vector(7 downto 0);
    signal y, cb, cr,y_out,cb_out, cr_out : std_logic_vector(7 downto 0);
    
begin
    inv : invert_colors port map(sel => inv_sel,
                                rgb_in(23 downto 16) => r,
                                rgb_in(15 downto 8) => g,
                                rgb_in(7 downto 0) => b,
                                rgb_out(23 downto 16) => r_inv,
                                rgb_out(15 downto 8) => g_inv,
                                rgb_out(7 downto 0) => b_inv);
    toycbcr : rgb2ycbcr port map(r => r_inv,
                                 g => g_inv,
                                 b => b_inv,
                                 y => y,
                                 cb => cb,
                                 cr => cr);  
    luma : luma_scaler port map(y_in => y, 
                                scale => lum_scale,
                                y_out => y_out);
                                
    chroma : chroma_scaler port map(cb_in => cb,   
                                    cr_in => cr,   
                                    scale_cb => cb_scale,
                                    scale_cr => cr_scale,
                                    cb_out => cb_out, 
                                    cr_out => cr_out); 
    torgb : ycbcr2rgb port map(y => y_out,
                               cb => cb_out,
                               cr => cr_out,
                               r => r_out,
                               g => g_out,
                               b => b_out);
                               
end Behavioral;                               
                               
                               
                               