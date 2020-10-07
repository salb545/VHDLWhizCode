vsim -gui dot_matrix_sim.char_rom_tb 
add wave -position end  sim:/char_rom_tb/DUT/clk
add wave -position end  sim:/char_rom_tb/DUT/addr
add wave -position end  sim:/char_rom_tb/DUT/dout
run -all
