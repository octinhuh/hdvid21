----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 11/02/2020 11:21:08 AM
-- Design Name: 
-- Module Name: fade_to_black - Behavioral
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
use IEEE.NUMERIC_STD.ALL;
use IEEE.std_logic_unsigned.all;
-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values


-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity fade_to_black is
  Port ( 
    clk: in std_logic;
    en: in std_logic;
    int_clk : in std_logic; 
    r_in_8 : in  std_logic_vector(7 downto 0);
    g_in_8 : in  std_logic_vector(7 downto 0);
    b_in_8 : in  std_logic_vector(7 downto 0);
    
--    rgb_out: out std_logic_vector(23 downto 0);
    r_out_8: out std_logic_vector(7 downto 0);
    g_out_8: out std_logic_vector(7 downto 0);
    b_out_8: out std_logic_vector(7 downto 0)
    );
    
end fade_to_black;

architecture Behavioral of fade_to_black is

    component square_wave_gen
    Port ( period : in  STD_LOGIC_VECTOR (15 downto 0); -- num clock pulses in one cycle
           scale : in  STD_LOGIC_VECTOR (3 downto 0); -- multiply period by 2^(scale)
           enable : in  STD_LOGIC;
		   clock : in STD_LOGIC;
           wave_out : inout  STD_LOGIC);
    end component;
    
    for swg : square_wave_gen use entity work.square_wave_gen(Behavioral);
    
    --constant scale : std_logic_vector(3 downto 0) := "1000"; -- divide the period by 2^8
    --constant period: std_logic_vector(15 downto 0):= x"4dca";
    constant scale : std_logic_vector(3 downto 0) := x"0"; -- divide the period by 2^8
    constant period: std_logic_vector(15 downto 0):= x"0002";

    signal modifier : unsigned(8 downto 0) := "100000000";
    signal temp_r,temp_g,temp_b : unsigned(modifier'length + r_in_8'length - 1 downto 0);
    signal s_clk : std_logic; -- divided clock for the multiplier
    
begin

    swg : square_wave_gen port map(period=>period, scale=>scale, enable=>'1', clock=>clk, wave_out=>s_clk);

    process (en, modifier, s_clk)
    begin
    
        if s_clk = '1' and s_clk'event then
            if en = '1' and modifier > 0 then
                modifier <= modifier - 1;
            elsif en = '0' and modifier < x"100" then
                modifier <= modifier + 1;
            else
                modifier <= modifier;
            end if;
        end if;
    
    end process;
    
    temp_r <= unsigned(r_in_8) * modifier;
    temp_g <= unsigned(g_in_8) * modifier;
    temp_b <= unsigned(b_in_8) * modifier;
    
    r_out_8 <= std_logic_vector(temp_r(temp_r'length - 2 downto r_out_8'length));
    g_out_8 <= std_logic_vector(temp_g(temp_g'length - 2 downto g_out_8'length));
    b_out_8 <= std_logic_vector(temp_b(temp_b'length - 2 downto b_out_8'length));
    
end Behavioral;
