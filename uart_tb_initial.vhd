library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
 
use std.env.finish;
 
 
library dot_matrix_sim;
use dot_matrix_sim.sim_subprograms.all;
use dot_matrix_sim.sim_fifo.all;
use dot_matrix_sim.constants.all;
 
entity uart_tb_initial is
end uart_tb_initial; 
 
architecture sim of uart_tb_initial is
 
  -- Common signals
  signal clk : std_logic := '1';
  signal rst : std_logic := '1';
  signal tx_rx : std_logic := '1';
 
  -- UART_TX signals
  signal tx_start : std_logic := '0';
  signal tx_data : std_logic_vector(7 downto 0) := (others => '0');
  signal tx_busy : std_logic; 
 
  -- UART_RX signals
  signal rx_data : std_logic_vector(7 downto 0);
  signal rx_valid : std_logic;
  signal rx_stop_bit_error : std_logic;
 
  -- TB FIFO for storing the transmitted characters
  shared variable fifo : sim_fifo;
 
begin
 

 
  UART_TX : entity dot_matrix_sim.uart_tx(rtl)
  port map (
    clk => clk,
    rst => rst,
    start => tx_start,
    data => tx_data,
    busy => tx_busy,
    tx => tx_rx
  );
 
  UART_RX : entity dot_matrix_sim.uart_rx(rtl)
  port map (
    clk => clk,
    rst => rst,
    rx => tx_rx,
    data => rx_data,
    valid => rx_valid,
    stop_bit_error => rx_stop_bit_error
  );
 
  PROC_SEQUENCER : process
  
 ---------------- THINK OF PROCEDURES AS FUNCTIONS --------------------------------
 
 
 
    -- Start the transmission of one character and add it to the TB FIFO
    procedure transmit(constant data : std_logic_vector(tx_data'range)) is  
    begin
      tx_start <= '1';
      tx_data <= data;
      fifo.push(to_integer(unsigned(data)));
      report "Transmit: " & integer'image(to_integer(unsigned(data))); -- INTEGER'IMAGE CONVERTS TO STRING  
      --- TRANSMIT CAN ALSO BE USED TO SHOW TIME OF OCCURANCE 
      wait until rising_edge(clk);
      tx_start <= '0';
      tx_data <= (others => 'X'); --- GIVES OUTPUT OF X ONCE END OF TRANSMISSION RECEIVED!
      wait until rising_edge(clk);
    end procedure;
    
    
 ---------------- THINK OF PROCEDURES AS FUNCTIONS --------------------------------
 
    --variable tx_data_var : std_logic_vector(7 downto 0) := (others => '1'); 
 
  begin
 
    -- Reset strobe
    for i in 1 to 10 loop
      wait until rising_edge(clk);
    end loop; 
    rst <= '0';
 
    for i in 1 to 10 loop
      wait until rising_edge(clk);  
    end loop;
    
    --report "TO BE Transmitted: " & integer'image(to_integer(unsigned(tx_data_var)));
    transmit(x"AA");
 
    wait for 1 us;
 
    print_test_ok;
    finish;
     
  end process; -- PROC_SEQUENCER
  
  
  ------------- CLOCK PRODUCING PROCESS -------------------------------
  
  clk_process: process
    
  begin
  clk <= '0';
  wait for clock_period /2;
  clk <= '1';
  wait for clock_period /2;
  
  end process;
  
  ------------- END OF CLOCK PROCESS ---------------------------------
 
end architecture;