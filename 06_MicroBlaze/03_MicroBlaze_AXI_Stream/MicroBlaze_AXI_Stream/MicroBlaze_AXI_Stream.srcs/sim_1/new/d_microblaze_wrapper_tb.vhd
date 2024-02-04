----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 09/07/2017 08:20:50 AM
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
            ACLK : out STD_LOGIC;
            sys_clock : in STD_LOGIC;
            sys_reset : in STD_LOGIC
        );
    end component d_microblaze_wrapper;

    constant clock_period : time := 10 ns;

    signal clock : std_logic := '0';
    signal reset : std_logic := '0';
    signal gpio_in : std_logic_vector(31 downto 0) := "00000000000000000000000000000011";
    signal gpio_out : std_logic_vector(31 downto 0) := "00000000000000000000000000000000";

    signal ACLK : std_logic;

    signal AXI_STR_RXD_tdata : std_logic_vector(31 downto 0) := "00000000000000000000000000000000";
    signal AXI_STR_RXD_tlast : std_logic := '0';
    signal AXI_STR_RXD_tready : std_logic;
    signal AXI_STR_RXD_tvalid : std_logic := '0';

    signal AXI_STR_TXD_tdata : std_logic_vector(31 downto 0);
    signal AXI_STR_TXD_tlast : std_logic;
    signal AXI_STR_TXD_tready : std_logic := '0';
    signal AXI_STR_TXD_tvalid : std_logic;

    signal b_packet_sent : std_logic := '0';
    signal q_counter : std_logic_vector(3 downto 0) := "0000";
    signal r_counter : std_logic_vector(3 downto 0) := "0000";

begin

    uut : d_microblaze_wrapper
    port map(
        AXI_STR_RXD_tdata => AXI_STR_RXD_tdata,
        AXI_STR_RXD_tlast => AXI_STR_RXD_tlast,
        AXI_STR_RXD_tready => AXI_STR_RXD_tready,
        AXI_STR_RXD_tvalid => AXI_STR_RXD_tvalid,
        AXI_STR_TXD_tdata => AXI_STR_TXD_tdata,
        AXI_STR_TXD_tlast => AXI_STR_TXD_tlast,
        AXI_STR_TXD_tready => AXI_STR_TXD_tready,
        AXI_STR_TXD_tvalid => AXI_STR_TXD_tvalid,
        GPIO1_tri_i => gpio_in,
        GPIO2_tri_o => gpio_out,
        ACLK => ACLK,
        sys_clock => clock,
        sys_reset => reset
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
        b_packet_sent <= '1';
        q_counter <= "0000";
        wait for 20us;

        b_packet_sent <= '0';
        q_counter <= "0000";
        wait;
    end process;

    write_process : process
    begin
        if AXI_STR_TXD_tvalid = '1' then
            AXI_STR_TXD_tready <= '1';
        else
            AXI_STR_TXD_tready <= '0';
        end if;
        wait for clock_period / 2;
    end process;

    read_process : process
    begin
        if AXI_STR_RXD_tready = '1' then
            if b_packet_sent = '0' then
                q_counter <= q_counter + '1';

                AXI_STR_RXD_tdata <= "00000000000000000000000000001111";
                AXI_STR_RXD_tvalid <= '1';
                AXI_STR_RXD_tlast <= '0';

                wait for clock_period;
                AXI_STR_RXD_tdata <= "00000000000000000000000000001110";
                AXI_STR_RXD_tvalid <= '1';
                AXI_STR_RXD_tlast <= '0';
                b_packet_sent <= '0';

                wait for clock_period;
                AXI_STR_RXD_tdata <= "00000000000000000000000000001100";
                AXI_STR_RXD_tvalid <= '1';
                AXI_STR_RXD_tlast <= '1';
                b_packet_sent <= '1';

--                wait for clock_period;
--                AXI_STR_RXD_tdata <= "00000000000000000000000000001100";
--                AXI_STR_RXD_tvalid <= '1';
--                AXI_STR_RXD_tlast <= '1';
--                b_packet_sent <= '1';
            else
                AXI_STR_RXD_tvalid <= '0';
                AXI_STR_RXD_tlast <= '0';
            end if;
            wait for clock_period / 2;
        else
            AXI_STR_RXD_tvalid <= '0';
            AXI_STR_RXD_tlast <= '0';
            AXI_STR_RXD_tdata <= "00000000000000000000000000000000";
        end if;

        wait for clock_period / 2;
    end process;

end Behavioral;