----------------------------------------------------------------------------------
-- Company: 
-- Engineer: Austin Grieve
-- 
-- Create Date:    15:03:37 05/28/2020 
-- Design Name: 
-- Module Name:    serial_transmitter - Behavioral 
-- Project Name: 
-- Target Devices: 
-- Tool versions: 
-- Description: Simple UART protocol transmitter
--   Data is sent on the rising edge of enable, and BUSY signal goes high
--   as long as the transmitter is still sending the byte from data input
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

entity serial_transmitter is
    Port ( data : in  STD_LOGIC_VECTOR (7 downto 0);
           enable : in  STD_LOGIC;
           clock : in  STD_LOGIC;
           tx : out  STD_LOGIC;
           busy : out  STD_LOGIC);
end serial_transmitter;

architecture Behavioral of serial_transmitter is

	constant CLOCK_RATE : integer := 100000000;
	constant BAUD_RATE : integer := 9600; -- bit/sec
	constant CLOCK_PERIOD : integer := CLOCK_RATE / BAUD_RATE;
	
	signal bit_num : integer := 0; -- 0 is start bit, 9 is stop bit
	signal counter : integer := 0; -- used by clock divider
	
	signal divided_clock : STD_LOGIC;
	signal busy_temp : STD_LOGIC := '0';
	signal tx_temp : STD_LOGIC := '1';

begin

	tx <= tx_temp;
	busy <= busy_temp;
	
	clk_process : process (clock,divided_clock,counter)
	begin
	
		if clock'event and clock = '1'
		then
			if counter = CLOCK_PERIOD
			then
				counter <= 0;
				divided_clock <= '1'; -- single pulse
			else
				counter <= counter + 1;
				divided_clock <= '0';
			end if;
		else
			counter <= counter;
			divided_clock <= divided_clock;
		end if;
	
	end process clk_process;

	div_clk_process : process (clock,divided_clock,enable,busy_temp,data,tx_temp,bit_num)
	begin
	
		if clock'event and clock = '1' and divided_clock = '1'
		then
			if enable = '0' and busy_temp = '0'
			then
				-- not sending anything, keep a 1 in the output
				tx_temp <= '1';
				busy_temp <= '0';
				bit_num <= 0;
			elsif enable = '1' and busy_temp = '0'
			then
				-- begin sending data, so send start bit
				tx_temp <= '0';
				busy_temp <= '1';
				bit_num <= 0;
			else
				-- busy is high
				if bit_num /= 8
				then
					-- send byte data
					tx_temp <= data(bit_num);
					busy_temp <= '1';
					bit_num <= bit_num + 1;
				else
					-- send stop bit
					tx_temp <= '1';
					busy_temp <= '0';
					bit_num <= 0;
				end if;
			end if;
		else
			tx_temp <= tx_temp;
			busy_temp <= busy_temp;
			bit_num <= bit_num;
		end if;
	
	end process div_clk_process;

end Behavioral;