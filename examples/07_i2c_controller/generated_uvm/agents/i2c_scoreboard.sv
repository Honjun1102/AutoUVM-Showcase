// AutoUVM生成 - I2C Scoreboard
class i2c_scoreboard extends uvm_scoreboard;
  `uvm_component_utils(i2c_scoreboard)
  
  uvm_analysis_imp_reg #(reg_transaction, i2c_scoreboard) reg_export;
  uvm_analysis_imp_i2c #(i2c_transaction, i2c_scoreboard) i2c_export;
  
  reg_transaction reg_queue[$];
  i2c_transaction i2c_queue[$];
  
  int matches;
  int mismatches;
  
  function new(string name, uvm_component parent);
    super.new(name, parent);
    reg_export = new("reg_export", this);
    i2c_export = new("i2c_export", this);
  endfunction
  
  function void write_reg(reg_transaction tr);
    if (tr.write && tr.addr == 4'h2) begin  // 数据寄存器写
      reg_queue.push_back(tr);
      `uvm_info("I2C_SB", $sformatf("REG Write: data=0x%02x", tr.data), UVM_MEDIUM)
    end
  endfunction
  
  function void write_i2c(i2c_transaction tr);
    i2c_queue.push_back(tr);
    `uvm_info("I2C_SB", $sformatf("I2C: addr=0x%02x data=0x%02x", 
              tr.slave_addr, tr.data), UVM_MEDIUM)
    check_match();
  endfunction
  
  function void check_match();
    if (reg_queue.size() > 0 && i2c_queue.size() > 0) begin
      reg_transaction reg_tr = reg_queue.pop_front();
      i2c_transaction i2c_tr = i2c_queue.pop_front();
      
      if (reg_tr.data == i2c_tr.data) begin
        matches++;
        `uvm_info("I2C_SB", "✓ MATCH", UVM_LOW)
      end else begin
        mismatches++;
        `uvm_error("I2C_SB", $sformatf("✗ MISMATCH: REG=0x%02x I2C=0x%02x", 
                   reg_tr.data, i2c_tr.data))
      end
    end
  endfunction
  
  function void report_phase(uvm_phase phase);
    `uvm_info("I2C_SB", $sformatf("========================================"), UVM_LOW)
    `uvm_info("I2C_SB", $sformatf("Final Results:"), UVM_LOW)
    `uvm_info("I2C_SB", $sformatf("  Matches:    %0d", matches), UVM_LOW)
    `uvm_info("I2C_SB", $sformatf("  Mismatches: %0d", mismatches), UVM_LOW)
    `uvm_info("I2C_SB", $sformatf("========================================"), UVM_LOW)
    if (mismatches > 0)
      `uvm_error("I2C_SB", "Verification FAILED")
    else
      `uvm_info("I2C_SB", "Verification PASSED", UVM_LOW)
  endfunction
  
endclass
