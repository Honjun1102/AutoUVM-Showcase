// AutoUVM生成 - I2C Transaction
class i2c_transaction extends uvm_sequence_item;
  bit       start;
  bit       stop;
  bit [6:0] slave_addr;
  bit       read;
  bit [7:0] data;
  bit       ack;
  time      timestamp;
  
  `uvm_object_utils_begin(i2c_transaction)
    `uvm_field_int(start, UVM_ALL_ON)
    `uvm_field_int(stop, UVM_ALL_ON)
    `uvm_field_int(slave_addr, UVM_ALL_ON)
    `uvm_field_int(read, UVM_ALL_ON)
    `uvm_field_int(data, UVM_ALL_ON)
    `uvm_field_int(ack, UVM_ALL_ON)
  `uvm_object_utils_end
  
  function new(string name = "i2c_transaction");
    super.new(name);
  endfunction
  
  function string convert2string();
    string s = "I2C: ";
    if (start) s = {s, "START "};
    if (slave_addr != 0)
      s = {s, $sformatf("ADDR=0x%02x %s ", slave_addr, read ? "RD" : "WR")};
    if (data != 0)
      s = {s, $sformatf("DATA=0x%02x ", data)};
    s = {s, ack ? "ACK" : "NACK"};
    if (stop) s = {s, " STOP"};
    return s;
  endfunction
endclass
