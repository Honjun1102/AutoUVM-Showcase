// AutoUVM自动生成 - AXI4 Transaction类

class axi4_transaction extends uvm_sequence_item;
  // 事务类型
  rand bit [3:0]  id;
  rand bit [31:0] addr;
  rand bit [7:0]  len;      // Burst length-1 (0-255)
  rand bit [2:0]  size;     // Bytes per beat
  rand bit [1:0]  burst;    // FIXED/INCR/WRAP
  rand bit [31:0] data[];   // Data array
  rand bit [3:0]  strb[];   // Byte strobes
  
  // 方向
  typedef enum {READ, WRITE} direction_e;
  rand direction_e dir;
  
  // 响应
  bit [1:0] resp;           // OKAY/EXOKAY/SLVERR/DECERR
  
  // 时间戳
  time timestamp;
  int  latency;
  
  `uvm_object_utils_begin(axi4_transaction)
    `uvm_field_int(id, UVM_ALL_ON)
    `uvm_field_int(addr, UVM_ALL_ON)
    `uvm_field_int(len, UVM_ALL_ON)
    `uvm_field_int(size, UVM_ALL_ON)
    `uvm_field_int(burst, UVM_ALL_ON)
    `uvm_field_enum(direction_e, dir, UVM_ALL_ON)
    `uvm_field_array_int(data, UVM_ALL_ON)
    `uvm_field_array_int(strb, UVM_ALL_ON)
    `uvm_field_int(resp, UVM_ALL_ON)
  `uvm_object_utils_end
  
  // 约束
  constraint c_len {
    len inside {[0:15]};  // 限制burst长度
  }
  
  constraint c_size {
    size inside {0, 1, 2};  // 1/2/4 bytes
  }
  
  constraint c_burst {
    burst inside {1, 2};  // INCR or WRAP
  }
  
  constraint c_data_size {
    data.size() == len + 1;
    strb.size() == len + 1;
  }
  
  constraint c_addr_align {
    // 地址必须对齐到size
    addr[1:0] == 2'b00;
  }
  
  function new(string name = "axi4_transaction");
    super.new(name);
  endfunction
  
  function string convert2string();
    string s;
    s = $sformatf("AXI4 %s: id=%0d addr=0x%08x len=%0d size=%0d burst=%0d",
                  dir.name(), id, addr, len, size, burst);
    if (resp != 0)
      s = {s, $sformatf(" resp=%0d", resp)};
    return s;
  endfunction
  
  function void post_randomize();
    // 初始化strb为全1
    foreach (strb[i])
      strb[i] = 4'hF;
  endfunction
  
endclass
