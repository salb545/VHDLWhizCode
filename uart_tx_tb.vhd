library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
 
use std.env.finish;
 
library dot_matrix_sim;
use dot_matrix_sim.sim_subprograms.all;
use dot_matrix_sim.constants.all;
 
entity uart_tx_tb is
end uart_tx_tb; 
 
architecture sim of uart_tx_tb is
 
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
  begin
 
    -- Reset strobe
    for i in 1 to 10 loop
      wait until rising_edge(clk);
    end loop;
    rst <= '0';
 
    for i in 1 to 10 loop
      wait until rising_edge(clk);
    end loop;
       
    tx_start <= '1';
    tx_data <= x"AA";
    wait until rising_edge(clk);
    tx_start <= '0';
 
    ---wait for 140 ns;
 
    print_test_ok;
    finish;
     
  end process; -- PROC_SEQUENCER
  
  
    ------------- CLOCK PRODUCING PROCESS -------------------------------
  
  clk_process: process
    
  begin
  clk <= '0';
  wait for 0.1 ns;
  clk <= '1';
  wait for 0.1 ns;
  
  end process;
  
------------- END CLOCK PRODUCING PROCESS -------------------------------
  

 
end architecture;