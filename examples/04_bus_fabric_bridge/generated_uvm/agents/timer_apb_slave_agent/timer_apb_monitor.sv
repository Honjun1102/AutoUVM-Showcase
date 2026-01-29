// AutoUVM自动生成 - Timer APB Slave Monitor

class timer_apb_monitor extends uvm_monitor;
  `uvm_component_utils(timer_apb_monitor)
  
  virtual apb_if vif;
  uvm_analysis_port #(apb_transaction) ap;
  
  function new(string name, uvm_component parent);
    super.new(name, parent);
    ap = new("ap", this);
  endfunction
  
  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    if (!uvm_config_db#(virtual apb_if)::get(this, "", "vif", vif))
      `uvm_fatal("NOVIF", "APB interface not found")
  endfunction
  
  task run_phase(uvm_phase phase);
    apb_transaction tr;
    forever begin
      @(posedge vif.pclk);
      if (vif.psel && vif.penable && vif.pready) begin
        tr = apb_transaction::type_id::create("apb_tr");
        tr.addr = vif.paddr;
        tr.write = vif.pwrite;
        tr.data = vif.pwrite ? vif.pwdata : vif.prdata;
        tr.strb = vif.pstrb;
        tr.slverr = vif.pslverr;
        tr.timestamp = $time;
        
        ap.write(tr);
        `uvm_info("TIMER_MON", tr.convert2string(), UVM_HIGH)
      end
    end
  endtask
  
endclass
