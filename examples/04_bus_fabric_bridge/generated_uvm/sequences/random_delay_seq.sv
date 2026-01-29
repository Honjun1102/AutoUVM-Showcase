// AutoUVM自动生成 - 随机延迟序列

class random_delay_seq extends uvm_sequence #(axi4_transaction);
  `uvm_object_utils(random_delay_seq)
  
  rand int num_trans = 30;
  rand int min_delay = 10;
  rand int max_delay = 100;
  
  function new(string name = "random_delay_seq");
    super.new(name);
  endfunction
  
  task body();
    axi4_transaction tr;
    int delay;
    
    for (int i = 0; i < num_trans; i++) begin
      tr = axi4_transaction::type_id::create($sformatf("delay_tr_%0d", i));
      
      start_item(tr);
      assert(tr.randomize());
      finish_item(tr);
      
      delay = $urandom_range(min_delay, max_delay);
      `uvm_info("DELAY_SEQ", $sformatf("Transaction %0d sent, delay %0dns", i, delay), UVM_HIGH)
      #(delay * 1ns);
    end
  endtask
  
endclass
