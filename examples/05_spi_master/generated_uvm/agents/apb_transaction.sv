// AutoUVM生成 - APB Transaction
class apb_transaction extends uvm_sequence_item;
  rand bit [7:0]  addr;
  rand bit [31:0] data;
  rand bit        write;
  
  `uvm_object_utils_begin(apb_transaction)
    `uvm_field_int(addr, UVM_ALL_ON)
    `uvm_field_int(data, UVM_ALL_ON)
    `uvm_field_int(write, UVM_ALL_ON)
  `uvm_object_utils_end
  
  function new(string name = "apb_transaction");
    super.new(name);
  endfunction
  
  function string convert2string();
    return $sformatf("APB %s: addr=0x%02x data=0x%08x", 
                     write ? "WR" : "RD", addr, data);
  endfunction
endclass
