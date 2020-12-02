----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 12/01/2020 10:18:31 PM
-- Design Name: 
-- Module Name: luma_tb - Behavioral
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

entity luma_tb is
--  Port ( );
end luma_tb;

architecture Behavioral of luma_tb is

    component ycbcr2rgb
        Port ( y : in STD_LOGIC_VECTOR (7 downto 0);
               cb : in STD_LOGIC_VECTOR (7 downto 0);
               cr : in STD_LOGIC_VECTOR (7 downto 0);
               r : out STD_LOGIC_VECTOR (7 downto 0);
               g : out STD_LOGIC_VECTOR (7 downto 0);
               b : out STD_LOGIC_VECTOR (7 downto 0));
    end component;
        
    component rgb2ycbcr
        Port ( r : in STD_LOGIC_VECTOR (7 downto 0);
               g : in STD_LOGIC_VECTOR (7 downto 0);
               b : in STD_LOGIC_VECTOR (7 downto 0);
               y : out STD_LOGIC_VECTOR (7 downto 0);
               cb : out STD_LOGIC_VECTOR (7 downto 0);
               cr : out STD_LOGIC_VECTOR (7 downto 0));
    end component;
        
    component luma_scaler
        Port (
           y_in : in STD_LOGIC_VECTOR (7 downto 0);
           scale : in STD_LOGIC_VECTOR (7 downto 0);
           y_out : out STD_LOGIC_VECTOR (7 downto 0));
    end component;

    for enc : rgb2ycbcr use entity work.rgb2ycbcr(behavioral);
    for dec : ycbcr2rgb use entity work.ycbcr2rgb(behavioral);
    for uut : luma_scaler use entity work.luma_scaler(behavioral);
    
    -- scale to use for luma_scaler
    constant scale : std_logic_vector(7 downto 0) := x"00";
    
    -- module signals
    signal r_in, g_in, b_in, y_in, cb_temp, cr_temp, y_out, r_out, g_out, b_out : std_logic_vector(7 downto 0);
    
    -- testbench signals
    file file_INPUT     : text;
    file file_OUTPUT    : text;
    constant input_name : string := "/home/austin/Documents/SCHOOL/CMPE450/input.csv";
    constant output_name: string := "/home/austin/Documents/SCHOOL/CMPE450/output.csv";

begin

    enc : rgb2ycbcr port map(r=>r_in,g=>g_in,b=>b_in,y=>y_in,cb=>cb_temp,cr=>cr_temp);
    dec : ycbcr2rgb port map(r=>r_out,g=>g_out,b=>b_out,y=>y_out,cb=>cb_temp,cr=>cr_temp);
    uut : luma_scaler port map(y_in=>y_in,scale=>scale,y_out=>y_out);
    
    io_print : process
    
    variable v_ILINE    : line;
    variable v_OLINE    : line;
    variable v_COMMA    : character;
    variable r, g, b    : integer; -- the values as read by the input csv
    
    begin
    
        file_open(file_INPUT, input_name, read_mode);
        file_open(file_OUTPUT, output_name, write_mode);
        
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
            
            wait for 10 ns;
            
            write(v_OLINE, to_integer(unsigned(r_out)));
            write(v_OLINE, string'(","));
            write(v_OLINE, to_integer(unsigned(g_out)));
            write(v_OLINE, string'(","));
            write(v_OLINE, to_integer(unsigned(b_out)));
            writeline(file_OUTPUT, v_OLINE);
        
        end loop;
        
        file_close(file_INPUT);
        file_close(file_OUTPUT);
        wait;
    
    end process io_print;

end Behavioral;
