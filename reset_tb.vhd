library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
 
use std.env.finish;
 
library dot_matrix_sim;
use dot_matrix_sim.sim_subprograms.all;
 
entity reset_tb is
end reset_tb; 
 
architecture sim of reset_tb is
 
  -- DUT signals
  signal clk : std_logic := '1';
  signal rst_in : std_logic := '1'; -- Pullup
  signal rst_out : std_logic;
 
begin
 
 
  DUT : entity dot_matrix_sim.reset(rtl)
  port map (
    clk => clk,
    rst_in => rst_in,
    rst_out => rst_out
  );
 
  PROC_SEQUENCER : process
  begin
 
    assert rst_out = '1'
      report "rst_out was not asserted on power-on"
      severity failure;
     
    wait for 200 ns; -- TODO: delete later
    print_test_ok;
    finish;
  end process; -- PROC_SEQUENCER
  
  
    ------------- CLOCK PRODUCING PROCESS -------------------------------
  
    clk_process: process
    
  begin
    
  clk <= '0';
  wait for 5 ns;
  clk <= '1';
  wait for 5 ns;
  
  end process;
  
------------- END CLOCK PRODUCING PROCESS -------------------------------
  

 
end architecture;