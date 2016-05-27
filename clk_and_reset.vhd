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
  signal sys_clk : bit1;
  signal rst_sync : bit1;
  signal rst_async : bit1;

  signal wb_clk : bit1;
  
begin
  sys_clk <= sys_clk_pad_i;
  rst_async <= rst_pad_i;
  
  Wb_clk_gen : process (sys_clk, rst_sync)
  begin
    if (rst_sync = '1') then
      wb_clk <= '0';
    elsif (rising_edge(sys_clk)) then
      wb_clk <= not wb_clk;
    end if;
  end process;

  rst_gen_block : block
    signal rst_sync_meta : bit1;
    signal rst_sync_ff   : bit1;
  begin
    sys_clk_rst_gen : process (sys_clk, rst_async)
    begin
      if (rst_async = '1') then
        rst_sync_meta <= '1';
        rst_sync_ff   <= '1';
      elsif (rising_edge(sys_clk)) then
        rst_sync_meta <= rst_async;
        rst_sync_ff   <= rst_sync_meta;
      end if;
    end process;
  end block;

end architecture rtl;
