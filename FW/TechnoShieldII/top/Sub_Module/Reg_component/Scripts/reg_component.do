# ===================================================================================
# Ecole de Technologie Superieure
# projet de maitrise
# Nom du fichier: fifo.do
# Description:		Script permettant de simuler l'entité fifo
# Auteur: Sebastien Pelletier
# Date: 2007/05/13
# Version: 1.0
# ===================================================================================
quit -sim
vlib work

#vlog sb_ice_ipenc_modelsim.v

#vcom vcomponent_vital.vhd
#vcom sb_ice_syn_vital.vhd
#vcom sb_ice_lc_vital.vhd

vcom  reg_component.vhd
vcom  tb/reg_component_tb.vhd

#vsim  reg_component_tb -L ice
vsim  reg_component_tb

add wave -divider -height 10 reg_component_tb0
add wave -hexadecimal reg_component_tb/*

add wave -divider -height 10 reg_component0
add wave -hexadecimal reg_component_tb/reg_component0/*


run 10 us