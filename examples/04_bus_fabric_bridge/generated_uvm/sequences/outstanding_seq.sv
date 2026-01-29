// AutoUVM自动生成 - Outstanding事务序列

class outstanding_seq extends uvm_sequence #(axi4_transaction);
  `uvm_object_utils(outstanding_seq)
  
  rand int num_outstanding = 8;  // 同时发8个outstanding
  rand int num_rounds = 5;
  
  function new(string name = "outstanding_seq");
    super.new(name);
  endfunction
  
  task body();
    axi4_transaction tr_queue[$];
    
    `uvm_info("OUT_SEQ", $sformatf("Testing %0d outstanding transactions", num_outstanding), UVM_LOW)
    
    for (int round = 0; round < num_rounds; round++) begin
      `uvm_info("OUT_SEQ", $sformatf("Round %0d/%0d", round+1, num_rounds), UVM_LOW)
      
      // 快速发送多个outstanding事务
      for (int i = 0; i < num_outstanding; i++) begin
        axi4_transaction tr = axi4_transaction::type_id::create($sformatf("out_tr_r%0d_%0d", round, i));
        
        start_item(tr);
        assert(tr.randomize() with {
          id == i[3:0];  // 不同的ID
          len inside {[0:3]};
        });
        finish_item(tr);
        
        #(5ns);  // 很短的间隔
      end
      
      // 等待一段时间让事务完成
      #(500ns);
    end
  endtask
  
endclass
