library ieee;
use ieee.std_logic_1164.all;
library dot_matrix_sim;
 
package types is
   
  subtype row_range is natural range 0 to 7;
  subtype col_range is natural range 7 downto 0;
 
  -- Represents the 8x8 LED matrix
  type matrix_type is array (row_range) of std_logic_vector(col_range);
 
  -- The addressable ASCII range
  subtype char_range is natural range 0 to 127;
 
  -- ROM type
  type charmap_type is array (char_range) of matrix_type;
 
end package;




--- ESSENTIALLY AN ARRAY WITHIN AN ARRAY 
--- The "INNER ARRAY" SHOWS WHICH 8 X 8  LED'S TO TURN ON & OFF 
--- THE "OUTER ARRAY" ALLOWS THE PICKING OF ONE OF THE 128 OPTIONS (e.g  A,B,;,  :)  TO PICK


--- REFERENCES: 
--- https://www.vhdl-online.de/courses/system_design/vhdl_language_and_syntax/extended_data_types/arrays 
--- https://surf-vhdl.com/vhdl-array/ 

---- NOTES: 
---- Multidimensional arrays can simply be obtained by defining a new data type as array of another array data type (1). 
---- When accessing its array elements, the selections are processed from left to right,