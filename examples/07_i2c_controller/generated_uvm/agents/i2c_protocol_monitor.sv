// AutoUVM生成 - I2C协议监视器
class i2c_protocol_monitor extends uvm_monitor;
  `uvm_component_utils(i2c_protocol_monitor)
  
  virtual i2c_if vif;
  uvm_analysis_port #(i2c_transaction) ap;
  
  function new(string name, uvm_component parent);
    super.new(name, parent);
    ap = new("ap", this);
  endfunction
  
  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    if (!uvm_config_db#(virtual i2c_if)::get(this, "", "vif", vif))
      `uvm_fatal("NOVIF", "I2C interface not found")
  endfunction
  
  task run_phase(uvm_phase phase);
    forever begin
      monitor_i2c_transaction();
    end
  endtask
  
  task monitor_i2c_transaction();
    i2c_transaction tr;
    bit [7:0] data;
    
    // 检测START条件 (SDA下降沿，SCL高)
    @(negedge vif.sda_in);
    if (vif.scl_in == 1'b1) begin
      tr = i2c_transaction::type_id::create("i2c_tr");
      tr.start = 1'b1;
      tr.timestamp = $time;
      
      `uvm_info("I2C_MON", "START condition detected", UVM_HIGH)
      
      // 采样地址 (7位 + R/W)
      for (int i = 7; i >= 0; i--) begin
        @(posedge vif.scl_in);
        if (i == 0)
          tr.read = vif.sda_in;
        else
          tr.slave_addr[i-1] = vif.sda_in;
      end
      
      // 采样ACK
      @(posedge vif.scl_in);
      tr.ack = !vif.sda_in;  // ACK=0
      
      // 采样数据字节
      if (tr.ack) begin
        for (int i = 7; i >= 0; i--) begin
          @(posedge vif.scl_in);
          data[i] = vif.sda_in;
        end
        tr.data = data;
        
        // ACK
        @(posedge vif.scl_in);
      end
      
      // 检测STOP条件 (SDA上升沿，SCL高)
      fork
        begin
          @(posedge vif.sda_in);
          if (vif.scl_in == 1'b1) begin
            tr.stop = 1'b1;
            `uvm_info("I2C_MON", "STOP condition detected", UVM_HIGH)
          end
        end
        begin
          #10us;  // Timeout
        end
      join_any
      disable fork;
      
      ap.write(tr);
      `uvm_info("I2C_MON", $sformatf("%s", tr.convert2string()), UVM_MEDIUM)
    end
  endtask
  
endclass
