----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 10/21/2017 12:55:08 PM
-- Design Name: 
-- Module Name: d_microblaze_wrapper_tb - Behavioral
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
-- Description: 
--    Run for a total of 45 microseconds to see all the results in the simulation
--    Look for the value of gpio_out to go from 0x3001, to 0x1E, to 0x3000
-- Dependencies: 
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
-- 
----------------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

use IEEE.NUMERIC_STD.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity d_microblaze_wrapper_tb is

end d_microblaze_wrapper_tb;

architecture Behavioral of d_microblaze_wrapper_tb is
component d_microblaze_wrapper is
    port (
        clock_rtl : in STD_LOGIC;
        gpi_0_tri_i : in STD_LOGIC_VECTOR ( 31 downto 0 );
        gpo_1_tri_o : out STD_LOGIC_VECTOR ( 31 downto 0 );
        intr : in STD_LOGIC_VECTOR ( 1 downto 0 );
        reset_rtl : in STD_LOGIC
    );
end component d_microblaze_wrapper;

constant clock_period : time := 10 ns;

signal clock : std_logic := '0';
signal reset : std_logic := '0';

signal gpio_in : std_logic_vector(31 downto 0) := "00000000000000000000000000000011";
signal gpio_out : std_logic_vector(31 downto 0) := "00000000000000000000000000000000";

signal intr : STD_LOGIC_VECTOR ( 1 downto 0 ) := "00";

begin
    uut : d_microblaze_wrapper
    port map(
        clock_rtl => clock,
        gpi_0_tri_i => gpio_in,
        gpo_1_tri_o => gpio_out,
        intr => intr,
        reset_rtl => reset
    );

    clock_process : process
    begin
        clock <= '0';
        wait for clock_period / 2;
        clock <= '1';
        wait for clock_period / 2;
    end process;

    interrupt_process : process
    begin
        wait for 40us;
        -- Trigger Interrupt #2
        intr <= "01";
        -- Wait for processor to pick up the interrupt
        wait for clock_period * 4;
        -- De-assert Interrupt
        intr <= "00";

        wait for 80us; -- 455-266 = 

        -- Set GPIO channel #1 to 0xF to see if while loop continues to execute
        -- (and write to GPIO channel #2 0xF x 2 or (0x1E)
        gpio_in <= "00000000000000000000000000001111";

        -- Wait for the GPIO to write 0xF x 2 to channel #2
        wait for 20us; -- 455-266 = 0x1FE
        gpio_in <= "00000000000000000000000011111111";

        -- Trigger Interrupt #1
        intr <= "10";
        -- Wait for processor to pick up the interrupt
        wait for clock_period * 4;
        -- Deassert Interrupt
        intr <= "00";

        wait; 
    end process;

end Behavioral;