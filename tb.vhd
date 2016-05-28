library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

use work.Types.all;

entity tb is 
end entity;

architecture beh of tb is
  signal sys_clk_100_MHz   : bit1;
  signal tck_20_MHz        : bit1;
  signal eth_clk_10_MHz    : bit1;
  signal tc_clk_5_MHz      : bit1;
  signal rst               : bit1;
  signal soft_reset        : bit1;
  --
  signal sdram_clk_100_MHz : bit1;
  signal dbg_tck_20_MHz    : bit1;
  signal wb_clk_50_MHz     : bit1;
  signal wb_rst_lvl1       : bit1;
  signal wb_rst_lvl2       : bit1;
  signal eth_rst           : bit1;
  signal eth_phy_rst       : bit1;
  signal tc_clk_o_5_MHz    : bit1;
  signal eth_clk_o_10_MHz  : bit1;
  signal sys_rst_sync      : bit1;

begin
  sys_clk_gen : process
  begin
    while true loop
      sys_clk_100_MHz <= '0';
      wait for 5 ns;
      sys_clk_100_MHz <= '1';
      wait for 5 ns;
    end loop;
  end process;

  tck_gen : process
  begin
    while true loop
      tck_20_MHz <= '0';
      wait for 25 ns;
      tck_20_MHz <= '1';
      wait for 25 ns;
    end loop;
  end process;

  tc_clk_gen : process
  begin
    while true loop
      tc_clk_5_MHz <= '0';
      wait for 100 ns;
      tc_clk_5_MHz <= '1';
      wait for 100 ns;
    end loop;
  end process;
  
  eth_gen : process
  begin
    while true loop
      eth_clk_10_MHz <= '0';
      wait for 50 ns;
      eth_clk_10_MHz <= '1';
      wait for 50 ns;
    end loop;
  end process;
  
  soft_reset <= '0', '1' after 200 ns, '0' after 300 ns;
  rst <= '1', '0' after 100 ns;

  dut : entity work.clk_and_reset
    port map (
      sys_clk_pad_i  => sys_clk_100_MHz,
      tck_pad_i      => tck_20_MHz,
      eth_clk_pad_i  => eth_clk_10_MHz,
      rst_pad_i      => rst,
      soft_reset_i   => soft_reset,
      tc_clk_i       => tc_clk_5_MHz,
      --
      sdram_clk_o    => sdram_clk_100_MHz,
      dbg_tck_o      => dbg_tck_20_MHz,
      wb_clk_o       => wb_clk_50_MHz,
      wb_rst_lvl1_o  => wb_rst_lvl1,
      wb_rst_lvl2_o  => wb_rst_lvl2,
      --
      eth_clk_o      => eth_clk_o_10_MHz,
      eth_rst_o      => eth_rst,
      eth0_phy_rst_n => eth_phy_rst,
      --
      tc_clk_o       => tc_clk_o_5_MHz,
      --
      sys_rst_o      => sys_rst_sync
      );
    
end architecture beh;
