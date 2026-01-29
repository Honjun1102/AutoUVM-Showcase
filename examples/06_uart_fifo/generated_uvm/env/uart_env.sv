// AutoUVM生成 - UART Environment
class uart_env extends uvm_env;
  `uvm_component_utils(uart_env)
  
  axis_agent       axis_agt;
  uart_monitor     uart_mon;
  fifo_monitor     fifo_mon;
  uart_scoreboard  sb;
  
  function new(string name, uvm_component parent);
    super.new(name, parent);
  endfunction
  
  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    axis_agt = axis_agent::type_id::create("axis_agt", this);
    axis_agt.is_active = UVM_ACTIVE;
    uart_mon = uart_monitor::type_id::create("uart_mon", this);
    fifo_mon = fifo_monitor::type_id::create("fifo_mon", this);
    sb = uart_scoreboard::type_id::create("sb", this);
  endfunction
  
  function void connect_phase(uvm_phase phase);
    super.connect_phase(phase);
    // Connect to scoreboard (需要在driver中添加analysis port)
    uart_mon.ap.connect(sb.uart_export);
  endfunction
endclass
