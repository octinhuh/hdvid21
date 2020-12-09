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

entity invert_colors_TB_IM is
--  Port ( );
end invert_colors_TB_IM;

architecture test of invert_colors_TB_IM is

    component invert_colors
        Port ( sel      : in STD_LOGIC;                                 -- Select
               rgb_in   : in STD_LOGIC_VECTOR(23 downto 0);             -- RGB (Input)
               rgb_out  : out STD_LOGIC_VECTOR(23 downto 0));           -- RGB (Output)
       end component;
--UNCOMMENT IF YOU WANT TMDS SIGNAL GEN, BE SURE TO ADD FILES FROM GITHUB
--     component tmds_signal_gen
--        Port( B_in : in STD_LOGIC_VECTOR ( 7 downto 0 );
--            CLK75 : in STD_LOGIC;
--            G_in : in STD_LOGIC_VECTOR ( 7 downto 0 );
--            R_in : in STD_LOGIC_VECTOR ( 7 downto 0 );
--            TMDS_Clk_n : out STD_LOGIC;
--            TMDS_Clk_p : out STD_LOGIC;
--            TMDS_Data_n : out STD_LOGIC_VECTOR ( 2 downto 0 );
--            TMDS_Data_p : out STD_LOGIC_VECTOR ( 2 downto 0 ));
--       end component;
    
    -- module signals
    signal rgb_in, rgb_out : std_logic_vector(23 downto 0);
    signal sel : std_logic := '1';
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
    constant output_name: string := "outputINV.csv";

begin
 
    inv : invert_colors port map(rgb_in => rgb_in,
                                  rgb_out => rgb_out,
                                  sel => sel);
--UNCOMMENT IF YOU WANT TMDS_SIGNAL GEN, BE SURE TO ADD FILES FROM GITHUB                                  
--     tmds : tmds_signal_gen port map(R_in => rgb_out(23 downto 16),
--                                   G_in => rgb_out(15 downto 8),
--                                   B_in => rgb_out(7 downto 0), 
--                                   TMDS_Clk_n => TMDS_Clk_n,
--                                   TMDS_Clk_p => TMDS_Clk_p,
--                                   TMDS_Data_n => TMDS_Data_n,
--                                   TMDS_Data_p => TMDS_Data_p,
--                                   clk75 => clk75); 
--     tmds2 : tmds_signal_gen port map(R_in => rgb_in(23 downto 16),
--                                   G_in => rgb_in(15 downto 8),
--                                   B_in => rgb_in(7 downto 0), 
--                                   TMDS_Clk_n => TMDS_Clk_n2,
--                                   TMDS_Clk_p => TMDS_Clk_p2,
--                                   TMDS_Data_n => TMDS_Data_n2,
--                                   TMDS_Data_p => TMDS_Data_p2,
--                                   clk75 => clk75);
    clk75 <= not clk75 after 6.67 ns; 

    
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
            rgb_in(23 downto 16) <= std_logic_vector(to_unsigned(r, rgb_in(23 downto 16)'length));
            rgb_in(15 downto 8) <= std_logic_vector(to_unsigned(g, rgb_in(15 downto 8)'length));
            rgb_in(7 downto 0) <= std_logic_vector(to_unsigned(b, rgb_in(7 downto 0)'length));
            
            wait for 13.34 ns;
            
            write(v_OLINE, to_integer(unsigned(rgb_out(23 downto 16))));
            write(v_OLINE, string'(","));
            write(v_OLINE, to_integer(unsigned(rgb_out(15 downto 8))));
            write(v_OLINE, string'(","));
            write(v_OLINE, to_integer(unsigned(rgb_out(7 downto 0))));
            writeline(file_OUTPUT, v_OLINE);
            

        end loop;
        file_close(file_INPUT);
        file_close(file_OUTPUT);

        
        
        wait;
    
    end process io_print;

end test;
