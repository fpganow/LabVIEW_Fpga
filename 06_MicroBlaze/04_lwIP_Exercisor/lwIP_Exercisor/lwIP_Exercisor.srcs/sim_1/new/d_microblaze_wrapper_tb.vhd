----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 10/29/2017 12:48:10 PM
-- Design Name: 
-- Module Name: d_microblaze_wrapper_tb - Behavioral
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
-- Description: 
-- 
-- Dependencies: 
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
-- 
----------------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
use IEEE.NUMERIC_STD.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity d_microblaze_wrapper_tb is
end d_microblaze_wrapper_tb;

architecture Behavioral of d_microblaze_wrapper_tb is
    component d_microblaze_wrapper is
    port (
        ACLK : out STD_LOGIC;
        AXI_STR_RXD_1_tdata : in STD_LOGIC_VECTOR ( 31 downto 0 );
        AXI_STR_RXD_1_tlast : in STD_LOGIC;
        AXI_STR_RXD_1_tready : out STD_LOGIC;
        AXI_STR_RXD_1_tvalid : in STD_LOGIC;
        AXI_STR_RXD_tdata : in STD_LOGIC_VECTOR ( 31 downto 0 );
        AXI_STR_RXD_tlast : in STD_LOGIC;
        AXI_STR_RXD_tready : out STD_LOGIC;
        AXI_STR_RXD_tvalid : in STD_LOGIC;
        AXI_STR_TXD_1_tdata : out STD_LOGIC_VECTOR ( 31 downto 0 );
        AXI_STR_TXD_1_tlast : out STD_LOGIC;
        AXI_STR_TXD_1_tready : in STD_LOGIC;
        AXI_STR_TXD_1_tvalid : out STD_LOGIC;
        AXI_STR_TXD_tdata : out STD_LOGIC_VECTOR ( 31 downto 0 );
        AXI_STR_TXD_tlast : out STD_LOGIC;
        AXI_STR_TXD_tready : in STD_LOGIC;
        AXI_STR_TXD_tvalid : out STD_LOGIC;
        In0 : in STD_LOGIC_VECTOR ( 0 to 0 );
        In1 : in STD_LOGIC_VECTOR ( 0 to 0 );
        clock_rtl : in STD_LOGIC;
        gpio_rtl_0_tri_o : out STD_LOGIC_VECTOR ( 31 downto 0 );
        gpio_rtl_1_tri_i : in STD_LOGIC_VECTOR ( 31 downto 0 );
        gpio_rtl_2_tri_o : out STD_LOGIC_VECTOR ( 31 downto 0 );
        gpio_rtl_tri_i : in STD_LOGIC_VECTOR ( 31 downto 0 );
        reset_rtl : in STD_LOGIC
    );
end component d_microblaze_wrapper;

constant clock_period : time := 10 ns;

signal ACLK : std_logic;

signal clock : std_logic := '0';
signal reset : std_logic := '0';

signal AXI_STR_RXD_1_tdata : STD_LOGIC_VECTOR ( 31 downto 0 );
signal AXI_STR_RXD_1_tlast : STD_LOGIC;
signal AXI_STR_RXD_1_tready : STD_LOGIC;
signal AXI_STR_RXD_1_tvalid : STD_LOGIC;
signal AXI_STR_RXD_tdata : STD_LOGIC_VECTOR ( 31 downto 0 );
signal AXI_STR_RXD_tlast : STD_LOGIC;
signal AXI_STR_RXD_tready : STD_LOGIC;
signal AXI_STR_RXD_tvalid : STD_LOGIC;
signal AXI_STR_TXD_1_tdata : STD_LOGIC_VECTOR ( 31 downto 0 );
signal AXI_STR_TXD_1_tlast : STD_LOGIC;
signal AXI_STR_TXD_1_tready : STD_LOGIC;
signal AXI_STR_TXD_1_tvalid : STD_LOGIC;
signal AXI_STR_TXD_tdata : STD_LOGIC_VECTOR ( 31 downto 0 );
signal AXI_STR_TXD_tlast : STD_LOGIC;
signal AXI_STR_TXD_tready : STD_LOGIC;
signal AXI_STR_TXD_tvalid : STD_LOGIC;
signal In0 : STD_LOGIC_VECTOR ( 0 to 0 ) := "0";
signal In1 : STD_LOGIC_VECTOR ( 0 to 0 ) := "0";

signal gpio1_in : std_logic_vector(31 downto 0) := "00000000000000000000000000000011";
signal gpio1_out : std_logic_vector(31 downto 0) := "00000000000000000000000000000000";
signal gpio2_in : std_logic_vector(31 downto 0) := "00000000000000000000000000000011";
signal gpio2_out : std_logic_vector(31 downto 0) := "00000000000000000000000000000000";

signal pass : std_logic := '0';

begin

uut : d_microblaze_wrapper
port map(
    ACLK => ACLK,
    AXI_STR_RXD_1_tdata => AXI_STR_RXD_1_tdata,
    AXI_STR_RXD_1_tlast => AXI_STR_RXD_1_tlast,
    AXI_STR_RXD_1_tready => AXI_STR_RXD_1_tready,
    AXI_STR_RXD_1_tvalid => AXI_STR_RXD_1_tvalid,
    AXI_STR_RXD_tdata => AXI_STR_RXD_tdata,
    AXI_STR_RXD_tlast => AXI_STR_RXD_tlast,
    AXI_STR_RXD_tready => AXI_STR_RXD_tready,
    AXI_STR_RXD_tvalid => AXI_STR_RXD_tvalid,
    AXI_STR_TXD_1_tdata => AXI_STR_TXD_1_tdata,
    AXI_STR_TXD_1_tlast => AXI_STR_TXD_1_tlast,
    AXI_STR_TXD_1_tready => AXI_STR_TXD_1_tready,
    AXI_STR_TXD_1_tvalid => AXI_STR_TXD_1_tvalid,
    AXI_STR_TXD_tdata => AXI_STR_TXD_tdata,
    AXI_STR_TXD_tlast => AXI_STR_TXD_tlast,
    AXI_STR_TXD_tready => AXI_STR_TXD_tready,
    AXI_STR_TXD_tvalid => AXI_STR_TXD_tvalid,
    gpio_rtl_tri_i => gpio1_in,
    gpio_rtl_0_tri_o => gpio1_out,
    gpio_rtl_1_tri_i => gpio2_in,
    gpio_rtl_2_tri_o => gpio2_out,
    clock_rtl => clock,
    In0 => In0,
    In1 => In1,
    reset_rtl => reset
);

clock_process : process
begin
    clock <= '0';
    wait for clock_period / 2;
    clock <= '1';
    wait for clock_period / 2;
end process;

test_process : process
begin
    -- test gpio #1
    wait on gpio1_out until gpio1_out = x"00000301";
    gpio1_in <= x"0000000A";
    wait on gpio1_out until gpio1_out = x"00000014";

    gpio1_in <= x"00000000";

    -- test gpio #2
    gpio2_in <= x"00000008";
    wait on gpio2_out until gpio2_out = x"00000010";
    -- check value of gpio1_out

    -- Raise interrupt #0
    wait for 5us;
    In0 <= "1";
    wait for 1us;
    In0 <= "0";

    -- Raise interrupt #1
    wait for 5us;
    In1 <= "1";
    wait for 1us;
    In1 <= "0";

    -- Test
    wait;
end process;


end Behavioral;