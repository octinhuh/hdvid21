----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 11/13/2020 10:47:28 AM
-- Design Name: 
-- Module Name: chroma_scaler_tb - Behavioral
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

entity chroma_scaler_tb is
--  Port ( );
end chroma_scaler_tb;

architecture Behavioral of chroma_scaler_tb is

    -- Module
    component chroma_scaler
        Port ( cb_in    : in STD_LOGIC_VECTOR (7 downto 0);
               cr_in    : in STD_LOGIC_VECTOR (7 downto 0);
               scale    : in STD_LOGIC_VECTOR (7 downto 0);
               cb_out   : out STD_LOGIC_VECTOR (7 downto 0);
               cr_out   : out STD_LOGIC_VECTOR (7 downto 0));
    end component;
    
    -- Clock settings
    constant frequency      : INTEGER   := 100e6;                               -- f = 100 MHz
    constant period         : TIME      := 1000 ms / frequency;                 -- T = 10 ns
    
    -- Signals
    signal clk         : STD_LOGIC := '0';                                      -- Clock
    signal cb_in, cr_in, scale, cb_out, cr_out : STD_LOGIC_VECTOR(7 downto 0);  -- I/O
    
    -- DUT
    for dut : chroma_scaler use entity work.chroma_scaler(behavioral);
    
    -- Test cases
    type test_case is (
        No_Test,                                    -- Not testing
        No_Scale,                                   -- Don't scale              (default setting of dial)
        Do_Scale,                                   -- Scale                    (non-default setting of dial, not clamped)
        Cb_MinClamp, Cr_MinClamp, Dbl_MinClamp,     -- Clamp to minimum value   (Cb, Cr, or both)
        Cb_MaxClamp, Cr_MaxClamp, Dbl_MaxClamp);    -- Clamp to maximum value   (Cb, Cr, or both)
    signal tc: test_case := No_Test;

begin

    -- DUT port mapping
    dut : chroma_scaler port map(cb_in=>cb_in, cr_in=>cr_in, scale=>scale, cb_out=>cb_out, cr_out=>cr_out);
    
    -- Clock
    clk <= not clk after period / 2;
    
    -- Tests
    process begin
        wait for    period * 3/2;
        -- No scaling (Cb = 200, Cr = 100, Scale = 0)
        cb_in       <= X"C8";
        cr_in       <= X"64";
        scale       <= X"00";
        tc          <= No_Scale;
        wait for    period;
        -- Scaling (Cb = 200, Cr = 100, Scale = 54)
        cb_in       <= X"C8";
        cr_in       <= X"64";
        scale       <= X"36";
        tc          <= Do_Scale;
        wait for    period;
        -- Cb minimum clamp (Cb = 1, Cr = 100, Scale = -10)
        cb_in       <= X"01";
        cr_in       <= X"64";
        scale       <= X"F6";
        tc          <= Cb_MinClamp;
        wait for    period;
        -- Cr minimum clamp (Cb = 100, Cr = 1, Scale = -20)
        cb_in       <= X"64";
        cr_in       <= X"01";
        scale       <= X"EC";
        tc          <= Cr_MinClamp;
        wait for    period;
        -- Double minimum clamp (Cb = 29, Cr = 29, Scale = -30)
        cb_in       <= X"1D";
        cr_in       <= X"1D";
        scale       <= X"E2";
        tc          <= Dbl_MinClamp;
        wait for    period;
        -- Cb maximum clamp (Cb = 250, Cr = 100, Scale = 100)
        cb_in       <= X"FA";
        cr_in       <= X"64";
        scale       <= X"64";
        tc          <= Cb_MaxClamp;
        wait for    period;
        -- Cr maximum clamp (Cb = 100, Cr = 250, Scale = 120)
        cb_in       <= X"64";
        cr_in       <= X"FA";
        scale       <= X"78";
        tc          <= Cr_MaxClamp;
        wait for    period;
        -- Double maximum clamp (Cb = 200, Cr = 200, Scale = 127)
        cb_in       <= X"C8";
        cr_in       <= X"C8";
        scale       <= X"7F";
        tc          <= Dbl_MaxClamp;
        wait for    period;
        -- Done testing
        tc          <= No_Test;
        wait for    period * 1000;
    end process;

end Behavioral;
