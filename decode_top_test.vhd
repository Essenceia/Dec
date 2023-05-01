--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   00:26:34 11/13/2021
-- Design Name:   
-- Module Name:   /home/ise/Documents/decode/decode_top_test.vhd
-- Project Name:  decode
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: decode_top
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
 
ENTITY decode_top_test IS
END decode_top_test;
 
ARCHITECTURE behavior OF decode_top_test IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT decode_top
    PORT(
         instr_i : IN  std_logic_vector(63 downto 0);
         iadd_v_o : OUT  std_logic;
         iadd_sub_o : OUT  std_logic;
         iadd_neg_o : OUT  std_logic;
         iadd_rs_v_o : OUT  std_logic;
         imul_v_o : OUT  std_logic;
         imul_shift_o : OUT  std_logic;
         imul_signed_o : OUT  std_logic;
         imul_rcp_v_o : OUT  std_logic;
         irol_v_o : OUT  std_logic;
         irol_left_o : OUT  std_logic;
         ixor_v_o : OUT  std_logic;
         iswap_v_o : OUT  std_logic;
         fswap_v_o : OUT  std_logic;
         fadd_v_o : OUT  std_logic;
         fadd_sub_o : OUT  std_logic;
         fscal_v_o : OUT  std_logic;
         fmul_v_o : OUT  std_logic;
         fdiv_v_o : OUT  std_logic;
         fsqrt_v_o : OUT  std_logic;
         cfround_v_o : OUT  std_logic;
         cbranch_v_o : OUT  std_logic;
         istore_v_o : OUT  std_logic;
         
		 dst_v_o : OUT  std_logic;
		 dst_f_v_o : OUT  std_logic;
         dst_reg_o : OUT  std_logic_vector(1 downto 0);
         dst_o : OUT  std_logic_vector(2 downto 0);
         
		 mem_v_o : OUT  std_logic;
		 mem_f_v_o : OUT  std_logic;
         --  mem_o : OUT  std_logic_vector(32 downto 0);
		sp_lvl_o : OUT  std_logic_vector(2 downto 0);
         
		src_v_o : OUT  std_logic;
		src_f_v_o : OUT  std_logic;
         src_reg_o : OUT  std_logic;
         src_o : OUT  std_logic_vector(2 downto 0);
         isrc_override_v_o : OUT  std_logic;
         isrc_override_o : OUT  std_logic;
			
         mod_shift_o : OUT  std_logic_vector(1 downto 0);
         mod_cond_o : OUT  std_logic_vector(2 downto 0);
         imm32_o : OUT  std_logic_vector(31 downto 0)
        );
    END COMPONENT;
    

	--Inputs
	signal instr_i : std_logic_vector(63 downto 0) := (others => '0');
	
	 --Outputs
	signal iadd_v_o : std_logic;
	signal iadd_sub_o : std_logic;
	signal iadd_neg_o : std_logic;
	signal iadd_rs_v_o : std_logic;
	signal imul_v_o : std_logic;
	signal imul_shift_o : std_logic;
	signal imul_signed_o : std_logic;
	signal imul_rcp_v_o : std_logic;
	signal irol_v_o : std_logic;
	signal irol_left_o : std_logic;
	signal ixor_v_o : std_logic;
	signal iswap_v_o : std_logic;
	signal fswap_v_o : std_logic;
	signal fadd_v_o : std_logic;
	signal fadd_sub_o : std_logic;
	signal fscal_v_o : std_logic;
	signal fmul_v_o : std_logic;
	signal fdiv_v_o : std_logic;
	signal fsqrt_v_o : std_logic;
	signal cfround_v_o : std_logic;
	signal cbranch_v_o : std_logic;
	signal istore_v_o : std_logic;
	 
	signal dst_v_o : std_logic;
	signal dst_f_v_o : std_logic;
	signal dst_reg_o : std_logic_vector(1 downto 0);
	signal dst_o : std_logic_vector(2 downto 0);
	 
	signal mem_v_o : std_logic;
	signal mem_f_v_o : std_logic;
	signal mem_o : std_logic_vector(32 downto 0);
	signal sp_lvl_o : std_logic_vector(2 downto 0);
	 
	signal src_v_o : std_logic;
	signal src_f_v_o : std_logic;
	signal src_reg_o : std_logic;
	signal src_o : std_logic_vector(2 downto 0);
	signal isrc_override_v_o : std_logic;
	signal isrc_override_o : std_logic;
	signal mod_shift_o : std_logic_vector(1 downto 0);
	signal mod_cond_o : std_logic_vector(2 downto 0);
	signal imm32_o : std_logic_vector(31 downto 0);
		
		
	-- No clocks detected in port list. Replace clk below with 
	-- appropriate port name 
	signal op : integer;
	signal clk : std_logic;
	constant clk_period : time := 10 ns;
		
	-- debug signal
	signal debug_dst_reg_R : std_logic;
	signal debug_dst_reg_A : std_logic;
	signal debug_dst_reg_F : std_logic;
	signal debug_dst_reg_E : std_logic;
	signal debug_src_reg_R : std_logic;
	signal debug_src_reg_A : std_logic;
	
	signal src : integer;
	signal dst : integer;
	signal mod_mem : integer;
	signal mod_cond : integer;
	signal debug_sp_lvl_L1 : std_logic;
	signal debug_sp_lvl_L2 : std_logic;
	signal debug_sp_lvl_L3 : std_logic;
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
	uut: decode_top PORT MAP (
		instr_i => instr_i,
		iadd_v_o => iadd_v_o,
		iadd_sub_o => iadd_sub_o,
		iadd_neg_o => iadd_neg_o,
		iadd_rs_v_o => iadd_rs_v_o,
		imul_v_o => imul_v_o,
		imul_shift_o => imul_shift_o,
		imul_signed_o => imul_signed_o,
		imul_rcp_v_o => imul_rcp_v_o,
		irol_v_o => irol_v_o,
		irol_left_o => irol_left_o,
		ixor_v_o => ixor_v_o,
		iswap_v_o => iswap_v_o,
		fswap_v_o => fswap_v_o,
		fadd_v_o => fadd_v_o,
		fadd_sub_o => fadd_sub_o,
		fscal_v_o => fscal_v_o,
		fmul_v_o => fmul_v_o,
		fdiv_v_o => fdiv_v_o,
		fsqrt_v_o => fsqrt_v_o,
		cfround_v_o => cfround_v_o,
		cbranch_v_o => cbranch_v_o,
		istore_v_o => istore_v_o,
		   
		dst_v_o => dst_v_o,
		dst_f_v_o => dst_f_v_o,
		dst_reg_o => dst_reg_o,
		dst_o => dst_o,
		   
		mem_v_o => mem_v_o,
		mem_f_v_o => mem_f_v_o,
		sp_lvl_o => sp_lvl_o,
		   
		src_v_o => src_v_o,
		src_f_v_o => src_f_v_o,
		src_reg_o => src_reg_o,
		src_o => src_o,
		isrc_override_v_o => isrc_override_v_o,
		isrc_override_o => isrc_override_o,
		mod_shift_o => mod_shift_o,
		mod_cond_o => mod_cond_o,
		imm32_o => imm32_o
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
      for ii in 0 to 255 loop
			-- lower 8 bits are op 
			if ( ii mod 2) = 0 then
				src <= 1;
				dst <= 1;
				instr_i(15 downto 8)  <= std_logic_vector(to_unsigned(1,8));
				instr_i(23 downto 16) <= std_logic_vector(to_unsigned(1,8));
			else
				src <= 2;
				dst <= 1;
				instr_i(15 downto 8)  <= std_logic_vector(to_unsigned(1,8));
				instr_i(23 downto 16) <= std_logic_vector(to_unsigned(2,8));
			end if;
			
			op <= ii;
			instr_i(7 downto 0)   <=  std_logic_vector(to_unsigned(ii,8));
			
			
			-- mod
			mod_mem <= ( ii mod 2);
			instr_i(25 downto 24) <= std_logic_vector(to_unsigned(( ii mod 2),2)); -- mod_mem
			mod_cond <= (ii mod 2)+13;
			instr_i(31 downto 28) <= std_logic_vector(to_unsigned((ii mod 2)+13,4)); -- mod_cond
			wait for 10 ns;
		end loop;

      -- insert stimulus here 

      wait;
   end process;
	
	debug_dst_reg_R <= not(dst_reg_o(0) or dst_reg_o(1));
	debug_dst_reg_A <= not(dst_reg_o(1)) and dst_reg_o(0);
	debug_dst_reg_F <= not(dst_reg_o(0)) and dst_reg_o(1);
	debug_dst_reg_E <= dst_reg_o(0) and dst_reg_o(1);
	
	debug_src_reg_R <= not src_reg_o; -- 0
	debug_src_reg_A <= src_reg_o;  -- 1
	
	debug_sp_lvl_L1 <= sp_lvl_o(0);
	debug_sp_lvl_L2 <= sp_lvl_o(1);
	debug_sp_lvl_L3 <= sp_lvl_o(2);
	
	assert_proc: process
   begin		
	
	wait for 1 ns;
	while(true) loop  
	-- assertions
	-- int
	assert not((op >= 0)and(op<= 15))or(iadd_rs_v_o='1') report "iadd_rs_v expected to be 1" severity failure;
	--assert not( ((op >= 16)and(op<= 45)) or ((op >= 84)and(op<= 85)) )or(iadd_v_o='1') report "iadd_v expected to be 1" severity failure;
	assert not((op >= 46)and(op<= 75))or(imul_v_o='1') report "imul_v expected to be 1" severity failure;
	assert not((op >= 76)and(op<= 83))or(imul_rcp_v_o='1') report "imul_rcp_v expected to be 1" severity failure;
	assert not((op >= 86)and(op<= 105))or(ixor_v_o='1') report "ixor_v expected to be 1" severity failure;
	assert not((op >= 106)and(op<= 115))or(irol_v_o='1') report "irol_v expected to be 1" severity failure;
	assert not((op >= 116)and(op<= 119))or(iswap_v_o='1') report "iswap_v expected to be 1" severity failure;
	-- float
	assert not((op >= 120)and(op<= 123))or(fswap_v_o='1') report "fswap_v expected to be 1" severity failure;
	assert not((op >= 124)and(op<= 165))or(fadd_v_o='1') report "fadd_v expected to be 1" severity failure;
	assert not((op >= 166)and(op<= 171))or(fscal_v_o='1') report "fscal_v expected to be 1" severity failure;
	assert not((op >= 172)and(op<= 203))or(fmul_v_o='1') report "fmul_v expected to be 1" severity failure;
	assert not((op >= 204)and(op<= 207))or(fdiv_v_o='1') report "fdiv_v expected to be 1" severity failure;
	assert not((op >= 208)and(op<= 213))or(fsqrt_v_o='1') report "fsqrt_v expected to be 1" severity failure;
	-- ctrl
	assert not(op = 214)or(cfround_v_o='1') report "cfround_v expected to be 1" severity failure;
	assert not((op >= 215)and(op<= 239))or(cbranch_v_o='1') report "cbranch_v expected to be 1" severity failure;
	assert not((op >= 240)and(op<= 255))or(istore_v_o='1') report "istore_v expected to be 1" severity failure;

	-- check registers
	-- int and ctrl only use R for both dst and src
	
	assert not((op >= 0)and(op<= 119))or((debug_dst_reg_R='1') and (debug_src_reg_R='1')) report "int dst and src reg wrong, expecting R (0)" severity failure;
	assert not((op >= 214)and(op<= 255))or((debug_dst_reg_R='1') and (debug_src_reg_R='1')) report "ctrl dst and src reg wrong, expecting R (0)" severity failure;
	-- float
	-- dst = F and E
	assert not((op >= 120)and(op<= 171))or(debug_dst_reg_F='1') report "fscal_r : dst reg wrong, expecting F (2)" severity failure;
	assert not((op >= 172)and(op<= 213))or(debug_dst_reg_E='1') report "fsqrt_r : dst reg wrong, expecting E (3)" severity failure;
	-- src = A
	assert not((op >= 124)and(op<= 139))or(debug_src_reg_A='1') report "fadd_r : src reg wrong, expecting A (1)" severity failure;
	assert not((op >= 145)and(op<= 160))or(debug_src_reg_A='1') report "fsub_r : src reg wrong, expecting A (1)" severity failure;
	assert not((op >= 172)and(op<= 203))or(debug_src_reg_A='1') report "fmul_r : src reg wrong, expecting A (1)" severity failure;
	-- src = R
	assert not((op >= 140)and(op<= 144))or(debug_src_reg_R='1') report "fadd_m : src reg wrong, expecting R (0)" severity failure;
	assert not((op >= 161)and(op<= 165))or(debug_src_reg_R='1') report "fsub_m : src reg wrong, expecting R (0)" severity failure;
	assert not((op >= 204)and(op<= 207))or(debug_src_reg_R='1') report "fdiv_m : src reg wrong, expecting R (0)" severity failure;

	-- check src / mem 
	-- mem
	-- int
	assert not((op >= 16)and(op<= 22))  or(mem_v_o='1' and src_v_o='0' and isrc_override_v_o='0' and mem_f_v_o='0' and src_f_v_o='0') report "iadd_m : expecting only mem_v_o valid" severity failure;
	assert not((op >= 39)and(op<= 45))  or(mem_v_o='1' and src_v_o='0' and isrc_override_v_o='0' and mem_f_v_o='0' and src_f_v_o='0') report "isub_m : expecting only mem_v_o valid" severity failure;
	assert not((op >= 62)and(op<= 65))  or(mem_v_o='1' and src_v_o='0' and isrc_override_v_o='0' and mem_f_v_o='0' and src_f_v_o='0') report "imul_m : expecting only mem_v_o valid" severity failure;
	assert not((op >= 70)and(op<= 70))  or(mem_v_o='1' and src_v_o='0' and isrc_override_v_o='0' and mem_f_v_o='0' and src_f_v_o='0') report "imulh_m : expecting only mem_v_o valid" severity failure;
	assert not((op >= 75)and(op<= 75))  or(mem_v_o='1' and src_v_o='0' and isrc_override_v_o='0' and mem_f_v_o='0' and src_f_v_o='0') report "ismulh_m : expecting only mem_v_o valid" severity failure;
	assert not((op >= 101)and(op<= 105))or(mem_v_o='1' and src_v_o='0' and isrc_override_v_o='0' and mem_f_v_o='0' and src_f_v_o='0') report "ixor_m : expecting only mem_v_o valid" severity failure;
	-- float
	assert not((op >= 140)and(op<= 144))or(mem_f_v_o='1' and src_f_v_o='0' and mem_v_o='0' and src_v_o='0' and isrc_override_v_o='0' ) report "fadd_m : expecting only mem_v_o valid" severity failure;
	assert not((op >= 161)and(op<= 165))or(mem_f_v_o='1' and src_f_v_o='0' and mem_v_o='0' and src_v_o='0' and isrc_override_v_o='0' ) report "fsub_m : expecting only mem_v_o valid" severity failure;
	assert not((op >= 204)and(op<= 207))or(mem_f_v_o='1' and src_f_v_o='0' and mem_v_o='0' and src_v_o='0' and isrc_override_v_o='0' ) report "fdiv_m : expecting only mem_v_o valid" severity failure;
	
	-- src
	-- int
	-- src != dst
	assert (src = dst) or not((op >= 0)and(op<= 15))   or(mem_v_o='0' and src_v_o='1' and isrc_override_v_o='0' and mem_f_v_o='0' and src_f_v_o='0') report "iadd_rs : src != dst, expecting only src_v_o valid" severity failure;
	assert (src = dst) or not((op >= 23)and(op<= 38))  or(mem_v_o='0' and src_v_o='1' and isrc_override_v_o='0' and mem_f_v_o='0' and src_f_v_o='0') report "isub_r : src != dst, expecting only src_v_o valid" severity failure;
	assert (src = dst) or not((op >= 46)and(op<= 61))  or(mem_v_o='0' and src_v_o='1' and isrc_override_v_o='0' and mem_f_v_o='0' and src_f_v_o='0') report "imul_r : src != dst, expecting only src_v_o valid" severity failure;
	assert (src = dst) or not((op >= 66)and(op<= 69))  or(mem_v_o='0' and src_v_o='1' and isrc_override_v_o='0' and mem_f_v_o='0' and src_f_v_o='0') report "imulh_r : src != dst, expecting only src_v_o valid" severity failure;
	assert (src = dst) or not((op >= 71)and(op<= 74))  or(mem_v_o='0' and src_v_o='1' and isrc_override_v_o='0' and mem_f_v_o='0' and src_f_v_o='0') report "ismulh_r : src != dst, expecting only src_v_o valid" severity failure;
	assert (src = dst) or not((op >= 86)and(op<= 100)) or(mem_v_o='0' and src_v_o='1' and isrc_override_v_o='0' and mem_f_v_o='0' and src_f_v_o='0') report "ixor_r : src != dst, expecting only src_v_o valid" severity failure;
	assert (src = dst) or not((op >= 106)and(op<= 119))or(mem_v_o='0' and src_v_o='1' and isrc_override_v_o='0' and mem_f_v_o='0' and src_f_v_o='0') report "irol_r/iswap_r : src != dst, expecting only src_v_o valid" severity failure;
	-- src == dst
	assert (src /= dst) or not((op >= 0)and(op<= 15))   or(mem_v_o='0' and src_v_o='0' and isrc_override_v_o='1' and isrc_override_o='1' and mem_f_v_o='0' and src_f_v_o='0') report "iadd_rs : src == dst, expecting isrc_override_v valid with correct override value" severity failure;
	assert (src /= dst) or not((op >= 23)and(op<= 38))  or(mem_v_o='0' and src_v_o='0' and isrc_override_v_o='1' and isrc_override_o='0' and mem_f_v_o='0' and src_f_v_o='0') report "isub_r : src == dst, expecting isrc_override_v valid with correct override value" severity failure;
	assert (src /= dst) or not((op >= 46)and(op<= 61))  or(mem_v_o='0' and src_v_o='0' and isrc_override_v_o='1' and isrc_override_o='0' and mem_f_v_o='0' and src_f_v_o='0') report "imul_r : src == dst, expecting isrc_override_v valid with correct override value" severity failure;
	assert (src /= dst) or not((op >= 66)and(op<= 69))  or(mem_v_o='0' and src_v_o='0' and isrc_override_v_o='1' and isrc_override_o='1' and mem_f_v_o='0' and src_f_v_o='0') report "imulh_r : src == dst, expecting isrc_override_v valid with correct override value" severity failure;
	assert (src /= dst) or not((op >= 71)and(op<= 74))  or(mem_v_o='0' and src_v_o='0' and isrc_override_v_o='1' and isrc_override_o='1' and mem_f_v_o='0' and src_f_v_o='0') report "ismulh_r : src == dst, expecting isrc_override_v valid with correct override value" severity failure;
	assert (src /= dst) or not((op >= 86)and(op<= 100)) or(mem_v_o='0' and src_v_o='0' and isrc_override_v_o='1' and isrc_override_o='0' and mem_f_v_o='0' and src_f_v_o='0') report "ixor_r : src == dst, expecting isrc_override_v valid with correct override value" severity failure;
	assert (src /= dst) or not((op >= 106)and(op<= 115))or(mem_v_o='0' and src_v_o='0' and isrc_override_v_o='1' and isrc_override_o='0' and mem_f_v_o='0' and src_f_v_o='0') report "irol_r : src == dst, expecting isrc_override_v valid with correct override value" severity failure;
	assert (src /= dst) or not((op >= 116)and(op<= 119))or(mem_v_o='0' and src_v_o='0' and isrc_override_v_o='1' and isrc_override_o='1' and mem_f_v_o='0' and src_f_v_o='0') report "iswap_r : src == dst, expecting isrc_override_v valid with correct override value" severity failure;

	-- float
	assert not((op >= 124)and(op<= 139))or(mem_f_v_o='0' and src_f_v_o='1' and mem_v_o='0' and src_v_o='0' and isrc_override_v_o='0' ) report "fadd_r : expecting only src_f_v_o valid" severity failure;
	assert not((op >= 145)and(op<= 160))or(mem_f_v_o='0' and src_f_v_o='1' and mem_v_o='0' and src_v_o='0' and isrc_override_v_o='0' ) report "fsub_r : expecting only src_f_v_o valid" severity failure;
	assert not((op >= 172)and(op<= 203))or(mem_f_v_o='0' and src_f_v_o='1' and mem_v_o='0' and src_v_o='0' and isrc_override_v_o='0' ) report "fmul_r : expecting only src_f_v_o valid" severity failure;
	-- ctrl
	assert not((op >= 214)and(op<= 214))or(dst_v_o='0' and mem_f_v_o='0' and src_f_v_o='0' and mem_v_o='0' and src_v_o='1' and isrc_override_v_o='0' ) report "cfround : expecting only src_v_o valid" severity failure;
	assert not((op >= 215)and(op<= 239))or(dst_v_o='1' and mem_f_v_o='0' and src_f_v_o='0' and mem_v_o='0' and src_v_o='0' and isrc_override_v_o='0' ) report "cbranch : expecting only dst_v_o valid" severity failure;
	assert not((op >= 240)and(op<= 255))or(dst_v_o='0' and mem_f_v_o='0' and src_f_v_o='0' and mem_v_o='0' and src_v_o='1' and isrc_override_v_o='0' ) report "istore : expecting only src_v_o valid" severity failure;

	-- scratchpad level
	--	condition 	         Scratchpad level
	-- src == dst (read) 	     L3
	-- mod.cond >= 14 (write)    L3
	-- mod.mem == 0 	         L2
	-- mod.mem != 0 	         L1
	-- read and mod mem == 0, src != dst
	assert (src = dst) or (mem_v_o = '0') or (istore_v_o='1') or (mod_mem /= 0) or( debug_sp_lvl_L1='1' and debug_sp_lvl_L2='0' and debug_sp_lvl_L3='0' ) report "src != dst and read and mod_mem == 0: scratchpad level expecting L1" severity failure;
	assert (src = dst) or (mem_v_o = '0') or (istore_v_o='1') or (mod_mem  = 0) or( debug_sp_lvl_L1='0' and debug_sp_lvl_L2='1' and debug_sp_lvl_L3='0' ) report "src != dst and read and mod_mem != 0: scratchpad level expecting L2" severity failure;

	-- if read and src == dst
	assert (src /= dst) or (mem_v_o = '0') or (istore_v_o='1')or( debug_sp_lvl_L1='0' and debug_sp_lvl_L2='0' and debug_sp_lvl_L3='1' ) report "src == dst and read : scratchpad level expecting L3" severity failure;
	-- write
	assert (mem_v_o = '0') or (istore_v_o='0' and (mod_cond >= 14))or( debug_sp_lvl_L1='0' and debug_sp_lvl_L2='0' and debug_sp_lvl_L3='1' ) report "mod_cond>=14 and write : scratchpad level expecting L3" severity failure;


	wait for 10 ns;
	end loop;
end process;

END;
