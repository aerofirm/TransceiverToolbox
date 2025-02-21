# Disconnect the DAC PACK pins
delete_bd_objs [get_bd_nets util_ad9361_dac_upack_fifo_rd_data_0]
delete_bd_objs [get_bd_nets util_ad9361_dac_upack_fifo_rd_data_1]
delete_bd_objs [get_bd_nets util_ad9361_dac_upack_fifo_rd_data_2]
delete_bd_objs [get_bd_nets util_ad9361_dac_upack_fifo_rd_data_3]
delete_bd_objs [get_bd_nets util_ad9361_dac_upack_fifo_rd_valid]

# Connect fifo valids together
connect_bd_net [get_bd_pins axi_ad9361_dac_fifo/din_valid_in_1] [get_bd_pins axi_ad9361_dac_fifo/din_valid_in_0]
connect_bd_net [get_bd_pins axi_ad9361_dac_fifo/din_valid_in_2] [get_bd_pins axi_ad9361_dac_fifo/din_valid_in_0]
connect_bd_net [get_bd_pins axi_ad9361_dac_fifo/din_valid_in_3] [get_bd_pins axi_ad9361_dac_fifo/din_valid_in_0]
