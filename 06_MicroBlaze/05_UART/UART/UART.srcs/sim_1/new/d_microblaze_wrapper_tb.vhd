----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 11/11/2017 11:37:00 AM
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

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity d_microblaze_wrapper_tb is
--  Port ( );
end d_microblaze_wrapper_tb;

architecture Behavioral of d_microblaze_wrapper_tb is
    component d_microblaze_wrapper is
        port (
            reset_rtl : in STD_LOGIC;
            clock_rtl : in STD_LOGIC;
            gpio_rtl_0_tri_o : out STD_LOGIC_VECTOR ( 31 downto 0 );
            gpio_rtl_tri_i : in STD_LOGIC_VECTOR ( 31 downto 0 );
            uart_rtl_rxd : in STD_LOGIC;
            uart_rtl_txd : out STD_LOGIC
       );
   end component d_microblaze_wrapper;

  constant clock_period : time := 10 ns;

  signal clock : std_logic := '0';
  signal reset : std_logic := '0';

  signal gpio_in : std_logic_vector(31 downto 0) := x"00000000";
  signal gpio_out : std_logic_vector(31 downto 0) := x"00000000";

  signal rxd : std_logic;
  signal txd : std_logic;
  
begin
    uut : d_microblaze_wrapper
        port map(
            reset_rtl => reset,
            clock_rtl => clock,
            gpio_rtl_0_tri_o => gpio_out,
            gpio_rtl_tri_i => gpio_in,
            uart_rtl_rxd => rxd,
            uart_rtl_txd => txd
        );

  clock_process : process
  begin
      clock <= '0';
      wait for clock_period / 2;
      clock <= '1';
      wait for clock_period / 2;
  end process;

  stim_process : process
  begin
        rxd <= '1';
        wait for 20us;

        reset <= '1';
        wait until gpio_out = x"00000303";

        gpio_in <= x"0000000F";

      wait;
  end process;

end Behavioral;
