 library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
 
library dot_matrix_sim;
use dot_matrix_sim.types.all;
use dot_matrix_sim.constants.all;


--- This module controls EACH & EVERY DOT of the 8x8 LED Matrix
 
entity led_controller_8x8 is
  
  generic (
    PULSE_TIME_US : natural := led_pulse_time_us;
    DEADBAND_TIME_US : natural := led_deadband_time_us
  );
  
  port (
    clk : in std_logic;
    rst : in std_logic;
    led8x8: in matrix_type; ---- THIS INPUT IS A 64-BIT REPRESENATION OF WHAT LEDS TO "ON" AND WHAT LEDS TO "OFF"
    rows : out std_logic_vector(7 downto 0);
    cols : out std_logic_vector(7 downto 0)
  );
end led_controller_8x8; 
 
 
architecture rtl of led_controller_8x8 is
  
  ---------------------------------------- HOW IS THE LED SWITCHED ON ? -------------------------------
  
  -- Row By Row; illuminating the needed LED's before moving to the next row --------------------------
  -- This MUST be done at a frequency high enough to the point that the naked human eye wont notice the
  -- difference AND AND AND AND the LED's will look like a STABLE IMAGE! 
  
  ------------------------------------------------------------------------------------------------------
  
  
  
  --------------THE FOLLOWING SECTION SHOWS HOW CLOCK CYCLES ARE MANIPULATED TO CONTROL THE LED REPRESENTATION -------
  
  -- The number of clock cycles to light each LED for
  constant clk_cycles_per_pulse : natural
    := natural(clock_frequency / 1.0e6) * PULSE_TIME_US; ---- HOW LONG ILLUMINATE EAACH LED BEFORE MOVING TO THE NEXT ROW
  
  subtype pulse_counter_type is natural range 0 to clk_cycles_per_pulse - 1;
  
    -- The number of clock cycles in the deadband period
  constant clk_cycles_deadband : natural
    := natural(clock_frequency / 1.0e6) * DEADBAND_TIME_US;
 
 
  signal pulse_counter : pulse_counter_type;
  signal row_counter : unsigned(2 downto 0);
  
  --- WHEN WRITING ASSERT STATEMENTS IN NON TEST-BENCH CODE, USE CONSTANTS! -------------
  
begin
  
  -- FILE WONT COMPILE IF THESE ASSERT STATEMENTS FAIL....... 
  
  assert clk_cycles_per_pulse > 0 severity failure; 
  assert clk_cycles_per_pulse < natural(clock_frequency) severity failure;
  assert clk_cycles_per_pulse > clk_cycles_deadband severity failure;
  
  PROC_COUNTER : process(clk)
  begin
    if rising_edge(clk) then
      if rst = '1' then
        pulse_counter <= 0;
        row_counter <= (others => '0');
         
      else
 
        -- When pulse_counter wraps
        if pulse_counter = pulse_counter_type'high then --- IF PULSE COUNTER HAS MAXIMUM POSSIBLE PULSE VALUE 
          pulse_counter <= 0;
          row_counter <= row_counter + 1;
        else
          pulse_counter <= pulse_counter + 1;
        end if;  
      end if;
    end if;
  end process; -- PROC_COUNTER
  
  
  PROC_OUTPUT : process(clk)
  begin
    if rising_edge(clk) then
      if rst = '1' then
        rows <= (others => '0');
        cols <= (others => '0');
         
      else
        rows <= (others => '0');
 
        rows(to_integer(row_counter)) <= '1';
        cols <= led8x8(to_integer(row_counter));
 
        -- This is within the deadband period
        if pulse_counter < clk_cycles_deadband then
          rows <= (others => '0');
          cols <= (others => '0');
        end if;
 
      end if;
    end if;
  end process; -- PROC_OUTPUT
  
  ----- DEADBAND ADDED TO ALLOW SMOOTHER TRANSITION TIME AND TO ENSURE THAT ALL RELEVANT LEDS TURN ON AT ONCE! ------------
 
end architecture;