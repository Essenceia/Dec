--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   21:42:11 11/03/2021
-- Design Name:   
-- Module Name:   /home/ise/Documents/decode/op_type_test.vhd
-- Project Name:  decode
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: decode_op_type
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
 
ENTITY op_type_test IS
END op_type_test;
 
ARCHITECTURE behavior OF op_type_test IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT decode_op_type
    PORT(
         op_i : IN  std_logic_vector(7 downto 0);
         is_int_o : OUT  std_logic;
         is_float_o : OUT  std_logic;
         is_ctl_o : OUT  std_logic
        );
    END COMPONENT;
    

   --Inputs
   signal op_i : std_logic_vector(7 downto 0) := (others => '0');

 	--Outputs
   signal is_int_o : std_logic;
   signal is_float_o : std_logic;
   signal is_ctl_o : std_logic;
   -- No clocks detected in port list. Replace clk below with 
   -- appropriate port name 
 
   constant clk_period : time := 10 ns;
	signal clk : std_logic;
	signal op_next : std_logic_vector(7 downto 0) := (others => '0');
	signal op_q    : std_logic_vector(7 downto 0) := (others => '0');
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: decode_op_type PORT MAP (
          op_i => op_i,
          is_int_o => is_int_o,
          is_float_o => is_float_o,
          is_ctl_o => is_ctl_o
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
      --wait for 10 ns;	
		for ii in 0 to 255 loop
      op_i <=  std_logic_vector(to_unsigned(ii,8));
      wait for 10 ns;
		end loop;
		 
      wait for clk_period*10;

      -- insert stimulus here 
      wait;
   end process;

END;
