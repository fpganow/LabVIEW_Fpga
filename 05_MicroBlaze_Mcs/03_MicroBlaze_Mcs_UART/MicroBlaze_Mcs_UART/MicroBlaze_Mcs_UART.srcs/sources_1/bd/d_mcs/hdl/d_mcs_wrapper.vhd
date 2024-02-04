--Copyright 1986-2015 Xilinx, Inc. All Rights Reserved.
----------------------------------------------------------------------------------
--Tool Version: Vivado v.2015.4_AR67478_AR66782_AR66772_AR66092_AR65813_ar68397_cr964221_2015_4 (win64) Build 1412921 Wed
--              Nov 18 09:43:45 MST 2015
--Date        : Wed Jun 28 23:26:28 2017
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
    clock_rtl : in STD_LOGIC;
    reset_rtl : in STD_LOGIC;
    uart_rtl_rxd : in STD_LOGIC;
    uart_rtl_txd : out STD_LOGIC;
    uart_clock : in STD_LOGIC
  );
end d_mcs_wrapper;

architecture STRUCTURE of d_mcs_wrapper is
  component d_mcs is
  port (
    clock_rtl : in STD_LOGIC;
    reset_rtl : in STD_LOGIC;
    uart_rtl_rxd : in STD_LOGIC;
    uart_rtl_txd : out STD_LOGIC
  );
  end component d_mcs;

--    const uart_clock_period : time = 7812ns;
--    signal test_in_reg : STD_LOGIC;
--    signal test_out_reg : STD_LOGIC;

begin

    d_mcs_i: component d_mcs
        port map (
            clock_rtl => clock_rtl,
            reset_rtl => reset_rtl,
            uart_rtl_rxd => uart_rtl_rxd,
            uart_rtl_txd => uart_rtl_txd
        );

--    uart_process : process(uart_clock)
--    begin
--        if rising_edge(uart_clock) then
--            uart_rtl_txd_top <= test_out_reg;
--            test_in_reg <= uart_rtl_rxd_top;
----            test_out <= test_in;
--        end if;
--    end process uart_process; 
end STRUCTURE;
