----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 11/21/2020 09:35:42 PM
-- Design Name: 
-- Module Name: fade_to_black_tb_IM - Behavioral
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
use IEEE.std_logic_textio.all;
use STD.textio.all;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity tmds_signal_gen_tb is
--  Port ( );
end tmds_signal_gen_tb;

architecture test of tmds_signal_gen_tb is

    component tmds_signal_gen
        Port( B_in : in STD_LOGIC_VECTOR ( 7 downto 0 );
            CLK75 : in STD_LOGIC;
            G_in : in STD_LOGIC_VECTOR ( 7 downto 0 );
            R_in : in STD_LOGIC_VECTOR ( 7 downto 0 );
            TMDS_Clk_n : out STD_LOGIC;
            TMDS_Clk_p : out STD_LOGIC;
            TMDS_Data_n : out STD_LOGIC_VECTOR ( 2 downto 0 );
            TMDS_Data_p : out STD_LOGIC_VECTOR ( 2 downto 0 ));
       end component;

    
    -- module signals
    signal r_in, g_in, b_in : std_logic_vector(7 downto 0);
    signal clk75: std_logic := '0';
    signal en : std_logic := '1';
    signal TMDS_Clk_n, TMDS_Clk_p : std_logic;
    signal TMDS_Data_n, TMDS_Data_p : std_logic_vector(2 downto 0);
    -- testbench signals
    file file_INPUT     : text;
    constant input_name : string := "input.csv";

    signal output_name : string(1 to 11);
    signal I : unsigned(3 downto 0) := "1000";
begin
 
    uut : tmds_signal_gen port map(R_in => r_in,
                                   G_in => g_in,
                                   B_in => b_in, 
                                   TMDS_Clk_n => TMDS_Clk_n,
                                   TMDS_Clk_p => TMDS_Clk_p,
                                   TMDS_Data_n => TMDS_Data_n,
                                   TMDS_Data_p => TMDS_Data_p,
                                   clk75 => clk75); 
    clk75 <= not clk75 after 6.67 ns; 

    
    io_print : process
    
    variable v_ILINE    : line;
    variable v_OLINE    : line;
    variable v_COMMA    : character;
    variable r, g, b    : integer; -- the values as read by the input csv
    
    begin

    file_open(file_INPUT, input_name, read_mode);
        
    while not endfile(file_INPUT) loop
        
        readline(file_INPUT, v_ILINE);
        -- read the line
        read(v_ILINE, r);
        read(v_ILINE, v_COMMA);
        read(v_ILINE, g);
        read(v_ILINE, v_COMMA);
        read(v_ILINE, b);
        
        -- pass the data into the modules
        r_in <= std_logic_vector(to_unsigned(r, r_in'length));
        g_in <= std_logic_vector(to_unsigned(g, g_in'length));
        b_in <= std_logic_vector(to_unsigned(b, b_in'length));
        
        wait for 13.34 ns;
        
        

    end loop;
    file_close(file_INPUT);

    wait;
    
    end process io_print;

end test;
