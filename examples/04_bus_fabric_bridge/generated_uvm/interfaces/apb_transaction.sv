// AutoUVM自动生成 - APB Transaction类

class apb_transaction extends uvm_sequence_item;
  
  rand bit [31:0] addr;
  rand bit [31:0] data;
  rand bit        write;
  rand bit [3:0]  strb;
  rand bit [2:0]  prot;
  
  bit             slverr;
  time            timestamp;
  int             latency;
  
  `uvm_object_utils_begin(apb_transaction)
    `uvm_field_int(addr, UVM_ALL_ON)
    `uvm_field_int(data, UVM_ALL_ON)
    `uvm_field_int(write, UVM_ALL_ON)
    `uvm_field_int(strb, UVM_ALL_ON)
    `uvm_field_int(prot, UVM_ALL_ON)
    `uvm_field_int(slverr, UVM_ALL_ON)
  `uvm_object_utils_end
  
  constraint c_addr_align {
    addr[1:0] == 2'b00;  // 地址4字节对齐
  }
  
  constraint c_strb_valid {
    strb inside {4'b0001, 4'b0011, 4'b1111};  // 1/2/4字节
  }
  
  function new(string name = "apb_transaction");
    super.new(name);
  endfunction
  
  function string convert2string();
    return $sformatf("APB %s: addr=0x%08x data=0x%08x strb=%b",
                     write ? "Write" : "Read", addr, data, strb);
  endfunction
  
endclass

