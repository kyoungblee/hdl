
set_property shreg_extract no [get_cells -hier -filter {name =~ *rx_rate*}]
set_property shreg_extract no [get_cells -hier -filter {name =~ *tx_rate*}]
set_property shreg_extract no [get_cells -hier -filter {name =~ *d_xfer_state*}]
set_property shreg_extract no [get_cells -hier -filter {name =~ *up_xfer_toggle*}]
set_property shreg_extract no [get_cells -hier -filter {name =~ *up_rx_rst_done*}]
set_property shreg_extract no [get_cells -hier -filter {name =~ *up_tx_rst_done*}]

set_false_path -to [get_cells -hier -filter {name =~ *rx_rate_m1_reg* && IS_SEQUENTIAL}]
set_false_path -to [get_cells -hier -filter {name =~ *tx_rate_m1_reg* && IS_SEQUENTIAL}]
set_false_path -to [get_cells -hier -filter {name =~ *up_rx_rst_done_m1_reg && IS_SEQUENTIAL}]
set_false_path -to [get_cells -hier -filter {name =~ *up_tx_rst_done_m1_reg && IS_SEQUENTIAL}]
set_false_path -to [get_cells -hier -filter {name =~ *d_xfer_state_m1_reg && IS_SEQUENTIAL}]
set_false_path -to [get_cells -hier -filter {name =~ *up_xfer_toggle_m1_reg && IS_SEQUENTIAL}]
set_false_path -to [get_cells -hier -filter {name =~ *up_data_status* && IS_SEQUENTIAL}]

