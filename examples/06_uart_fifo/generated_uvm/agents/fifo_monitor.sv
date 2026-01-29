// AutoUVM自动生成 - FIFO状态监视器
class fifo_monitor extends uvm_monitor;
  `uvm_component_utils(fifo_monitor)
  
  virtual fifo_status_if vif;
  uvm_analysis_port #(fifo_status) ap;
  
  int max_count_observed;
  int overflow_cnt;
  int underflow_cnt;
  
  function new(string name, uvm_component parent);
    super.new(name, parent);
    ap = new("ap", this);
  endfunction
  
  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    if (!uvm_config_db#(virtual fifo_status_if)::get(this, "", "vif", vif))
      `uvm_fatal("NOVIF", "FIFO status interface not found")
  endfunction
  
  task run_phase(uvm_phase phase);
    fifo_status status;
    forever begin
      @(posedge vif.clk);
      
      status = fifo_status::type_id::create("fifo_status");
      status.count = vif.count;
      status.full  = vif.full;
      status.empty = vif.empty;
      
      if (status.count > max_count_observed) begin
        max_count_observed = status.count;
        `uvm_info("FIFO_MON", $sformatf("New max count: %0d", max_count_observed), UVM_LOW)
      end
      
      if (status.full) begin
        `uvm_warning("FIFO_MON", "FIFO Full detected")
      end
      
      ap.write(status);
    end
  endtask
  
  function void report_phase(uvm_phase phase);
    `uvm_info("FIFO_MON", $sformatf("Max FIFO usage: %0d/16", max_count_observed), UVM_LOW)
  endfunction
  
endclass
