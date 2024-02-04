----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 10/27/2017 10:07:56 PM
-- Design Name: 
-- Module Name: halfadder_tb - Behavioral
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
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity halfadder_tb is
end halfadder_tb;

architecture Behavioral of halfadder_tb is
    component halfadder
    port (
        in_x : in STD_LOGIC;
        in_y : in STD_LOGIC;
        out_sum : out STD_LOGIC;
        out_carry : out STD_LOGIC
    );
    end component halfadder;

    signal in_x : std_logic := '0';
    signal in_y : std_logic := '0';
    signal out_sum : std_logic;
    signal out_carry : std_logic;

begin

    uut : halfadder
    port map(
        in_x => in_x,
        in_y => in_y,
        out_sum => out_sum,
        out_carry => out_carry
    );

    stim_process : process
    begin
        wait for 10ns;
        in_x <= '0';
        in_y <= '0';
        assert out_sum = '0';
        assert out_carry = '0';

        wait for 10ns;
        in_x <= '1';
        in_y <= '0';
        assert out_sum = '1';
        assert out_carry = '0';

        wait for 10ns;
        in_x <= '0';
        in_y <= '1';
        assert out_sum = '1';
        assert out_carry = '0';

        wait for 10ns;
        in_x <= '1';
        in_y <= '1';
        assert out_sum = '1';
        assert out_carry = '1';

        wait;
    end process;

end Behavioral;
