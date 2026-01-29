// AutoUVM自动生成 - SPI Transaction
class spi_transaction extends uvm_sequence_item;
  
  rand bit [7:0] mosi_data;
  bit [7:0] miso_data;
  rand bit [3:0] cs_id;
  rand bit cpol;
  rand bit cpha;
  
  time timestamp;
  time duration;
  
  `uvm_object_utils_begin(spi_transaction)
    `uvm_field_int(mosi_data, UVM_ALL_ON)
    `uvm_field_int(miso_data, UVM_ALL_ON)
    `uvm_field_int(cs_id, UVM_ALL_ON)
    `uvm_field_int(cpol, UVM_ALL_ON)
    `uvm_field_int(cpha, UVM_ALL_ON)
  `uvm_object_utils_end
  
  function new(string name = "spi_transaction");
    super.new(name);
  endfunction
  
  function string convert2string();
    return $sformatf("SPI: MOSI=0x%02x MISO=0x%02x CPOL=%0b CPHA=%0b CS=%0d", 
                     mosi_data, miso_data, cpol, cpha, cs_id);
  endfunction
  
endclass
