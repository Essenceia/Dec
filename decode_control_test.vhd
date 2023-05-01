--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   22:26:01 11/04/2021
-- Design Name:   
-- Module Name:   /home/ise/Documents/decode/decode_control_test.vhd
-- Project Name:  decode
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: decode_control
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
use ieee.numeric_std.all;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--USE ieee.numeric_std.ALL;
 
ENTITY decode_control_test IS
END decode_control_test;
 
ARCHITECTURE behavior OF decode_control_test IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT decode_control
    PORT(
         op_i : IN  std_logic_vector(5 downto 0);
         fround_o : OUT  std_logic;
         branch_o : OUT  std_logic;
         store_o : OUT  std_logic
        );
    END COMPONENT;
    

   --Inputs
   signal op_i : std_logic_vector(5 downto 0) := (others => '0');
	signal op_full : std_logic_vector(7 downto 0) := (others => '0');
 	--Outputs
   signal fround_o : std_logic;
   signal branch_o : std_logic;
   signal store_o : std_logic;
   -- No clocks detected in port list. Replace clk below with 
   -- appropriate port name 
	signal clk: std_logic;
   constant clk_period : time := 10 ns;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: decode_control PORT MAP (
          op_i => op_i,
          fround_o => fround_o,
          branch_o => branch_o,
          store_o => store_o
        );

   -- Clock process definitions
   clk_process :process
   begin
		clk <= '0';
		wait for clk_period/2;
		clk <= '1';
		wait for clk_period/2;
   end process;
 

   -- Stimulus process
   stim_proc: process
   begin		
      -- hold reset state for 100 ns.
       for ii in 210 to 255 loop
			op_full <= std_logic_vector(to_unsigned(ii,8));
			op_i <= std_logic_vector(to_unsigned(ii,6));
			wait for 10 ns;
		end loop;

      -- insert stimulus here 

      wait;
   end process;

END;
