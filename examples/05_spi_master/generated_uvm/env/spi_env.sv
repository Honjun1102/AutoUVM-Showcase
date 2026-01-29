// AutoUVM生成 - SPI Environment
class spi_env extends uvm_env;
  `uvm_component_utils(spi_env)
  
  spi_apb_agent       apb_agt;
  spi_protocol_monitor spi_mon;
  spi_scoreboard      sb;
  
  function new(string name, uvm_component parent);
    super.new(name, parent);
  endfunction
  
  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    apb_agt = spi_apb_agent::type_id::create("apb_agt", this);
    apb_agt.is_active = UVM_ACTIVE;
    spi_mon = spi_protocol_monitor::type_id::create("spi_mon", this);
    sb = spi_scoreboard::type_id::create("sb", this);
  endfunction
  
  function void connect_phase(uvm_phase phase);
    super.connect_phase(phase);
    apb_agt.mon.ap.connect(sb.apb_export);
    spi_mon.ap.connect(sb.spi_export);
  endfunction
endclass
