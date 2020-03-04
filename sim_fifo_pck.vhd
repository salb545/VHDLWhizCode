library ieee;
use ieee.std_logic_1164.all;

library dot_matrix_sim;

---------------- NOTE PROCEDURES AND FUNCTIONS HELP USE VHDL CODE WRITTEN AS "PLAIN SOFTWARE" -----------------

package sim_fifo is
  type sim_fifo is protected
 
    -- Add a new element to the list
    procedure push(constant data : in integer);
 
    -- Return the oldest element from the list without removing it
    impure function peek return integer;
 
    -- Remove and return the oldest element from the list
    impure function pop return integer;
 
    -- Return true if there are 0 elements in the list
    impure function empty return boolean;
 
  end protected;
end package;

--------------------------------------------------------------------------------------------------------------------

package body sim_fifo is
 
  type sim_fifo is protected body
 
    -- A linked list node
    type item;
    type ptr is access item;
    type item is record
      data : integer;
      next_item : ptr;
    end record;
 
    -- Root of the linked list
    variable root : ptr;
 
 ----------- PUSH FUNCTION ----------------------------------
    procedure push(constant data : in integer) is
      variable new_item : ptr;
      variable node : ptr;
    begin
      new_item := new item;
      new_item.data := data;
 
      if root = null then
        root := new_item;
      else
        node := root;
 
        while node.next_item /= null loop
          node := node.next_item;
        end loop;
 
        node.next_item := new_item;
      end if;
    end procedure;
    
    
  -------------- PEEK FUNCTION -------------------------------  
  impure function peek return integer is
    begin
      return root.data;
    end function;
    
    
  --------------- POP FUNCTION ------------------------------
    impure function pop return integer is
      variable node : ptr;
      variable ret_val : integer;
    begin
      node := root;
      root := root.next_item;
 
      ret_val := node.data;
      deallocate(node);
 
      return ret_val;
    end function;
    
  
  ---------------- EMPTY FUNCTION ---------------------------  
  impure function empty return boolean is
    begin
      return root = null;
    end function;
 ------------------------------------------------------------
 
  end protected body;
 
end package body;