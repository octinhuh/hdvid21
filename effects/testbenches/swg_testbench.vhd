--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   01:44:13 10/24/2020
-- Design Name:   
-- Module Name:   /home/ise/Desktop/projects/music/swg_testbench.vhd
-- Project Name:  music
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: square_wave_gen
-- 
-- Dependencies:
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
--
-- Notes: 
-- This testbench has been automatically generated using types std_logic and
-- std_logic_vector for the ports of the unit under test.  Xilinx recommends
-- that these types always be used for the top-level I/O of a design in order
-- to guarantee that the testbench will bind correctly to the post-implementation 
-- simulation model.
--------------------------------------------------------------------------------
LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
 
-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--USE ieee.numeric_std.ALL;
 
ENTITY swg_testbench IS
END swg_testbench;
 
ARCHITECTURE behavior OF swg_testbench IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT square_wave_gen
    PORT(
         period : IN  std_logic_vector(15 downto 0);
         scale : IN  std_logic_vector(3 downto 0);
         enable : IN  std_logic;
         clock : IN  std_logic;
         wave_out : INOUT  std_logic
        );
    END COMPONENT;
    

   --Inputs
   signal period : std_logic_vector(15 downto 0) := x"0006";
   signal scale : std_logic_vector(3 downto 0) := (others => '0');
   signal enable : std_logic := '0';
   signal clock : std_logic := '0';

	--BiDirs
   signal wave_out : std_logic;

   -- Clock period definitions
   constant clock_period : time := 10 ns;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: square_wave_gen PORT MAP (
          period => period,
          scale => scale,
          enable => enable,
          clock => clock,
          wave_out => wave_out
        );

   -- Clock process definitions
   clock_process :process
   begin
		clock <= '0';
		wait for clock_period/2;
		clock <= '1';
		wait for clock_period/2;
   end process;
 

   -- Stimulus process
   stim_proc: process
   begin		
      -- hold reset state for 100 ns.
      wait for 100 ns;	

      wait for clock_period*10;

      -- insert stimulus here 
		enable <= '1';

      wait;
   end process;

END;
