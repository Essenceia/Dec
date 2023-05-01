--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   21:21:18 11/04/2021
-- Design Name:   
-- Module Name:   /home/ise/Documents/decode/decode_float_ge_128_test.vhd
-- Project Name:  decode
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: decode_float_lsb_ge_128
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
 
ENTITY decode_float_ge_128_test IS
END decode_float_ge_128_test;
 
ARCHITECTURE behavior OF decode_float_ge_128_test IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT decode_float_lsb_ge_128
    PORT(
         op_i : IN  std_logic_vector(6 downto 0);
         add_r_o : OUT  std_logic;
         add_m_o : OUT  std_logic;
         sub_r_o : OUT  std_logic;
         sub_m_o : OUT  std_logic;
         scal_r_o : OUT  std_logic;
         mul_r_o : OUT  std_logic;
         div_m_o : OUT  std_logic;
         sqrt_r_o : OUT  std_logic
        );
    END COMPONENT;
    

   --Inputs
   signal op_i : std_logic_vector(6 downto 0) := (others => '0');
	signal op_full : std_logic_vector(7 downto 0) := (others => '0');
 	--Outputs
   signal add_r_o : std_logic;
   signal add_m_o : std_logic;
   signal sub_r_o : std_logic;
   signal sub_m_o : std_logic;
   signal scal_r_o : std_logic;
   signal mul_r_o : std_logic;
   signal div_m_o : std_logic;
   signal sqrt_r_o : std_logic;
   -- No clocks detected in port list. Replace clk below with 
   -- appropriate port name 
	signal clk: std_logic;
   constant clk_period : time := 10 ns;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: decode_float_lsb_ge_128 PORT MAP (
          op_i => op_i,
          add_r_o => add_r_o,
          add_m_o => add_m_o,
          sub_r_o => sub_r_o,
          sub_m_o => sub_m_o,
          scal_r_o => scal_r_o,
          mul_r_o => mul_r_o,
          div_m_o => div_m_o,
          sqrt_r_o => sqrt_r_o
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
       for ii in 120 to 255 loop
			op_full <= std_logic_vector(to_unsigned(ii,8));
			op_i <= std_logic_vector(to_unsigned(ii,7));
			wait for 10 ns;
		end loop;

      -- insert stimulus here 

      wait;
   end process;

END;
