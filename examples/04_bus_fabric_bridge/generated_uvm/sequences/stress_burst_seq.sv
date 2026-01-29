// AutoUVM自动生成 - 压力测试序列（大量Burst）

class stress_burst_seq extends uvm_sequence #(axi4_transaction);
  `uvm_object_utils(stress_burst_seq)
  
  rand int num_trans = 100;
  
  function new(string name = "stress_burst_seq");
    super.new(name);
  endfunction
  
  task body();
    axi4_transaction tr;
    
    for (int i = 0; i < num_trans; i++) begin
      tr = axi4_transaction::type_id::create($sformatf("stress_tr_%0d", i));
      
      start_item(tr);
      assert(tr.randomize() with {
        len inside {[8:15]};     // 长Burst (9-16 beats)
        burst == 2'b01;          // INCR
        size == 2;               // 4字节
      });
      finish_item(tr);
      
      if (i % 10 == 0)
        `uvm_info("STRESS_SEQ", $sformatf("Progress: %0d/%0d", i, num_trans), UVM_LOW)
    end
    
    `uvm_info("STRESS_SEQ", $sformatf("Completed %0d burst transactions", num_trans), UVM_LOW)
  endtask
  
endclass
