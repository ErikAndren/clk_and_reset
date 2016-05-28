library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

use work.Types.all;

entity clk_and_reset is
        port (
        sys_clk_pad_i  : in  bit1;
        tck_pad_i      : in  bit1;
        eth_clk_pad_i  : in  bit1;
        rst_pad_i      : in  bit1;
        soft_reset_i   : in  bit1;
        tc_clk_i       : in  bit1;
        --
        sdram_clk_o    : out bit1;
        dbg_tck_o      : out bit1;
        --
        wb_clk_o       : out bit1;
        wb_rst_o       : out bit1;
        --
        eth_clk_o      : out bit1;
        eth_rst_o      : out bit1;
        eth0_phy_rst_n : out bit1;
        --
        tc_clk_o       : out bit1;
        --
        sys_rst_o      : out bit1
        );
end entity;

architecture rtl of clk_and_reset is
  signal sys_clk_100_MHz    : bit1;
  signal rst_sync_100_MHz   : bit1;
  signal rst_async          : bit1;
  --
  signal wb_clk_50_MHz      : bit1;
  signal wb_rst_sync_50_MHz : bit1;
  
begin
  sys_clk_100_MHz <= sys_clk_pad_i;
  sdram_clk_o     <= sys_clk_100_MHz;
  --
  tc_clk_o        <= tc_clk_i;
  dbg_tck_o       <= tck_pad_i;
  --
  eth_clk_o       <= eth_clk_pad_i;
  eth_rst_o       <= wb_rst_sync_50_MHz;
  eth0_phy_rst_n  <= not wb_rst_sync_50_MHz;
  --
  rst_async       <= rst_pad_i;
  --
  wb_clk_o        <= wb_clk_50_MHz;
  wb_rst_o        <= wb_rst_sync_50_MHz;
  --
  sys_rst_o       <= rst_sync_100_MHz;
  
  wb_clk_50_MHz_gen : process (sys_clk_100_MHz, rst_sync_100_MHz)
  begin
    if (rst_sync_100_MHz = '1') then
      wb_clk_50_MHz <= '0';
    elsif (rising_edge(sys_clk_100_MHz)) then
      wb_clk_50_MHz <= not wb_clk_50_MHz;
    end if;
  end process;

  rst_gen_block : block
    signal rst_sync_100_MHz_meta : bit1;
    signal rst_sync_100_MHz_ff   : bit1;
    --
    signal wb_rst_sync_50_MHz_meta : bit1;
    signal wb_rst_sync_50_MHz_ff   : bit1;
    
  begin
    sys_clk_100_MHz_rst_gen : process (sys_clk_100_MHz, rst_async)
    begin
      if (rst_async = '1') then
        rst_sync_100_MHz_meta <= '1';
        rst_sync_100_MHz_ff   <= '1';
      elsif (rising_edge(sys_clk_100_MHz)) then
        rst_sync_100_MHz_meta <= rst_async;
        rst_sync_100_MHz_ff   <= rst_sync_100_MHz_meta;
      end if;
    end process;
    rst_sync_100_MHz <= rst_sync_100_MHz_ff;

    wb_clk_50_MHz_rst_gen : process (wb_clk_50_MHz, rst_async)
    begin
      if (rst_async = '1') then
        wb_rst_sync_50_MHz_meta <= '1';
        wb_rst_sync_50_MHz_ff   <= '1';
      elsif (rising_edge(wb_clk_50_MHz)) then
        wb_rst_sync_50_MHz_meta <= rst_async;
        wb_rst_sync_50_MHz_ff   <= wb_rst_sync_50_MHz_meta;
      end if;
    end process;
    wb_rst_sync_50_MHz <= wb_rst_sync_50_MHz_ff;
  end block;
end architecture rtl;
