--Copyright 1986-2016 Xilinx, Inc. All Rights Reserved.
----------------------------------------------------------------------------------
--Tool Version: Vivado v.2016.3 (win64) Build 1682563 Mon Oct 10 19:07:27 MDT 2016
--Date        : Sun May 14 21:44:43 2017
--Host        : Win7Pro running 64-bit major release  (build 9200)
--Command     : generate_target d_mcs_wrapper.bd
--Design      : d_mcs_wrapper
--Purpose     : IP block netlist
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
library UNISIM;
use UNISIM.VCOMPONENTS.ALL;

entity d_mcs_wrapper_top is
  port (
    clock_rtl : in STD_LOGIC;
    reset_rtl : in STD_LOGIC;
    uart_rtl_rxd : in STD_LOGIC;
    uart_rtl_txd : out STD_LOGIC;
    uart_clock : in STD_LOGIC
  );
end d_mcs_wrapper_top;

architecture STRUCTURE of d_mcs_wrapper_top is
  component d_mcs_wrapper is
  port (
    clock_rtl : in STD_LOGIC;
    reset_rtl : in STD_LOGIC;
    uart_rtl_rxd : in STD_LOGIC;
    uart_rtl_txd : out STD_LOGIC;
    uart_clock : in STD_LOGIC
  );
  end component d_mcs_wrapper;
begin
d_mcs_wrapper_i: component d_mcs_wrapper
	port map (
		clock_rtl => clock_rtl,
		reset_rtl => reset_rtl,
		uart_rtl_rxd => uart_rtl_rxd,
		uart_rtl_txd => uart_rtl_txd,
		uart_clock => uart_clock
    );
end STRUCTURE;
