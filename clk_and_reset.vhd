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
begin
end architecture rtl;
