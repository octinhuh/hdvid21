----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 12/05/2020 11:24:59 PM
-- Design Name: 
-- Module Name: tmds_signal_gen - Behavioral
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
library UNISIM;
use UNISIM.VCOMPONENTS.ALL;
use IEEE.numeric_std.all;
entity tmds_signal_gen is
  port (
    B_in : in STD_LOGIC_VECTOR ( 7 downto 0 );
    CLK75 : in STD_LOGIC;
    G_in : in STD_LOGIC_VECTOR ( 7 downto 0 );
    R_in : in STD_LOGIC_VECTOR ( 7 downto 0 );
    TMDS_Clk_n : out STD_LOGIC;
    TMDS_Clk_p : out STD_LOGIC;
    TMDS_Data_n : out STD_LOGIC_VECTOR ( 2 downto 0 );
    TMDS_Data_p : out STD_LOGIC_VECTOR ( 2 downto 0 )
  );

end tmds_signal_gen;

architecture Behavioral of tmds_signal_gen is
  component rgb2dvi is
  port (
    TMDS_Clk_p : out STD_LOGIC;
    TMDS_Clk_n : out STD_LOGIC;
    TMDS_Data_p : out STD_LOGIC_VECTOR ( 2 downto 0 );
    TMDS_Data_n : out STD_LOGIC_VECTOR ( 2 downto 0 );
    aRst : in STD_LOGIC;
    aRst_n : in STD_LOGIC;
    vid_pData : in STD_LOGIC_VECTOR ( 23 downto 0 );
    vid_pVDE : in STD_LOGIC;
    vid_pHSync : in STD_LOGIC;
    vid_pVSync : in STD_LOGIC;
    PixelClk : in STD_LOGIC;
    SerialClk : in STD_LOGIC
  );
  end component rgb2dvi;
  component vga_sync is
  port (
    clk : in STD_LOGIC;
    hsync : out STD_LOGIC;
    vsync : out STD_LOGIC;
    pix_clk : out STD_LOGIC;
    blank : out STD_LOGIC
  );
  end component vga_sync;
  component RGB_combiner is
  port (
    RGB_out : out STD_LOGIC_VECTOR ( 23 downto 0 );
    R : in STD_LOGIC_VECTOR ( 7 downto 0 );
    B : in STD_LOGIC_VECTOR ( 7 downto 0 );
    G : in STD_LOGIC_VECTOR ( 7 downto 0 )
  );
  end component RGB_combiner;
  signal B_in_1 : STD_LOGIC_VECTOR ( 7 downto 0 );
  signal CLK75_1 : STD_LOGIC;
  signal G_in_1 : STD_LOGIC_VECTOR ( 7 downto 0 );
  signal RGB_combiner_0_RGB_out : STD_LOGIC_VECTOR ( 23 downto 0 );
  signal R_in_1 : STD_LOGIC_VECTOR ( 7 downto 0 );
  signal rgb2dvi_0_TMDS_Clk_n : STD_LOGIC;
  signal rgb2dvi_0_TMDS_Clk_p : STD_LOGIC;
  signal rgb2dvi_0_TMDS_Data_n : STD_LOGIC_VECTOR ( 2 downto 0 );
  signal rgb2dvi_0_TMDS_Data_p : STD_LOGIC_VECTOR ( 2 downto 0 );
  signal vga_sync_0_blank : STD_LOGIC;
  signal vga_sync_0_hsync : STD_LOGIC;
  signal vga_sync_0_pix_clk : STD_LOGIC;
  signal vga_sync_0_vsync : STD_LOGIC;
  signal NLW_vga_sync_0_hcount_UNCONNECTED : STD_LOGIC_VECTOR ( 10 downto 0 );
  signal NLW_vga_sync_0_vcount_UNCONNECTED : STD_LOGIC_VECTOR ( 10 downto 0 );

begin
  B_in_1(7 downto 0) <= B_in(7 downto 0);
  CLK75_1 <= CLK75;
  G_in_1(7 downto 0) <= G_in(7 downto 0);
  R_in_1(7 downto 0) <= R_in(7 downto 0);
  TMDS_Clk_n <= rgb2dvi_0_TMDS_Clk_n;
  TMDS_Clk_p <= rgb2dvi_0_TMDS_Clk_p;
  TMDS_Data_n(2 downto 0) <= rgb2dvi_0_TMDS_Data_n(2 downto 0);
  TMDS_Data_p(2 downto 0) <= rgb2dvi_0_TMDS_Data_p(2 downto 0);
RGB_combiner_0: component RGB_combiner
     port map (
      B(7 downto 0) => B_in_1(7 downto 0),
      G(7 downto 0) => G_in_1(7 downto 0),
      R(7 downto 0) => R_in_1(7 downto 0),
      RGB_out(23 downto 0) => RGB_combiner_0_RGB_out(23 downto 0)
    );
rgb2dvi_0: component rgb2dvi
     port map (
      PixelClk => vga_sync_0_pix_clk,
      TMDS_Clk_n => rgb2dvi_0_TMDS_Clk_n,
      TMDS_Clk_p => rgb2dvi_0_TMDS_Clk_p,
      TMDS_Data_n(2 downto 0) => rgb2dvi_0_TMDS_Data_n(2 downto 0),
      TMDS_Data_p(2 downto 0) => rgb2dvi_0_TMDS_Data_p(2 downto 0),
      aRst => '0',
      aRst_n => '1',
      vid_pData(23 downto 0) => RGB_combiner_0_RGB_out(23 downto 0),
      vid_pHSync => vga_sync_0_hsync,
      vid_pVDE => vga_sync_0_blank,
      vid_pVSync => vga_sync_0_vsync,
      SerialClk => '0'
    );
vga_sync_0: component vga_sync
     port map (
      blank => vga_sync_0_blank,
      clk => CLK75_1,
      hsync => vga_sync_0_hsync,
      pix_clk => vga_sync_0_pix_clk,
      vsync => vga_sync_0_vsync
    );

end Behavioral;
