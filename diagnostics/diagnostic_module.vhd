----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 04/12/2021 11:06:14 AM
-- Design Name: 
-- Module Name: diagnostic_module - Behavioral
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

entity diagnostic_module is
    Port ( clk : in STD_LOGIC;
           led : out STD_LOGIC;
           tx : out STD_LOGIC;
           cr : in STD_LOGIC_VECTOR (7 downto 0);
           cb : in STD_LOGIC_VECTOR (7 downto 0);
           luma : in STD_LOGIC_VECTOR (8 downto 0);
           invert : in STD_LOGIC;
           ftb : in STD_LOGIC;
           enable : in STD_LOGIC);
end diagnostic_module;

architecture Behavioral of diagnostic_module is
    component serial_transmitter
	Port ( data : in  STD_LOGIC_VECTOR (7 downto 0);
           enable : in  STD_LOGIC;
           clock : in  STD_LOGIC;
           tx : out  STD_LOGIC;
           busy : out  STD_LOGIC);
	end component;
	
	constant CLOCK_RATE : integer := 100000000;
	constant BAUD_RATE : integer := 9600; -- bit/sec
	constant CLOCK_PERIOD : integer := CLOCK_RATE / BAUD_RATE;
	constant DELIM : std_logic_vector := x"2c";
	constant EOL : std_logic_vector := x"0a";
	constant ZERO : std_logic_vector(7 downto 0) := "0011000";
	constant TOP : integer := 32;
	
	function place_bit(arr : std_logic_vector(255 downto 0);
	                   index : integer;
	                   val : std_logic) return std_logic_vector is
	   variable char : std_logic_vector := ZERO & val;
	begin
	   if index = 32 then
	       return char & arr(247 downto 0);
	   elsif index = 0 then
	       return arr(255 downto 8) & char;
	   else
	       return arr(255 downto index*8) & char & arr((index-1)*8+7 downto 0);
	   end if;
	end function;

    
	
	signal data_bus : std_logic_vector(256 downto 0); -- all characters go here
	signal current_byte : std_logic_vector(7 downto 0);
	signal index : integer := 0;
	signal busy_tx_temp : std_logic;

begin

    tx0 : serial_transmitter port map(data=>current_byte, enable=>enable, clock=>clk, tx=>tx, busy=>busy_tx_temp);
    
    led <= busy_tx_temp;
    
    -- assign all of the bytes their values
    process (cr,cb,luma,invert,ftb) begin
        
    end process;
    
    
    process (clk)
    begin
    
        if clk = '1' and clk'event then
            for i in 0 to 32 loop
            end loop;
        end if;
    
    end process;


end Behavioral;
