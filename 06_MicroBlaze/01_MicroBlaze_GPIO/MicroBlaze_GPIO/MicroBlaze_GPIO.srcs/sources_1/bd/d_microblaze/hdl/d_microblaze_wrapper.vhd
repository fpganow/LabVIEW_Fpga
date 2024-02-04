--Copyright 1986-2015 Xilinx, Inc. All Rights Reserved.
----------------------------------------------------------------------------------
--Tool Version: Vivado v.2015.4_AR67478_AR66782_AR66772_AR66092_AR65813_ar68397_cr964221_2015_4 (win64) Build 1412921 Wed
--              Nov 18 09:43:45 MST 2015
--Date        : Fri Jun 23 19:22:00 2017
--Host        : Win7U64 running 64-bit Service Pack 1  (build 7601)
--Command     : generate_target d_microblaze_wrapper.bd
--Design      : d_microblaze_wrapper
--Purpose     : IP block netlist
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
library UNISIM;
use UNISIM.VCOMPONENTS.ALL;
entity d_microblaze_wrapper is
  port (
    clock_rtl : in STD_LOGIC;
    gpio_rtl_0_tri_o : out STD_LOGIC_VECTOR ( 31 downto 0 );
    gpio_rtl_tri_i : in STD_LOGIC_VECTOR ( 31 downto 0 );
    reset_rtl : in STD_LOGIC
  );
end d_microblaze_wrapper;

architecture STRUCTURE of d_microblaze_wrapper is
  component d_microblaze is
  port (
    reset_rtl : in STD_LOGIC;
    clock_rtl : in STD_LOGIC;
    gpio_rtl_tri_i : in STD_LOGIC_VECTOR ( 31 downto 0 );
    gpio_rtl_0_tri_o : out STD_LOGIC_VECTOR ( 31 downto 0 )
  );
  end component d_microblaze;
begin
d_microblaze_i: component d_microblaze
     port map (
      clock_rtl => clock_rtl,
      gpio_rtl_0_tri_o(31 downto 0) => gpio_rtl_0_tri_o(31 downto 0),
      gpio_rtl_tri_i(31 downto 0) => gpio_rtl_tri_i(31 downto 0),
      reset_rtl => reset_rtl
    );
end STRUCTURE;
