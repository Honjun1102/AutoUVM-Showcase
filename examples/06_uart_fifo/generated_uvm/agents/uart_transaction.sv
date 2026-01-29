// AutoUVM生成 - UART Transaction
class uart_transaction extends uvm_sequence_item;
  bit [7:0] data;
  time timestamp;
  time duration;
  
  `uvm_object_utils_begin(uart_transaction)
    `uvm_field_int(data, UVM_ALL_ON)
  `uvm_object_utils_end
  
  function new(string name = "uart_transaction");
    super.new(name);
  endfunction
endclass
