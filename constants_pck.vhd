library dot_matrix_sim;
package constants is
 
    constant clock_period : time := 0.25 ns; 
    
      -- Lattice iCEstick has a 12 MHz oscillator
    constant clock_frequency : real := 12.0e6;
 
    constant baud_rate : natural := 115200;
 
      -- How long each LED shall be lit in microseconds
    constant led_pulse_time_us : natural := 1000; -- 1 / (1000e-6 * 8) = 125 Hz
    
      -- Deadband in microseconds subtracted from led_pulse_time_us
  constant led_deadband_time_us : natural := 10;
   
end package; 