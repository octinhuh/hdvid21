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

entity fade_to_black_tb_IM is
--  Port ( );
end fade_to_black_tb_IM;

architecture test of fade_to_black_tb_IM is

    component fade_to_black
        Port( r_in_8 : in std_logic_vector(7 downto 0);
              g_in_8 : in std_logic_vector(7 downto 0);
              b_in_8 : in std_logic_vector(7 downto 0);
              r_out_8 : out std_logic_vector(7 downto 0);
              g_out_8 : out std_logic_vector(7 downto 0);
              b_out_8 : out std_logic_vector(7 downto 0);
              clk: in std_logic;
              en : in std_logic;
              int_clk : in std_logic);
       end component;

    
    -- module signals
    signal r_in, g_in, b_in, r_out, g_out, b_out : std_logic_vector(7 downto 0);
    signal clk, int_clk : std_logic := '0';
    signal en : std_logic := '1';
    -- testbench signals
    file file_INPUT     : text;
    file file_OUTPUT    : text;
    constant input_name : string := "input.csv";
    constant output_name: string := "output.csv";
    constant num_frames : integer := 180;
begin
 
    fade : fade_to_black port map(r_in_8 => r_in,
                                  g_in_8 => g_in,
                                  b_in_8 => b_in, 
                                  r_out_8 => r_out,
                                  g_out_8 => g_out,
                                  b_out_8 => b_out,
                                  en => en,
                                  clk => clk,
                                  int_clk => int_clk);

    process
    begin
    
        wait for 19.8 ms;
        en <= '0'; -- toggle the enable, now fade FROM black
        wait;
    
    end process;
    
    io_print : process
    
    variable v_ILINE    : line;
    variable v_OLINE    : line;
    variable v_COMMA    : character;
    variable r, g, b    : integer; -- the values as read by the input csv
    
    variable frame : integer := 0;
    
    begin

        file_open(file_OUTPUT, output_name, write_mode);
        
        while frame < num_frames loop
        
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
                
                clk <= '0';
                wait for 10 ns;
                
                write(v_OLINE, to_integer(unsigned(r_out)));
                write(v_OLINE, string'(","));
                write(v_OLINE, to_integer(unsigned(g_out)));
                write(v_OLINE, string'(","));
                write(v_OLINE, to_integer(unsigned(b_out)));
                writeline(file_OUTPUT, v_OLINE);
                
            end loop;
            
            for I in 0 to 1024 / num_frames loop
                clk <= '0';
                wait for 1 ns;
                clk <= '1';
                wait for 1 ns;
            end loop;
            
            frame := frame + 1;
            file_close(file_INPUT);
            
        end loop;
        
        file_close(file_OUTPUT);

        wait;
    
    end process io_print;

end test;
