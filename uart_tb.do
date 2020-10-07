vsim -gui dot_matrix_sim.uart_tb
add wave -position end  sim:/uart_tb/clk
add wave -position end  sim:/uart_tb/rst
add wave -position end  sim:/uart_tb/tx_rx
add wave -position end  sim:/uart_tb/tx_start
add wave -position end  sim:/uart_tb/tx_data
add wave -position end  sim:/uart_tb/tx_busy
add wave -position end  sim:/uart_tb/rx_data
add wave -position end  sim:/uart_tb/rx_valid
add wave -position end  sim:/uart_tb/rx_stop_bit_error