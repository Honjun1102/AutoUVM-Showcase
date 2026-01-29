// AutoUVM自动生成 - UART Scoreboard
class uart_scoreboard extends uvm_scoreboard;
  `uvm_component_utils(uart_scoreboard)
  
  uvm_analysis_imp_axis #(axis_transaction, uart_scoreboard) axis_export;
  uvm_analysis_imp_uart #(uart_transaction, uart_scoreboard) uart_export;
  
  axis_transaction axis_queue[$];
  uart_transaction uart_queue[$];
  
  int matches;
  int mismatches;
  
  function new(string name, uvm_component parent);
    super.new(name, parent);
    axis_export = new("axis_export", this);
    uart_export = new("uart_export", this);
  endfunction
  
  function void write_axis(axis_transaction tr);
    axis_queue.push_back(tr);
    `uvm_info("UART_SB", $sformatf("AXIS: 0x%02x", tr.data), UVM_HIGH)
    check_match();
  endfunction
  
  function void write_uart(uart_transaction tr);
    uart_queue.push_back(tr);
    `uvm_info("UART_SB", $sformatf("UART: 0x%02x", tr.data), UVM_HIGH)
    check_match();
  endfunction
  
  function void check_match();
    if (axis_queue.size() > 0 && uart_queue.size() > 0) begin
      axis_transaction axis_tr = axis_queue.pop_front();
      uart_transaction uart_tr = uart_queue.pop_front();
      
      if (axis_tr.data == uart_tr.data) begin
        matches++;
        `uvm_info("UART_SB", $sformatf("✓ MATCH: 0x%02x", axis_tr.data), UVM_LOW)
      end else begin
        mismatches++;
        `uvm_error("UART_SB", $sformatf("✗ MISMATCH: AXIS=0x%02x UART=0x%02x", 
                   axis_tr.data, uart_tr.data))
      end
    end
  endfunction
  
  function void report_phase(uvm_phase phase);
    `uvm_info("UART_SB", $sformatf("========================================"), UVM_LOW)
    `uvm_info("UART_SB", $sformatf("Final Results:"), UVM_LOW)
    `uvm_info("UART_SB", $sformatf("  Matches:    %0d", matches), UVM_LOW)
    `uvm_info("UART_SB", $sformatf("  Mismatches: %0d", mismatches), UVM_LOW)
    `uvm_info("UART_SB", $sformatf("========================================"), UVM_LOW)
    if (mismatches > 0)
      `uvm_error("UART_SB", "Verification FAILED")
    else
      `uvm_info("UART_SB", "Verification PASSED", UVM_LOW)
  endfunction
  
endclass
