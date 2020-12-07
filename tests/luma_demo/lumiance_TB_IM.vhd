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

entity luminance_TB_IM is
--  Port ( );
end luminance_TB_IM;

architecture test of luminance_TB_IM is

    component luma_scaler
        Port (             -- Inputs
            y_in    : in STD_LOGIC_VECTOR (7 downto 0);     -- Cb (in)
            scale    : in STD_LOGIC_VECTOR (7 downto 0);     -- Scaling offset
            -- Outputs
            y_out   : out STD_LOGIC_VECTOR (7 downto 0));    -- Cb (out)
       end component;
     component  rgb2ycbcr   
        Port ( r : in STD_LOGIC_VECTOR (7 downto 0);
           g : in STD_LOGIC_VECTOR (7 downto 0);
           b : in STD_LOGIC_VECTOR (7 downto 0);
           y : out STD_LOGIC_VECTOR (7 downto 0);
           cb : out STD_LOGIC_VECTOR (7 downto 0);
           cr : out STD_LOGIC_VECTOR (7 downto 0));
       end component;
       component ycbcr2rgb 
        Port ( y : in STD_LOGIC_VECTOR (7 downto 0);
           cb : in STD_LOGIC_VECTOR (7 downto 0);
           cr : in STD_LOGIC_VECTOR (7 downto 0);
           r : out STD_LOGIC_VECTOR (7 downto 0);
           g : out STD_LOGIC_VECTOR (7 downto 0);
           b : out STD_LOGIC_VECTOR (7 downto 0));
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
    signal r_in, g_in, b_in, r_out, b_out, g_out, y,cb,cr,y_out : std_logic_vector(7 downto 0);
    signal scale : std_logic_vector(7 downto 0); 
    signal clk75: std_logic := '0';
    signal en : std_logic := '1';
    signal TMDS_Clk_n, TMDS_Clk_p : std_logic;
    signal TMDS_Data_n, TMDS_Data_p : std_logic_vector(2 downto 0);
    -- testbench signals
    file file_INPUT     : text;
    file file_OUTPUT    : text;
    constant input_name : string := "input.csv";
    constant output_name: string := "outputLUM.csv";

begin
 
    uut: luma_scaler Port map (           
                                y_in => y,    
                                scale => scale,   
                                y_out => y_out);
       
    uus : rgb2ycbcr  Port map ( 
                               r => r_in,
                               g => g_in,
                               b => b_in,
                               y => y,
                               cb => cb,
                               cr => cr);

    uur : ycbcr2rgb  Port map ( 
                               y => y_out,
                               cb => cb,
                               cr => cr,
                               r => r_out,
                               g => g_out,
                               b => b_out);
--UNCOMMENT IF YOU WANT TMDS_SIGNAL GEN, BE SURE TO ADD FILES FROM GITHUB                                  
--     tmds : tmds_signal_gen port map(R_in => rgb_in(23 downto 16),
--                                   G_in => rgb_in(15 downto 8),
--                                   B_in => rgb_in(7 downto 0), 
--                                   TMDS_Clk_n => TMDS_Clk_n,
--                                   TMDS_Clk_p => TMDS_Clk_p,
--                                   TMDS_Data_n => TMDS_Data_n,
--                                   TMDS_Data_p => TMDS_Data_p,
--                                   clk75 => clk75); 
    clk75 <= not clk75 after 6.67 ns; 
    scale <= "01100010";
    
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
