// AutoUVM自动生成 - Debug寄存器访问序列

class debug_reg_seq extends uvm_sequence #(axi4_transaction);
  `uvm_object_utils(debug_reg_seq)
  
  function new(string name = "debug_reg_seq");
    super.new(name);
  endfunction
  
  task body();
    axi4_transaction tr;
    
    // Debug接口通常做寄存器级访问
    repeat(15) begin
      tr = axi4_transaction::type_id::create("debug_tr");
      
      start_item(tr);
      assert(tr.randomize() with {
        addr[31:28] == 4'h2;  // 访问Timer (通过Bridge)
        len == 0;             // 单次传输
        size == 2;            // 4字节
      });
      finish_item(tr);
      
      `uvm_info("DEBUG_SEQ", $sformatf("Sent: %s", tr.convert2string()), UVM_MEDIUM)
      
      #($urandom_range(50, 100) * 1ns);
    end
  endtask
  
endclass
