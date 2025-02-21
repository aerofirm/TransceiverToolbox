
source $ad_hdl_dir/projects/common/zcu102/zcu102_system_bd.tcl
source $ad_hdl_dir/projects/adrv9001/common/adrv9001_bd.tcl

ad_ip_parameter axi_adrv9001 CONFIG.USE_RX_CLK_FOR_TX [expr $ad_project_params(CMOS_LVDS_N) == 0]

#system ID
ad_ip_parameter axi_sysid_0 CONFIG.ROM_ADDR_BITS 9
ad_ip_parameter rom_sys_0 CONFIG.PATH_TO_FILE "[pwd]/mem_init_sys.txt"
ad_ip_parameter rom_sys_0 CONFIG.ROM_ADDR_BITS 9
set sys_cstring "CMOS_LVDS_N=${ad_project_params(CMOS_LVDS_N)}"
sysid_gen_sys_init_file $sys_cstring

set_property strategy Flow_RunPostRoutePhysOpt [get_runs impl_1]

