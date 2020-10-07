vsim -gui dot_matrix_sim.uart_tb_initial 
add wave -position end  sim:/uart_tb_initial/clk
add wave -position end  sim:/uart_tb_initial/rst
add wave -position end  sim:/uart_tb_initial/tx_rx
add wave -position end  sim:/uart_tb_initial/tx_start
add wave -position end  sim:/uart_tb_initial/tx_data
add wave -position end  sim:/uart_tb_initial/tx_busy
add wave -position end  sim:/uart_tb_initial/rx_data
add wave -position end  sim:/uart_tb_initial/rx_valid
add wave -position end  sim:/uart_tb_initial/rx_stop_bit_error