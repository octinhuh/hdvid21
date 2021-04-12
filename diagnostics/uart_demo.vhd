----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    15:44:24 05/28/2020 
-- Design Name: 
-- Module Name:    uart_demo - Behavioral 
-- Project Name: 
-- Target Devices: 
-- Tool versions: 
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
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity uart_demo is
    Port ( CLK50MHZ : in  STD_LOGIC;
			  LED : out STD_LOGIC_VECTOR (0 downto 0);
           TXD : out  STD_LOGIC;
			  RXD : in  STD_LOGIC);
end uart_demo;

architecture Behavioral of uart_demo is
	component serial_transmitter
	Port ( data : in  STD_LOGIC_VECTOR (7 downto 0);
           enable : in  STD_LOGIC;
           clock : in  STD_LOGIC;
           tx : out  STD_LOGIC;
           busy : out  STD_LOGIC);
	end component;
	component serial_receiver
	Port ( clock : in  STD_LOGIC;
           rx : in  STD_LOGIC;
           clear : in  STD_LOGIC; -- resets to 0 when set to 1
			  enable : in STD_LOGIC; -- shifts new data in when 1
           data : out  STD_LOGIC_VECTOR (7 downto 0);
           busy : out  STD_LOGIC); -- high when reading data
	end component;
	
	constant CLOCK_RATE : integer := 100000000;
	constant BAUD_RATE : integer := 9600; -- bit/sec
	constant counter_top : integer := (CLOCK_RATE / BAUD_RATE) - 1; -- cycles to have enable on for tx
	signal counter : integer := 0;
	
	signal enable_tx,enable_rx,clear : STD_LOGIC;
	signal busy_tx_temp,busy_rx_temp,old_busy_rx_temp : STD_LOGIC;
	
	signal data : STD_LOGIC_VECTOR (7 downto 0) := x"00";
	signal tx_done : boolean := false;
	
	for serial1 : serial_receiver use entity work.serial_receiver(Behavioral);

begin

	LED(0) <= busy_tx_temp;
	enable_rx <= '1';
	clear <= '0';

	serial0 : serial_transmitter port map(data=>data,enable=>enable_tx,clock=>CLK50MHZ,tx=>TXD,busy=>busy_tx_temp);
	serial1 : serial_receiver port map(data=>data,enable=>enable_rx,clock=>CLK50MHZ,clear=>clear,rx=>RXD,busy=>busy_rx_temp);

	-- cycle the data_index
	process (CLK50MHZ,busy_rx_temp,enable_tx,old_busy_rx_temp,counter)
	begin
	
		if CLK50MHZ'event and CLK50MHZ = '1' then
			if old_busy_rx_temp <= '1' and busy_rx_temp = '0' then
				if counter /= counter_top then
					counter <= counter + 1;
					enable_tx <= '1';
				else
					counter <= counter;
					enable_tx <= '0';
				end if;
			elsif busy_rx_temp = '1' then
				enable_tx <= '0';
				counter <= 0;
			else
				enable_tx <= enable_tx;
				counter <= counter;
			end if;
			old_busy_rx_temp <= busy_rx_temp;
		else
			old_busy_rx_temp <= old_busy_rx_temp;
			enable_tx <= enable_tx;
			counter <= counter;
		end if;
	
	end process;

end Behavioral;

