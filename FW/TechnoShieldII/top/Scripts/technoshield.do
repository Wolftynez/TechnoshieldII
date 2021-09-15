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

vlog sb_ice_ipenc_modelsim.v

vcom vcomponent_vital.vhd
vcom sb_ice_syn_vital.vhd
vcom sb_ice_lc_vital.vhd

vcom Sub_module/Stack/stack.vhd
vcom Sub_module/Reg_component/reg_component.vhd
vcom Sub_module/i2c_Warper/I2C_Warper.vhd

vcom  Technoshield_top.vhd
vcom  tb/technoshield_top_tb.vhd

vsim  technoshield_top_tb -L ice

add wave -divider -height 10 technoshield_top0
add wave -hexadecimal technoshield_top0/*
add wave -divider -height 10 Reg
add wave -hexadecimal technoshield_top0/reg_component0/*
add wave -divider -height 10 stack
add wave -hexadecimal technoshield_top0/stack0/*
add wave -divider -height 10 I2Cinst0
add wave -hexadecimal technoshield_top0/I2Cinst0/*

run 125 us