// AutoUVM生成 - FIFO Status
class fifo_status extends uvm_sequence_item;
  bit       full;
  bit       empty;
  bit [4:0] count;
  
  `uvm_object_utils_begin(fifo_status)
    `uvm_field_int(full, UVM_ALL_ON)
    `uvm_field_int(empty, UVM_ALL_ON)
    `uvm_field_int(count, UVM_ALL_ON)
  `uvm_object_utils_end
  
  function new(string name = "fifo_status");
    super.new(name);
  endfunction
endclass
