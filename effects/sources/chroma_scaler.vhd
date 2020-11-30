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
            scale    : in STD_LOGIC_VECTOR (7 downto 0);     -- Scaling offset
            -- Outputs
            cb_out   : out STD_LOGIC_VECTOR (7 downto 0);    -- Cb (out)
            cr_out   : out STD_LOGIC_VECTOR (7 downto 0));   -- Cr (out)
end chroma_scaler;

architecture Behavioral of chroma_scaler is

    signal cb_int, cr_int, scale_int : integer;             -- Cb, Cr, and Scaling offset
    constant max    : integer := 255;                       -- Maximum clamp
    constant min    : integer := 0;                         -- Minimum clamp

begin

    cb_int      <= to_integer(unsigned(cb_in));
    cr_int      <= to_integer(unsigned(cr_in));
    scale_int   <= to_integer(signed(scale));

    process (cb_int, cr_int, scale_int) begin
    
        -- Cb
        if scale_int = min then                                                                 -- No scaling
            cb_out <= std_logic_vector(to_unsigned(cb_int, cb_out'length));
        elsif cb_int + scale_int >= max then                                                    -- Maximum clamp
            cb_out <= std_logic_vector(to_unsigned(max, cb_out'length));
        elsif cb_int + scale_int <= min then                                                    -- Minimum clamp
            cb_out <= std_logic_vector(to_unsigned(min, cb_out'length));
        else                                                                                    -- Apply scaling
            cb_out <= std_logic_vector(to_unsigned(cb_int + scale_int, cb_out'length));
        end if;
        
        -- Cr
        if scale_int = min then                                                                 -- No scaling
            cr_out <= std_logic_vector(to_unsigned(cr_int, cr_out'length));
        elsif cr_int + scale_int >= max then                                                    -- Maximum clamp
            cr_out <= std_logic_vector(to_unsigned(max, cr_out'length));
        elsif cr_int + scale_int <= min then                                                    -- Minimum clamp
            cr_out <= std_logic_vector(to_unsigned(min, cr_out'length));
        else                                                                                    -- Apply scaling
            cr_out <= std_logic_vector(to_unsigned(cr_int + scale_int, cr_out'length));
        end if;
        
    end process;

end Behavioral;
