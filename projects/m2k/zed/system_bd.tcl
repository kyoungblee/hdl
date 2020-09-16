source ../../common/zed/zed_system_bd.tcl

set_property name sys_100m_rstgen [get_bd_cells sys_200m_rstgen]

#Use the 100 MHz clock for video DMA, the AXI interface clock is to slow for this in this project.
ad_ip_parameter sys_ps7 CONFIG.PCW_FPGA1_PERIPHERAL_FREQMHZ 100.0
#Use the 200 MHz clock for pixel clock
#ad_ip_parameter sys_ps7 CONFIG.PCW_FPGA2_PERIPHERAL_FREQMHZ 200.0


set video_dma_clocks [list \
  axi_hp0_interconnect/aclk \
  sys_ps7/S_AXI_HP0_ACLK \
  axi_hdmi_dma/m_src_axi_aclk \
  axi_hdmi_dma/m_axis_aclk \
  axi_hdmi_core/vdma_clk
]

set video_dma_resets [list \
  axi_hp0_interconnect/aresetn \
]

source ../common/m2k_bd.tcl

# disconnect_bd_net /sys_cpu_resetn [get_bd_pins axi_hp0_interconnect/aresetn]
# ad_connect sys_100m_rstgen/peripheral_aresetn axi_hp0_interconnect/aresetn
#
# disconnect_bd_net /sys_cpu_clk [get_bd_pins axi_hp0_interconnect/aclk]
# connect_bd_net [get_bd_pins axi_hp0_interconnect/aclk] [get_bd_pins sys_ps7/FCLK_CLK1]
#
# disconnect_bd_net /sys_cpu_clk [get_bd_pins sys_ps7/S_AXI_HP0_ACLK]
# connect_bd_net [get_bd_pins sys_ps7/S_AXI_HP0_ACLK] [get_bd_pins sys_ps7/FCLK_CLK1]
#
# disconnect_bd_net /sys_cpu_clk [get_bd_pins axi_hdmi_dma/m_src_axi_aclk]
# connect_bd_net [get_bd_pins axi_hdmi_dma/m_src_axi_aclk] [get_bd_pins sys_ps7/FCLK_CLK1]
#
# disconnect_bd_net /sys_cpu_clk [get_bd_pins axi_hdmi_dma/m_axis_aclk]
# connect_bd_net [get_bd_pins axi_hdmi_dma/m_axis_aclk] [get_bd_pins sys_ps7/FCLK_CLK1]
#
# disconnect_bd_net /sys_cpu_resetn [get_bd_pins axi_hdmi_dma/m_src_axi_aresetn]
# connect_bd_net [get_bd_pins axi_hdmi_dma/m_src_axi_aresetn] [get_bd_pins sys_100m_rstgen/peripheral_aresetn]
#
# #connect_bd_net [get_bd_pins axi_hp0_interconnect/aresetn] [get_bd_pins sys_100m_rstgen/peripheral_aresetn]
#
# disconnect_bd_net /sys_cpu_clk [get_bd_pins axi_hdmi_core/vdma_clk]
# connect_bd_net [get_bd_pins axi_hdmi_core/vdma_clk] [get_bd_pins sys_ps7/FCLK_CLK1]

ad_ip_parameter axi_hdmi_clkgen CONFIG.VCO_DIV 4
ad_ip_parameter axi_hdmi_clkgen CONFIG.VCO_MUL 37.125
ad_ip_parameter axi_hdmi_clkgen CONFIG.CLK0_DIV 6.250
#ad_ip_parameter axi_hdmi_clkgen CONFIG.CLK0_PHASE 245.344

ad_ip_instance proc_sys_reset video_dma_reset
ad_connect sys_ps7/FCLK_CLK1 video_dma_reset/slowest_sync_clk
ad_connect sys_rstgen/peripheral_aresetn video_dma_reset/ext_reset_in

foreach clk $video_dma_clocks {
  ad_disconnect /sys_cpu_clk $clk
  ad_connect $clk sys_ps7/FCLK_CLK1
}

foreach rst $video_dma_resets {
  ad_disconnect /sys_cpu_resetn $rst
  ad_connect $rst video_dma_reset/peripheral_aresetn
}

#system ID
ad_ip_parameter axi_sysid_0 CONFIG.ROM_ADDR_BITS 9
ad_ip_parameter rom_sys_0 CONFIG.PATH_TO_FILE "[pwd]/mem_init_sys.txt"
ad_ip_parameter rom_sys_0 CONFIG.ROM_ADDR_BITS 9
set sys_cstring "sys rom custom string placeholder"
sysid_gen_sys_init_file $sys_cstring
