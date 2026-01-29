// AutoUVM生成 - AXI-Stream Transaction
class axis_transaction extends uvm_sequence_item;
  rand bit [7:0] data;
  rand int       delay;
  
  constraint c_delay {
    delay inside {[0:10]};
  }
  
  `uvm_object_utils_begin(axis_transaction)
    `uvm_field_int(data, UVM_ALL_ON)
    `uvm_field_int(delay, UVM_ALL_ON)
  `uvm_object_utils_end
  
  function new(string name = "axis_transaction");
    super.new(name);
  endfunction
endclass
