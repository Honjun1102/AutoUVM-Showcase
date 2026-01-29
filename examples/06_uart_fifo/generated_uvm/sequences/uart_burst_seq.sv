// AutoUVM自动生成 - UART Burst序列
class uart_burst_seq extends uvm_sequence #(axis_transaction);
  `uvm_object_utils(uart_burst_seq)
  
  rand int num_bytes = 20;
  rand int delay_min = 0;
  rand int delay_max = 5;
  
  function new(string name = "uart_burst_seq");
    super.new(name);
  endfunction
  
  task body();
    axis_transaction tr;
    
    `uvm_info("UART_SEQ", $sformatf("Sending %0d bytes burst", num_bytes), UVM_LOW)
    
    for (int i = 0; i < num_bytes; i++) begin
      tr = axis_transaction::type_id::create($sformatf("axis_tr_%0d", i));
      
      start_item(tr);
      assert(tr.randomize() with {
        delay inside {[delay_min:delay_max]};
      });
      finish_item(tr);
      
      if (i % 10 == 0) begin
        `uvm_info("UART_SEQ", $sformatf("Progress: %0d/%0d", i, num_bytes), UVM_MEDIUM)
      end
    end
    
    `uvm_info("UART_SEQ", "Burst complete", UVM_LOW)
  endtask
  
endclass
