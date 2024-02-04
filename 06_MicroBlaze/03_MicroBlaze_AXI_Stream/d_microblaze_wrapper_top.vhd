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

entity d_microblaze_wrapper_top is
    port (
        GPIO1_tri_i : in STD_LOGIC_VECTOR ( 31 downto 0 );
        GPIO2_tri_o : out STD_LOGIC_VECTOR ( 31 downto 0 );
        AXI_STR_TXD_tdata : out STD_LOGIC_VECTOR ( 31 downto 0 );
        AXI_STR_TXD_tlast : out STD_LOGIC;
        AXI_STR_TXD_tready : in STD_LOGIC;
        AXI_STR_TXD_tvalid : out STD_LOGIC;
        AXI_STR_RXD_tdata : in STD_LOGIC_VECTOR ( 31 downto 0 );
        AXI_STR_RXD_tlast : in STD_LOGIC;
        AXI_STR_RXD_tready : out STD_LOGIC;
        AXI_STR_RXD_tvalid : in STD_LOGIC;
        ACLK : out STD_LOGIC;
        sys_clock : in STD_LOGIC;
        sys_reset : in STD_LOGIC
    );
end d_microblaze_wrapper_top;

architecture STRUCTURE of d_microblaze_wrapper_top is
    component d_microblaze_wrapper is
        port (
        ACLK : out STD_LOGIC;
        AXI_STR_RXD_tdata : in STD_LOGIC_VECTOR ( 31 downto 0 );
        AXI_STR_RXD_tlast : in STD_LOGIC;
        AXI_STR_RXD_tready : out STD_LOGIC;
        AXI_STR_RXD_tvalid : in STD_LOGIC;
        AXI_STR_TXD_tdata : out STD_LOGIC_VECTOR ( 31 downto 0 );
        AXI_STR_TXD_tlast : out STD_LOGIC;
        AXI_STR_TXD_tready : in STD_LOGIC;
        AXI_STR_TXD_tvalid : out STD_LOGIC;
        GPIO1_tri_i : in STD_LOGIC_VECTOR ( 31 downto 0 );
        GPIO2_tri_o : out STD_LOGIC_VECTOR ( 31 downto 0 );
        sys_clock : in STD_LOGIC;
        sys_reset : in STD_LOGIC
    );
    end component d_microblaze_wrapper;
begin

    d_microblaze_i: component d_microblaze_wrapper
    port map (
        ACLK => ACLK,
        AXI_STR_RXD_tdata => AXI_STR_RXD_tdata,
        AXI_STR_RXD_tlast => AXI_STR_RXD_tlast,
        AXI_STR_RXD_tready => AXI_STR_RXD_tready,
        AXI_STR_RXD_tvalid => AXI_STR_RXD_tvalid,
        AXI_STR_TXD_tdata => AXI_STR_TXD_tdata,
        AXI_STR_TXD_tlast => AXI_STR_TXD_tlast,
        AXI_STR_TXD_tready => AXI_STR_TXD_tready,
        AXI_STR_TXD_tvalid => AXI_STR_TXD_tvalid,
        GPIO1_tri_i => GPIO1_tri_i,
        GPIO2_tri_o => GPIO2_tri_o,
        sys_clock => sys_clock,
        sys_reset => sys_reset
    );
end STRUCTURE;
