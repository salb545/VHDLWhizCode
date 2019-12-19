vsim -gui dot_matrix_sim.advanced_char_buf_tb
add wave -position end  sim:/char_buf_tb/DUT/clk
add wave -position end  sim:/char_buf_tb/DUT/rst
add wave -position end  sim:/char_buf_tb/DUT/wr
add wave -position end  sim:/char_buf_tb/DUT/din
add wave -position end  sim:/char_buf_tb/DUT/dout