// AutoUVM自动生成 - CPU随机访问序列

class cpu_random_seq extends uvm_sequence #(axi4_transaction);
  `uvm_object_utils(cpu_random_seq)
  
  rand int num_trans = 20;
  
  function new(string name = "cpu_random_seq");
    super.new(name);
  endfunction
  
  task body();
    axi4_transaction tr;
    
    for (int i = 0; i < num_trans; i++) begin
      tr = axi4_transaction::type_id::create($sformatf("cpu_tr_%0d", i));
      
      start_item(tr);
      assert(tr.randomize() with {
        addr[31:28] == 4'h0;  // 访问SRAM
        len inside {[0:3]};   // 短Burst
      });
      finish_item(tr);
      
      `uvm_info("CPU_SEQ", $sformatf("Sent: %s", tr.convert2string()), UVM_MEDIUM)
      
      #($urandom_range(10, 50) * 1ns);  // 随机间隔
    end
  endtask
  
endclass
