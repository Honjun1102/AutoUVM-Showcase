// AutoUVM自动生成 - 背靠背传输序列（无间隔）

class back2back_seq extends uvm_sequence #(axi4_transaction);
  `uvm_object_utils(back2back_seq)
  
  rand int num_trans = 50;
  rand bit [31:0] base_addr;
  
  constraint c_base_addr {
    base_addr[31:28] inside {4'h0, 4'h1, 4'h2};  // 随机选择目标
  }
  
  function new(string name = "back2back_seq");
    super.new(name);
  endfunction
  
  task body();
    axi4_transaction tr;
    
    `uvm_info("B2B_SEQ", "Starting back-to-back transfers (no delay)", UVM_LOW)
    
    for (int i = 0; i < num_trans; i++) begin
      tr = axi4_transaction::type_id::create($sformatf("b2b_tr_%0d", i));
      
      start_item(tr);
      assert(tr.randomize() with {
        addr[31:28] == base_addr[31:28];
        addr[27:0] == i * 16;  // 连续地址
        len == 3;              // 4 beat burst
      });
      finish_item(tr);
      // 无延迟，立即发送下一个
    end
  endtask
  
endclass
