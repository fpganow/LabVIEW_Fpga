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

entity halfadder_wrapper is
  port (
    in_x : in STD_LOGIC;
    in_y : in STD_LOGIC;
    out_sum : out STD_LOGIC;
    out_carry : out STD_LOGIC
  );
end halfadder_wrapper;

architecture STRUCTURE of halfadder_wrapper is
  component halfadder is
  port (
    in_x : in STD_LOGIC;
    in_y : in STD_LOGIC;
    out_sum : out STD_LOGIC;
    out_carry : out STD_LOGIC
  );
  end component halfadder;
begin

halfadder_i: component halfadder
	port map (
		in_x => in_x,
        in_y => in_y,
        out_sum => out_sum,
        out_carry => out_carry
    );
end STRUCTURE;
