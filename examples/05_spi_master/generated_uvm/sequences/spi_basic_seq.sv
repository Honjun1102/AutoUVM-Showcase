// AutoUVM自动生成 - SPI基础序列
class spi_basic_seq extends uvm_sequence #(apb_transaction);
  `uvm_object_utils(spi_basic_seq)
  
  rand int num_trans = 10;
  
  function new(string name = "spi_basic_seq");
    super.new(name);
  endfunction
  
  task body();
    apb_transaction tr;
    
    // 配置SPI (CPOL=0, CPHA=0, 分频=10)
    tr = apb_transaction::type_id::create("cfg_tr");
    tr.addr = 8'h0C;
    tr.write = 1;
    tr.data = 32'd10;
    start_item(tr); finish_item(tr);
    
    // 发送数据
    for (int i = 0; i < num_trans; i++) begin
      // 写数据寄存器
      tr = apb_transaction::type_id::create($sformatf("data_tr_%0d", i));
      tr.addr = 8'h08;
      tr.write = 1;
      tr.data = $urandom_range(0, 255);
      start_item(tr); finish_item(tr);
      
      // 启动传输
      tr = apb_transaction::type_id::create($sformatf("ctrl_tr_%0d", i));
      tr.addr = 8'h00;
      tr.write = 1;
      tr.data = 32'h1;  // enable
      start_item(tr); finish_item(tr);
      
      // 等待完成
      #1us;
      
      // 读取接收数据
      tr = apb_transaction::type_id::create($sformatf("read_tr_%0d", i));
      tr.addr = 8'h08;
      tr.write = 0;
      start_item(tr); finish_item(tr);
      
      `uvm_info("SPI_SEQ", $sformatf("Transaction %0d: RX=0x%08x", i, tr.data), UVM_LOW)
    end
  endtask
  
endclass
