// AutoUVM生成 - UART FIFO Test
class uart_fifo_test extends uvm_test;
  `uvm_component_utils(uart_fifo_test)
  
  uart_env env;
  
  function new(string name, uvm_component parent);
    super.new(name, parent);
  endfunction
  
  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    env = uart_env::type_id::create("env", this);
  endfunction
  
  task run_phase(uvm_phase phase);
    uart_burst_seq seq;
    
    phase.raise_objection(this);
    `uvm_info("TEST", "Starting UART FIFO Test", UVM_LOW)
    
    seq = uart_burst_seq::type_id::create("seq");
    seq.num_bytes = 20;
    seq.delay_min = 0;
    seq.delay_max = 3;
    seq.start(env.axis_agt.sqr);
    
    #100us;  // 等待UART传输完成
    `uvm_info("TEST", "UART FIFO Test Completed", UVM_LOW)
    phase.drop_objection(this);
  endtask
endclass
