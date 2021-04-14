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
	constant ZERO : std_logic_vector(7 downto 0) := "00110000";
	constant TOP : integer := 32;

    type t_arr is array (0 to 31) of std_logic_vector(7 downto 0);
	
	signal chars : t_arr;
	signal current_byte : std_logic_vector(7 downto 0);
	signal index : integer := 31;
	signal busy_tx_temp : std_logic;

begin

    tx0 : serial_transmitter port map(data=>current_byte, enable=>enable, clock=>clk, tx=>tx, busy=>busy_tx_temp);
    
    led <= busy_tx_temp;
    current_byte <= chars(index);
    
    -- assign all of the bytes their values
    process (cr,cb,luma,invert,ftb) begin
        -- luminance
        for i in 0 to 8 loop
            chars(i) <= ZERO;
            chars(i)(7) <= luma(i);
        end loop;
        
        chars(9) <= DELIM;
        
        -- chrominance red
        for i in 10 to 17 loop
            chars(i) <= ZERO;
            chars(i)(7) <= cr(i - 10);
        end loop;
        
        chars(18) <= DELIM;
        
        -- chrominance blue
        for i in 19 to 26 loop
            chars(i) <= ZERO;
            chars(i)(7) <= cb(i - 19);
        end loop;
        
        chars(27) <= DELIM;
        chars(28) <= ZERO;
        chars(28)(7) <= invert;
        chars(29) <= DELIM;
        chars(30) <= ZERO;
        chars(30)(7) <= ftb;
        chars(31) <= EOL;
    end process;
    
    
    
    process (clk, busy_tx_temp)
    begin
    
        if clk = '1' and clk'event then
            if busy_tx_temp = '0' then
                -- send the next byte
                index <= (index + 1) mod 32;
            end if;
        end if;
    
    end process;


end Behavioral;
