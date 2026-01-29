// AutoUVM生成 - 寄存器Transaction
class reg_transaction extends uvm_sequence_item;
  rand bit [3:0] addr;
  rand bit [7:0] data;
  rand bit       write;
  
  `uvm_object_utils_begin(reg_transaction)
    `uvm_field_int(addr, UVM_ALL_ON)
    `uvm_field_int(data, UVM_ALL_ON)
    `uvm_field_int(write, UVM_ALL_ON)
  `uvm_object_utils_end
  
  function new(string name = "reg_transaction");
    super.new(name);
  endfunction
  
  function string convert2string();
    return $sformatf("REG %s: addr=0x%01x data=0x%02x", 
                     write ? "WR" : "RD", addr, data);
  endfunction
endclass
