// AutoUVM生成 - I2C读序列
class i2c_read_seq extends uvm_sequence #(reg_transaction);
  `uvm_object_utils(i2c_read_seq)
  
  rand bit [6:0] slave_addr;
  rand int num_bytes;
  
  constraint c_bytes {
    num_bytes inside {[1:10]};
  }
  
  function new(string name = "i2c_read_seq");
    super.new(name);
    slave_addr = 7'h50;
  endfunction
  
  task body();
    reg_transaction tr;
    
    `uvm_info("I2C_SEQ", $sformatf("Reading %0d bytes from slave 0x%02x", 
              num_bytes, slave_addr), UVM_LOW)
    
    // 配置从机地址
    tr = reg_transaction::type_id::create("slave_addr");
    tr.addr = 4'h3;
    tr.write = 1;
    tr.data = {1'b0, slave_addr};
    start_item(tr); finish_item(tr);
    
    for (int i = 0; i < num_bytes; i++) begin
      // 发起读命令
      tr = reg_transaction::type_id::create($sformatf("ctrl_%0d", i));
      tr.addr = 4'h0;
      tr.write = 1;
      tr.data = (i == 0) ? 8'h05 : 8'h04;  // START + READ
      start_item(tr); finish_item(tr);
      
      #5us;
      
      // 读取数据
      tr = reg_transaction::type_id::create($sformatf("data_%0d", i));
      tr.addr = 4'h2;
      tr.write = 0;
      start_item(tr); finish_item(tr);
      
      `uvm_info("I2C_SEQ", $sformatf("Read byte %0d: 0x%02x", i, tr.data), UVM_LOW)
    end
    
    // STOP
    tr = reg_transaction::type_id::create("stop");
    tr.addr = 4'h0;
    tr.write = 1;
    tr.data = 8'h02;
    start_item(tr); finish_item(tr);
    
    `uvm_info("I2C_SEQ", "Read sequence completed", UVM_LOW)
  endtask
  
endclass
