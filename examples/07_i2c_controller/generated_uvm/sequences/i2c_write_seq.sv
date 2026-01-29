// AutoUVM生成 - I2C写序列
class i2c_write_seq extends uvm_sequence #(reg_transaction);
  `uvm_object_utils(i2c_write_seq)
  
  rand bit [6:0] slave_addr;
  rand bit [7:0] data_bytes[];
  
  constraint c_data {
    data_bytes.size() inside {[1:10]};
  }
  
  function new(string name = "i2c_write_seq");
    super.new(name);
    slave_addr = 7'h50;  // 默认EEPROM地址
  endfunction
  
  task body();
    reg_transaction tr;
    
    `uvm_info("I2C_SEQ", $sformatf("Writing %0d bytes to slave 0x%02x", 
              data_bytes.size(), slave_addr), UVM_LOW)
    
    // 配置分频器
    tr = reg_transaction::type_id::create("prescaler");
    tr.addr = 4'h4;
    tr.write = 1;
    tr.data = 8'd50;  // 100kHz @ 50MHz
    start_item(tr); finish_item(tr);
    
    // 配置从机地址
    tr = reg_transaction::type_id::create("slave_addr");
    tr.addr = 4'h3;
    tr.write = 1;
    tr.data = {1'b0, slave_addr};
    start_item(tr); finish_item(tr);
    
    foreach (data_bytes[i]) begin
      // 写数据寄存器
      tr = reg_transaction::type_id::create($sformatf("data_%0d", i));
      tr.addr = 4'h2;
      tr.write = 1;
      tr.data = data_bytes[i];
      start_item(tr); finish_item(tr);
      
      // 发起写命令 (start + write)
      tr = reg_transaction::type_id::create($sformatf("ctrl_%0d", i));
      tr.addr = 4'h0;
      tr.write = 1;
      tr.data = (i == 0) ? 8'h09 : 8'h08;  // 第一个字节带START
      start_item(tr); finish_item(tr);
      
      // 等待完成
      #5us;
      
      // 检查状态
      tr = reg_transaction::type_id::create($sformatf("status_%0d", i));
      tr.addr = 4'h1;
      tr.write = 0;
      start_item(tr); finish_item(tr);
      
      if (tr.data[0] == 1'b1) begin
        `uvm_warning("I2C_SEQ", "I2C still busy")
      end
      if (tr.data[1] == 1'b0) begin
        `uvm_error("I2C_SEQ", "No ACK received")
      end
    end
    
    // 发送STOP
    tr = reg_transaction::type_id::create("stop");
    tr.addr = 4'h0;
    tr.write = 1;
    tr.data = 8'h02;  // STOP
    start_item(tr); finish_item(tr);
    
    `uvm_info("I2C_SEQ", "Write sequence completed", UVM_LOW)
  endtask
  
endclass
