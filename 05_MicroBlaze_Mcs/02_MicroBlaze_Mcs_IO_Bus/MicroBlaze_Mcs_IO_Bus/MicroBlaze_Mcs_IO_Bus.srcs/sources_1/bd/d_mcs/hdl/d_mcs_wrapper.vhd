--Copyright 1986-2015 Xilinx, Inc. All Rights Reserved.
----------------------------------------------------------------------------------
--Tool Version: Vivado v.2015.4_AR67478_AR66782_AR66772_AR66092_AR65813_ar68397_cr964221_2015_4 (win64) Build 1412921 Wed
--              Nov 18 09:43:45 MST 2015
--Date        : Sun Jul 16 16:34:48 2017
--Host        : Win7U64 running 64-bit Service Pack 1  (build 7601)
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
    INTC_IRQ : out STD_LOGIC;
    INTC_Interrupt : in STD_LOGIC_VECTOR ( 3 downto 0 );
    IO_BUS_addr_strobe : out STD_LOGIC;
    IO_BUS_address : out STD_LOGIC_VECTOR ( 31 downto 0 );
    IO_BUS_byte_enable : out STD_LOGIC_VECTOR ( 3 downto 0 );
    IO_BUS_read_data : in STD_LOGIC_VECTOR ( 31 downto 0 );
    IO_BUS_read_strobe : out STD_LOGIC;
    IO_BUS_ready : in STD_LOGIC;
    IO_BUS_write_data : out STD_LOGIC_VECTOR ( 31 downto 0 );
    IO_BUS_write_strobe : out STD_LOGIC;
    clock_rtl : in STD_LOGIC;
    gpio1_rtl_tri_i : in STD_LOGIC_VECTOR ( 31 downto 0 );
    gpio1_rtl_tri_o : out STD_LOGIC_VECTOR ( 31 downto 0 );
    gpio2_rtl_tri_o : out STD_LOGIC_VECTOR ( 31 downto 0 );
    gpio3_rtl_tri_o : out STD_LOGIC_VECTOR ( 31 downto 0 );
    reset_rtl : in STD_LOGIC
  );
end d_mcs_wrapper;

architecture STRUCTURE of d_mcs_wrapper is
  component d_mcs is
  port (
    gpio1_rtl_tri_i : in STD_LOGIC_VECTOR ( 31 downto 0 );
    gpio1_rtl_tri_o : out STD_LOGIC_VECTOR ( 31 downto 0 );
    IO_BUS_addr_strobe : out STD_LOGIC;
    IO_BUS_address : out STD_LOGIC_VECTOR ( 31 downto 0 );
    IO_BUS_byte_enable : out STD_LOGIC_VECTOR ( 3 downto 0 );
    IO_BUS_read_data : in STD_LOGIC_VECTOR ( 31 downto 0 );
    IO_BUS_read_strobe : out STD_LOGIC;
    IO_BUS_ready : in STD_LOGIC;
    IO_BUS_write_data : out STD_LOGIC_VECTOR ( 31 downto 0 );
    IO_BUS_write_strobe : out STD_LOGIC;
    gpio2_rtl_tri_o : out STD_LOGIC_VECTOR ( 31 downto 0 );
    clock_rtl : in STD_LOGIC;
    reset_rtl : in STD_LOGIC;
    INTC_IRQ : out STD_LOGIC;
    gpio3_rtl_tri_o : out STD_LOGIC_VECTOR ( 31 downto 0 );
    INTC_Interrupt : in STD_LOGIC_VECTOR ( 3 downto 0 )
  );
  end component d_mcs;
begin
d_mcs_i: component d_mcs
     port map (
      INTC_IRQ => INTC_IRQ,
      INTC_Interrupt(3 downto 0) => INTC_Interrupt(3 downto 0),
      IO_BUS_addr_strobe => IO_BUS_addr_strobe,
      IO_BUS_address(31 downto 0) => IO_BUS_address(31 downto 0),
      IO_BUS_byte_enable(3 downto 0) => IO_BUS_byte_enable(3 downto 0),
      IO_BUS_read_data(31 downto 0) => IO_BUS_read_data(31 downto 0),
      IO_BUS_read_strobe => IO_BUS_read_strobe,
      IO_BUS_ready => IO_BUS_ready,
      IO_BUS_write_data(31 downto 0) => IO_BUS_write_data(31 downto 0),
      IO_BUS_write_strobe => IO_BUS_write_strobe,
      clock_rtl => clock_rtl,
      gpio1_rtl_tri_i(31 downto 0) => gpio1_rtl_tri_i(31 downto 0),
      gpio1_rtl_tri_o(31 downto 0) => gpio1_rtl_tri_o(31 downto 0),
      gpio2_rtl_tri_o(31 downto 0) => gpio2_rtl_tri_o(31 downto 0),
      gpio3_rtl_tri_o(31 downto 0) => gpio3_rtl_tri_o(31 downto 0),
      reset_rtl => reset_rtl
    );
end STRUCTURE;
