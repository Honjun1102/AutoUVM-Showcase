`ifndef I2C_ENV_SV
`define I2C_ENV_SV

class i2c_env extends uvm_env;
    `uvm_component_utils(i2c_env)

    // Children components
    i2c_agent_pkg::i2c_agent i2c_agent_inst;
    i2c_env_coverage i2c_coverage_inst;

    function new(string name, uvm_component parent);
        super.new(name, parent);
    endfunction

    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        i2c_agent_inst = i2c_agent_pkg::i2c_agent::type_id::create("i2c_agent_inst", this);
        i2c_coverage_inst = i2c_env_coverage::type_id::create("i2c_coverage_inst", this);
    endfunction

    function void connect_phase(uvm_phase phase);
        super.connect_phase(phase);
        // LLM_BODY_START: connect_phase
        // Connect children components here
        // LLM_BODY_END: connect_phase

        if (i2c_coverage_inst != null) begin
            i2c_agent_inst.monitor.ap.connect(i2c_coverage_inst.i2c_imp);
        end
    endfunction

endclass

`endif