--Copyright 1986-2015 Xilinx, Inc. All Rights Reserved.
----------------------------------------------------------------------------------
--Tool Version: Vivado v.2015.4_AR67478_AR66782_AR66772_AR66092_AR65813_ar68397_cr964221_2015_4 (win64) Build 1412921 Wed
--              Nov 18 09:43:45 MST 2015
--Date        : Mon Jun 19 10:34:57 2017
--Host        : 1062Q running 64-bit Service Pack 1  (build 7601)
--Command     : generate_target d_mcs_wrapper.bd
--Design      : d_mcs_wrapper
--Purpose     : IP block netlist
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
library UNISIM;
use UNISIM.VCOMPONENTS.ALL;
entity d_mcs_wrapper is
  port (
    clock_rtl : in STD_LOGIC;
    gpio_rtl_tri_i : in STD_LOGIC_VECTOR ( 31 downto 0 );
    gpio_rtl_tri_o : out STD_LOGIC_VECTOR ( 31 downto 0 );
    reset_rtl : in STD_LOGIC
  );
end d_mcs_wrapper;

architecture STRUCTURE of d_mcs_wrapper is
  component d_mcs is
  port (
    gpio_rtl_tri_i : in STD_LOGIC_VECTOR ( 31 downto 0 );
    gpio_rtl_tri_o : out STD_LOGIC_VECTOR ( 31 downto 0 );
    clock_rtl : in STD_LOGIC;
    reset_rtl : in STD_LOGIC
  );
  end component d_mcs;
begin
d_mcs_i: component d_mcs
     port map (
      clock_rtl => clock_rtl,
      gpio_rtl_tri_i(31 downto 0) => gpio_rtl_tri_i(31 downto 0),
      gpio_rtl_tri_o(31 downto 0) => gpio_rtl_tri_o(31 downto 0),
      reset_rtl => reset_rtl
    );
end STRUCTURE;
