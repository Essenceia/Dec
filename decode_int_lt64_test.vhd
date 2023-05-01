--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   02:51:56 11/04/2021
-- Design Name:   
-- Module Name:   /home/ise/Documents/decode/decode_int_lt64_test.vhd
-- Project Name:  decode
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: decode_int_lt_64
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
 
ENTITY decode_int_lt64_test IS
END decode_int_lt64_test;
 
ARCHITECTURE behavior OF decode_int_lt64_test IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT decode_int_lt_64
    PORT(
         op_i : IN  std_logic_vector(5 downto 0);
         add_rs_o : OUT  std_logic;
         add_m_o : OUT  std_logic;
         sub_r_o : OUT  std_logic;
         sub_m_o : OUT  std_logic;
         mul_r_o : OUT  std_logic;
         mul_m_o : OUT  std_logic
        );
    END COMPONENT;
    

   --Inputs
   signal op_i : std_logic_vector(5 downto 0) := (others => '0');

 	--Outputs
   signal add_rs_o : std_logic;
   signal add_m_o : std_logic;
   signal sub_r_o : std_logic;
   signal sub_m_o : std_logic;
   signal mul_r_o : std_logic;
   signal mul_m_o : std_logic;
   -- No clocks detected in port list. Replace clk below with 
   -- appropriate port name 
	signal clk: std_logic;
   constant clk_period : time := 10 ns;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: decode_int_lt_64 PORT MAP (
          op_i => op_i,
          add_rs_o => add_rs_o,
          add_m_o => add_m_o,
          sub_r_o => sub_r_o,
          sub_m_o => sub_m_o,
          mul_r_o => mul_r_o,
          mul_m_o => mul_m_o
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
      for ii in 0 to 64 loop
			op_i <=  std_logic_vector(to_unsigned(ii,6));
			wait for 10 ns;
		end loop;

      wait for clk_period*10;

      -- insert stimulus here 

      wait;
   end process;

END;
