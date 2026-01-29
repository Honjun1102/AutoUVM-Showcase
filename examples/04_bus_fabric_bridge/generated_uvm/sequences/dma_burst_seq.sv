// AutoUVM自动生成 - DMA Burst序列

class dma_burst_seq extends uvm_sequence #(axi4_transaction);
  `uvm_object_utils(dma_burst_seq)
  
  function new(string name = "dma_burst_seq");
    super.new(name);
  endfunction
  
  task body();
    axi4_transaction tr;
    
    // DMA通常做大块数据传输
    repeat(10) begin
      tr = axi4_transaction::type_id::create("dma_tr");
      
      start_item(tr);
      assert(tr.randomize() with {
        addr[31:28] == 4'h1;  // 访问GPIO
        len inside {[4:15]};  // 长Burst
        burst == 2'b01;       // INCR
      });
      finish_item(tr);
      
      `uvm_info("DMA_SEQ", $sformatf("Sent: %s", tr.convert2string()), UVM_MEDIUM)
    end
  endtask
  
endclass
