library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
 
use std.env.finish;
 
 
library dot_matrix_sim;
use dot_matrix_sim.sim_subprograms.all;
use dot_matrix_sim.sim_fifo.all;
use dot_matrix_sim.constants.all;
 
entity dummy is
end dummy; 
 
architecture sim of dummy is
 
 
  -- Common signals
  signal clk : std_logic := '1';
  signal rst : std_logic := '1';
  signal tx_rx : std_logic := '1';
 
  -- UART_TX signals
  signal tx_start : std_logic := '0';
  signal tx_data : std_logic_vector(7 downto 0) := (others => '0');
  signal tx_busy : std_logic ; 
 
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
      --report " Value Officially Transmitted From TX: " & integer'image(to_integer(unsigned(data)));
      tx_data  <= (others => 'X'); --- GIVES OUTPUT OF X ONCE END OF TRANSMISSION RECEIVED!
      wait until rising_edge(clk);
    end procedure;
    
    
    
    procedure wait_until_fifo_empty is
    begin
      while not fifo.empty loop
        wait until rising_edge(clk);
      end loop;
    end procedure;
 
 
   
    
 ---------------- THINK OF PROCEDURES AS FUNCTIONS --------------------------------
 
 --variable tx_data_var : tx_data'subtype := (others => '0'); --- AUTOMATICALLY FOLLOWS THE SAME TYPE AS data ---------
  
  
  variable tx_data_var : std_logic_vector(7 downto 0) := (others => '0'); 
  

  begin
 
    -- Reset strobe
    wait for 10 * clock_period;
    rst <= '0';
  
  

 
 
    ---------------------------- START OF LOOP: CYCLE IN-ORDER TO Test all possible input values -----------------------------------------------
    loop
      
      ---report "TO BE Transmitted: " & integer'image(to_integer(unsigned(tx_data_var)));
      transmit(tx_data_var);
 
 
 
      -- Wait until UART_TX is done
      wait until tx_busy = '0';
      
      
 
      -- Increment the input before the next test
      tx_data_var := std_logic_vector(unsigned(tx_data_var) + 1); --- Gets converted as an UNSIGNED decimal in order to perform calculation
                                                                  --- And is then RE-CONVERTED to std_logic_vector
                                                                  
     --- Report "SUCCESSFULLY INCREAMENTED TO: " & integer'image(to_integer(unsigned(tx_data_var))); 
 
 
 
      -- Exit the loop if all bits are '0'
      if unsigned(tx_data_var) = 0 then --- TRICK TO ENSURE THAT ALL BITS GO BACK TO ZERO UPON COMPLETION 
        exit;
      end if;
      
  end loop;

        ------------------------- END OF LOOP ------------------------------------------- 


 
    print_test_ok;
    finish;
     
  end process; -- PROC_SEQUENCER
  
  
  
  ---------------- NEW RX PROCESS ------------------------------------------------------------------------
  
    -- Check that the output from UART_RX matches the content of the FIFO
  PROC_CHECK_RX : process
    variable expected : integer;
  begin
     
    wait until rx_valid = '1';
 
    -- Get the next transmitted word from the FIFO
    expected := fifo.pop;
 
    -- Check that this is the expected output
    assert to_integer(unsigned(rx_data)) = expected
      report "Output from UART_RX (" & integer'image(to_integer(unsigned(rx_data)))
        & ") doesn't match transmitted word (" & integer'image(expected) & ")"
      severity failure;
 
    report "Received " & integer'image(expected);
 
  end process; -- PROC_CHECK_RX

   
   
  ---------------- END OF RX PROCESS ------------------------------------------------------------------------ 
   
   
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