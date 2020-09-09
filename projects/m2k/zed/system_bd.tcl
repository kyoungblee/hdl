
source ../../common/zed/zed_system_bd.tcl
source ../common/m2k_bd.tcl

set_property name sys_100m_rstgen [get_bd_cells sys_200m_rstgen]

#Use the 100 MHz clock for video DMA, the AXI interface clock is to slow for this in this project.
ad_ip_parameter sys_ps7 CONFIG.PCW_FPGA1_PERIPHERAL_FREQMHZ 100.0
ad_ip_parameter axi_hdmi_clkgen CONFIG.VCO_DIV 4
ad_ip_parameter axi_hdmi_clkgen CONFIG.VCO_MUL 37.125
ad_ip_parameter axi_hdmi_clkgen CONFIG.CLK0_DIV 6.250


set video_dma_clocks [list \
  axi_hp0_interconnect/ACLK \
  axi_hp0_interconnect/M00_ACLK \
  axi_hp0_interconnect/S00_ACLK \
  sys_ps7/S_AXI_HP0_ACLK \
  axi_hdmi_dma/m_src_axi_aclk \
  axi_hdmi_dma/m_axis_aclk \
  axi_hdmi_core/vdma_clk
]


disconnect_bd_net /sys_cpu_resetn [get_bd_pins axi_hp0_interconnect/aresetn]
ad_connect sys_100m_rstgen/peripheral_aresetn axi_hp0_interconnect/aresetn

disconnect_bd_net /sys_cpu_clk [get_bd_pins axi_hp0_interconnect/aclk]
connect_bd_net [get_bd_pins axi_hp0_interconnect/aclk] [get_bd_pins sys_ps7/FCLK_CLK1]

disconnect_bd_net /sys_cpu_clk [get_bd_pins sys_ps7/S_AXI_HP0_ACLK]
connect_bd_net [get_bd_pins sys_ps7/S_AXI_HP0_ACLK] [get_bd_pins sys_ps7/FCLK_CLK1]

disconnect_bd_net /sys_cpu_clk [get_bd_pins axi_hdmi_dma/m_src_axi_aclk]
connect_bd_net [get_bd_pins axi_hdmi_dma/m_src_axi_aclk] [get_bd_pins sys_ps7/FCLK_CLK1]

disconnect_bd_net /sys_cpu_clk [get_bd_pins axi_hdmi_dma/m_axis_aclk]
connect_bd_net [get_bd_pins axi_hdmi_dma/m_axis_aclk] [get_bd_pins sys_ps7/FCLK_CLK1]

disconnect_bd_net /sys_cpu_resetn [get_bd_pins axi_hdmi_dma/m_src_axi_aresetn]
connect_bd_net [get_bd_pins axi_hdmi_dma/m_src_axi_aresetn] [get_bd_pins sys_100m_rstgen/peripheral_aresetn]

#connect_bd_net [get_bd_pins axi_hp0_interconnect/aresetn] [get_bd_pins sys_100m_rstgen/peripheral_aresetn]

disconnect_bd_net /sys_cpu_clk [get_bd_pins axi_hdmi_core/vdma_clk]
connect_bd_net [get_bd_pins axi_hdmi_core/vdma_clk] [get_bd_pins sys_ps7/FCLK_CLK1]
