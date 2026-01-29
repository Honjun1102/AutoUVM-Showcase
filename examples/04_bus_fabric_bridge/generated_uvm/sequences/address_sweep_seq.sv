// AutoUVM自动生成 - 地址扫描序列

class address_sweep_seq extends uvm_sequence #(axi4_transaction);
  `uvm_object_utils(address_sweep_seq)
  
  rand bit [31:0] start_addr;
  rand bit [31:0] end_addr;
  rand bit [31:0] step;
  
  constraint c_addr_range {
    start_addr[1:0] == 0;
    end_addr[1:0] == 0;
    step inside {4, 8, 16, 64};
    end_addr > start_addr;
    (end_addr - start_addr) < 4096;  // 限制范围
  }
  
  function new(string name = "address_sweep_seq");
    super.new(name);
  endfunction
  
  task body();
    axi4_transaction tr;
    bit [31:0] addr;
    int count = 0;
    
    `uvm_info("SWEEP_SEQ", $sformatf("Sweeping addr 0x%08x to 0x%08x, step=%0d", 
              start_addr, end_addr, step), UVM_LOW)
    
    for (addr = start_addr; addr < end_addr; addr += step) begin
      tr = axi4_transaction::type_id::create($sformatf("sweep_tr_%0d", count++));
      
      start_item(tr);
      assert(tr.randomize() with {
        addr == local::addr;
        len == 0;  // 单次传输
      });
      finish_item(tr);
      
      #(20ns);
    end
    
    `uvm_info("SWEEP_SEQ", $sformatf("Completed %0d address sweeps", count), UVM_LOW)
  endtask
  
endclass
