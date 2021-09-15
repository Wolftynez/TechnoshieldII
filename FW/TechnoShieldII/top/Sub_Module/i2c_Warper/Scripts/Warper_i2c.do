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


vcom  I2C_Warper.vhd
vcom  tb/I2C_Warper_tb.vhd

vsim  I2C_Warper_tb -L ice

add wave -divider -height 10 Warper_i2c
add wave -hexadecimal i2c_warper_tb/*
add wave -hexadecimal i2c_warper_tb/warper_i2c0/etat_s
run 250 us