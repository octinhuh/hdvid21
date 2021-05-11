library IEEE; 
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.all;
entity betteradc is
    port(
        clk : in STD_LOGIC; --Clock
        data_CR, data_CB : out STD_LOGIC_VECTOR(7 downto 0) := x"00"; --Modified Chrominance Data
        data_LUM : out STD_LOGIC_VECTOR(8 downto 0) := "000000000"; -- Modified Luminance Data
        vaux1_n, vaux1_p, vaux6_n, vaux6_p, vaux13_n,vaux13_p : in STD_LOGIC; --XADC pins
        vsync : in STD_LOGIC; --Vsync to register output per frame.
        led : out STD_LOGIC_VECTOR(3 downto 0) --Diagnostic LED output    
    );
end betteradc;

architecture behavioral of betteradc is
  
  component xadc_wiz_3
        port(
            daddr_in        : in  STD_LOGIC_VECTOR (6 downto 0);     -- Address bus for the dynamic reconfiguration port
            den_in          : in  STD_LOGIC;                         -- Enable Signal for the dynamic reconfiguration port
            do_out          : out  STD_LOGIC_VECTOR (15 downto 0);   -- Output data bus for dynamic reconfiguration port
            drdy_out        : out  STD_LOGIC;                        -- Data ready signal for the dynamic reconfiguration port
            dclk_in         : in  STD_LOGIC;                         -- Clock input for the dynamic reconfiguration port
            vauxp1          : in  STD_LOGIC;                         -- Auxiliary Channel 1
            vauxn1          : in  STD_LOGIC;
            vauxp6          : in  STD_LOGIC;                         -- Auxiliary Channel 6
            vauxn6          : in  STD_LOGIC;
            vauxp13         : in  STD_LOGIC;                         -- Auxiliary Channel 13
            vauxn13         : in  STD_LOGIC;
            busy_out        : out  STD_LOGIC;                        -- ADC Busy signal
            channel_out     : out  STD_LOGIC_VECTOR (4 downto 0);    -- Channel Selection Outputs
            eoc_out         : out  STD_LOGIC                        -- End of Conversion Signal
            
        );
    end component;
    
    -- constants
    constant A0 : std_logic_vector(6 downto 0) := "0010001"; --First Channel on pin A0
    constant A2 : std_logic_vector(6 downto 0) := "0010110"; --Second Channel on pin A2
    constant A5 : std_logic_vector(6 downto 0) := "0011101"; --Third Channel on pin A5

    -- signals
    signal address : std_logic_vector(6 downto 0) := "0010001";
    signal cr_temp, cb_temp, lum_temp: std_logic_vector(15 downto 0);
    signal lum_adjust : std_logic_vector(8 downto 0);
    signal cr_adjust, cb_adjust : std_logic_vector(7 downto 0);
    signal xadc_data : std_logic_vector(15 downto 0);
    signal enable, ready : std_logic;
    signal channel : std_logic_vector(4 downto 0);
    
begin
    adcWiz : xadc_wiz_3 port map(
            daddr_in => address,
            den_in => enable,       
            do_out =>  xadc_data,     
            drdy_out => ready,     
            dclk_in => clk,       
            vauxp1 => vaux1_p,         
            vauxn1 => vaux1_n,        
            vauxp6 => vaux6_p,        
            vauxn6 => vaux6_n,        
            vauxp13 => vaux13_p,      
            vauxn13 => vaux13_n,          
            eoc_out => enable,
            channel_out => channel       
    );
    address <= "00" & channel;
  
    process (ready,clk) begin       
        if ready = '0' and ready'event then
            if channel = A0(4 downto 0) then
                lum_temp <= xadc_data;
            end if;
            if channel = A2(4 downto 0) then
                cb_temp <= xadc_data;
            end if;
            if channel = A5(4 downto 0) then
                cr_temp <= xadc_data;
            end if;
        end if;
    end process;

    process (clk, lum_temp, cb_temp,cr_temp) begin
     --lum_adjust centers luminance from potentiometer, since it a signed 9 bit integer.
     lum_adjust <= lum_temp(15) & std_logic_vector("11111111" - unsigned(lum_temp(14 downto 7)));
     
     --Changes position of potentiometer, allow it to turn to both sides equally.
     if(unsigned(cr_temp(15 downto 8)) > "00100000") then
        cr_adjust <= std_logic_vector(unsigned(cr_temp(15 downto 8)) - "00100000");
     else 
        cr_adjust <= "00000000";
     end if;
     if(unsigned(cb_temp(15 downto 8)) > "00100000") then
        cb_adjust <= std_logic_vector(unsigned(cb_temp(15 downto 8)) - "00100000");
     else 
        cb_adjust <= "00000000";
     end if;
    end process;
    
    process (vsync) begin 
        if(vsync'event and vsync = '1') then  --Registering output per frame.    
         data_CR <= cr_adjust;  
         data_CB <= cb_adjust;
         data_LUM <= lum_adjust XOR "111111111"; --Flips direction of luminance, clockwise is more luminance.

        end if;    
    end process;
    
end behavioral;