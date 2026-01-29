// AutoUVM自动生成 - SPI Scoreboard
class spi_scoreboard extends uvm_scoreboard;
  `uvm_component_utils(spi_scoreboard)
  
  uvm_analysis_imp_apb #(apb_transaction, spi_scoreboard) apb_export;
  uvm_analysis_imp_spi #(spi_transaction, spi_scoreboard) spi_export;
  
  apb_transaction apb_queue[$];
  spi_transaction spi_queue[$];
  
  int matches;
  int mismatches;
  
  function new(string name, uvm_component parent);
    super.new(name, parent);
    apb_export = new("apb_export", this);
    spi_export = new("spi_export", this);
  endfunction
  
  function void write_apb(apb_transaction tr);
    if (tr.write && tr.addr == 8'h08) begin  // 数据寄存器写
      apb_queue.push_back(tr);
      `uvm_info("SPI_SB", $sformatf("APB Write: data=0x%08x", tr.data), UVM_MEDIUM)
      check_match();
    end
  endfunction
  
  function void write_spi(spi_transaction tr);
    spi_queue.push_back(tr);
    `uvm_info("SPI_SB", $sformatf("SPI: MOSI=0x%02x MISO=0x%02x", 
              tr.mosi_data, tr.miso_data), UVM_MEDIUM)
    check_match();
  endfunction
  
  function void check_match();
    if (apb_queue.size() > 0 && spi_queue.size() > 0) begin
      apb_transaction apb_tr = apb_queue.pop_front();
      spi_transaction spi_tr = spi_queue.pop_front();
      
      if (apb_tr.data[7:0] == spi_tr.mosi_data) begin
        matches++;
        `uvm_info("SPI_SB", "✓ MATCH", UVM_LOW)
      end else begin
        mismatches++;
        `uvm_error("SPI_SB", $sformatf("✗ MISMATCH: APB=0x%02x SPI=0x%02x", 
                   apb_tr.data[7:0], spi_tr.mosi_data))
      end
    end
  endfunction
  
  function void report_phase(uvm_phase phase);
    `uvm_info("SPI_SB", $sformatf("Final: %0d matches, %0d mismatches", 
              matches, mismatches), UVM_LOW)
    if (mismatches > 0)
      `uvm_error("SPI_SB", "Verification FAILED")
  endfunction
  
endclass
