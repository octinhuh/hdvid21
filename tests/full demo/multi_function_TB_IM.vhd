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

entity multi_function_TB_IM is
--  Port ( );
end multi_function_TB_IM;

architecture test of multi_function_TB_IM is

    component multiple_mod
        Port (             -- Inputs
                inv_sel : in std_logic;
                lum_scale : in std_logic_vector(8 downto 0);
                cb_scale,cr_scale : in std_logic_vector(7 downto 0);
                r,g,b : in std_logic_vector(7 downto 0);
                r_out,g_out,b_out : out std_logic_vector(7 downto 0)); 
       end component;

--UNCOMMENT IF YOU WANT TMDS SIGNAL GEN, BE SURE TO ADD FILES FROM GITHUB
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
    signal r_in, g_in, b_in, r_out, b_out, g_out : std_logic_vector(7 downto 0);
    signal cb_scale, cr_scale : std_logic_vector(7 downto 0); --Represented as xxx.xxxxx 
    signal lum_scale : std_logic_vector(8 downto 0);
    signal inv_sel : std_logic;
    signal clk75: std_logic := '0';
    signal en : std_logic := '1';
    signal TMDS_Clk_n, TMDS_Clk_p : std_logic;
    signal TMDS_Data_n, TMDS_Data_p : std_logic_vector(2 downto 0);
     signal TMDS_Clk_n2, TMDS_Clk_p2 : std_logic;
    signal TMDS_Data_n2, TMDS_Data_p2 : std_logic_vector(2 downto 0);
    -- testbench signals
    file file_INPUT     : text;
    file file_OUTPUT    : text;
    constant input_name : string := "input.csv";
    constant output_name: string := "outputMUL.csv";

begin
 
    uut: multiple_mod Port map (                 
                                inv_sel => inv_sel,
                                lum_scale => lum_scale,
                                cb_scale => cb_scale,
                                cr_scale => cr_scale,
                                r => r_in,
                                g => g_in,
                                b => b_in,
                                r_out => r_out,
                                g_out => g_out,
                                b_out => b_out      
                                );
       
  
--UNCOMMENT IF YOU WANT TMDS_SIGNAL GEN, BE SURE TO ADD FILES FROM GITHUB                                  
--     tmds : tmds_signal_gen port map(R_in => r_out,
--                                   G_in => g_out,
--                                   B_in => b_out, 
--                                   TMDS_Clk_n => TMDS_Clk_n,
--                                   TMDS_Clk_p => TMDS_Clk_p,
--                                   TMDS_Data_n => TMDS_Data_n,
--                                   TMDS_Data_p => TMDS_Data_p,
--                                   clk75 => clk75); 
--     tmds2 : tmds_signal_gen port map(R_in => r_in,
--                                   G_in => g_in,
--                                   B_in => b_in, 
--                                   TMDS_Clk_n => TMDS_Clk_n2,
--                                   TMDS_Clk_p => TMDS_Clk_p2,
--                                   TMDS_Data_n => TMDS_Data_n2,
--                                   TMDS_Data_p => TMDS_Data_p2,
--                                   clk75 => clk75); 
--    clk75 <= not clk75 after 6.67 ns; 
    cb_scale <= "00100000"; --xxx.xxxxx
    cr_scale <= "00100000";
    lum_scale <= "011100000";
    inv_sel <= '1';
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
            
            wait for 13.34 ns;
            
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

end test;
