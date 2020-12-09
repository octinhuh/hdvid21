----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 11/13/2020 10:02:16 AM
-- Design Name: 
-- Module Name: chroma_scaler - Behavioral
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

entity chroma_scaler is
    Port ( 
            -- Inputs
            cb_in    : in STD_LOGIC_VECTOR (7 downto 0);     -- Cb (in)
            cr_in    : in STD_LOGIC_VECTOR (7 downto 0);     -- Cr (in)
            scale_cb : in STD_LOGIC_VECTOR (7 downto 0);     -- Scaling offset
            scale_cr : in STD_LOGIC_VECTOR (7 downto 0); 
            -- Outputs
            cb_out   : out STD_LOGIC_VECTOR (7 downto 0);    -- Cb (out)
            cr_out   : out STD_LOGIC_VECTOR (7 downto 0));   -- Cr (out)
end chroma_scaler;

architecture Behavioral of chroma_scaler is

    signal cb_int, cr_int, scale_int_cb, scale_int_cr: unsigned(7 downto 0);             -- Cb, Cr, and scaling offset
    signal scaling,scaling2 : unsigned(15 downto 0); 
    
    constant max    : integer := 255;                       -- Maximum clamp
    constant min    : integer := 0;                         -- Minimum clamp

begin

    cb_int      <= unsigned(cb_in);
    cr_int      <= unsigned(cr_in);
    scale_int_cb   <= unsigned(scale_cb);
    scale_int_cr   <= unsigned(scale_cr);
    scaling <= scale_int_cb * cb_int;
    scaling2 <= scale_int_cr * cr_int;
process(scaling,scaling2) begin   
    --cb
    if scaling / 32 >= 255 then
         cb_out <= std_logic_vector(to_unsigned(max, 8));
    elsif scaling / 32 <= 0 then 
        cb_out <= std_logic_vector(to_unsigned(min,8));
    else
        cb_out <= std_logic_vector(scaling(12 downto 5));
    end if;
    
    if scaling2 / 32 >= 255 then
        cr_out <= std_logic_vector(to_unsigned(max, 8));
    elsif scaling2 / 32 <= 0 then 
        cr_out <= std_logic_vector(to_unsigned(min,8));
    else
        cr_out <= std_logic_vector(scaling2(12 downto 5));
    end if;
    
end process;    
    
--    process (cb_int, cr_int, scale_int_cb, scale_int_cr) begin
    
--        -- Cb
--        if scale_int_cb = 0 then                                                                 -- No scaling
--            cb_out <= std_logic_vector(to_unsigned(cb_int, cb_out'length));
--        elsif cb_int + scale_int_cb >= max then                                                    -- Maximum clamp
--            cb_out <= std_logic_vector(to_unsigned(max, cb_out'length));
--        elsif cb_int + scale_int_cb <= 0 then                                                    -- Minimum clamp
--            cb_out <= std_logic_vector(to_unsigned(0, cb_out'length));
--        else                                                                                    -- Apply scaling
--            cb_out <= std_logic_vector(to_unsigned(cb_int + scale_int_cb, cb_out'length));
--        end if;
        
--        -- Cr
--        if scale_int_cr = 0 then                                                                 -- No scaling
--            cr_out <= std_logic_vector(to_unsigned(cr_int, cr_out'length));
--        elsif cr_int + scale_int_cr >= max then                                                    -- Maximum clamp
--            cr_out <= std_logic_vector(to_unsigned(max, cr_out'length));
--        elsif cr_int + scale_int_cr <= min then                                                    -- Minimum clamp
--            cr_out <= std_logic_vector(to_unsigned(min, cr_out'length));
--        else                                                                                    -- Apply scaling
--            cr_out <= std_logic_vector(to_unsigned(cr_int + scale_int_cr, cr_out'length));
--        end if;
        
--    end process;

end Behavioral;
