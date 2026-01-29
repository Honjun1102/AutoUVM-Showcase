// AutoUVM自动生成 - UART监视器
class uart_monitor extends uvm_monitor;
  `uvm_component_utils(uart_monitor)
  
  virtual uart_if vif;
  uvm_analysis_port #(uart_transaction) ap;
  
  int baud_period;
  
  function new(string name, uvm_component parent);
    super.new(name, parent);
    ap = new("ap", this);
    baud_period = 8680;  // 115200 baud @ 1ns
  endfunction
  
  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    if (!uvm_config_db#(virtual uart_if)::get(this, "", "vif", vif))
      `uvm_fatal("NOVIF", "UART interface not found")
  endfunction
  
  task run_phase(uvm_phase phase);
    forever begin
      monitor_uart_byte();
    end
  endtask
  
  task monitor_uart_byte();
    uart_transaction tr;
    bit [7:0] data;
    
    // 等待Start bit
    @(negedge vif.uart_tx);
    
    tr = uart_transaction::type_id::create("uart_tr");
    tr.timestamp = $time;
    
    // 采样中点
    #(baud_period / 2);
    
    // 采样8个数据位
    for (int i = 0; i < 8; i++) begin
      #(baud_period);
      data[i] = vif.uart_tx;
    end
    
    // 检查Stop bit
    #(baud_period);
    if (vif.uart_tx != 1'b1) begin
      `uvm_error("UART_MON", "Stop bit error")
    end
    
    tr.data = data;
    tr.duration = $time - tr.timestamp;
    
    ap.write(tr);
    `uvm_info("UART_MON", $sformatf("RX: 0x%02x", data), UVM_MEDIUM)
  endtask
  
endclass
