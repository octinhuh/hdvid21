----------------------------------------------------------------------------------
-- Company: 
-- Engineer: Austin Grieve
-- 
-- Create Date:    01:13:06 10/24/2020 
-- Design Name: 
-- Module Name:    square_wave_gen - Behavioral 
-- Project Name: 
-- Target Devices: 
-- Tool versions: 
-- Description: A square wave generator, given a period and scaler
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
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity square_wave_gen is
    Port ( period : in  STD_LOGIC_VECTOR (15 downto 0); -- num clock pulses in one cycle
           scale : in  STD_LOGIC_VECTOR (3 downto 0); -- multiply period by 2^(scale)
           enable : in  STD_LOGIC;
			  clock : in STD_LOGIC;
           wave_out : inout  STD_LOGIC);
end square_wave_gen;

architecture Behavioral of square_wave_gen is

	signal period_num, scale_num : integer;
	signal half_period : unsigned(period'length - 1 downto 0);
	signal count : unsigned(period'length - 1 downto 0) := to_unsigned(0, period'length);
	signal scale_count : unsigned((2**scale'length) - 1 downto 0) := to_unsigned(0, 2**scale'length);

begin

	period_num <= to_integer(unsigned(period));
	scale_num <= to_integer(unsigned(scale));
	half_period <= to_unsigned(period_num / 2, half_period'length);

	clock_process : process(clock, scale_count, scale_num, count, enable) begin
			
		if clock'event and clock = '1' then
			scale_count <= scale_count + 1;
			if scale_num = 0 then
				count <= count + 1;
				scale_count <= to_unsigned(0, scale_count'length);
			elsif shift_right(scale_count, scale_num - 1) = to_unsigned(1, scale_count'length) then
				-- can increment count here
				count <= count + 1;
				scale_count <= to_unsigned(0, scale_count'length);
			end if;
			
			if count = unsigned(period) - to_unsigned(1,period'length) or enable = '0' then
				wave_out <= '0';
				count <= to_unsigned(0, count'length);
			elsif count = half_period - to_unsigned(1,half_period'length) then
				wave_out <= '1';
			end if;
		end if;
	end process clock_process;

end Behavioral;

