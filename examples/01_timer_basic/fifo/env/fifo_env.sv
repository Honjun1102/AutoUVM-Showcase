`ifndef FIFO_ENV_SV
`define FIFO_ENV_SV

class fifo_env extends uvm_env;
    `uvm_component_utils(fifo_env)

    // Children components
    fifo_agent_pkg::fifo_agent fifo_agent_inst;
    fifo_env_coverage fifo_coverage_inst;

    function new(string name, uvm_component parent);
        super.new(name, parent);
    endfunction

    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        fifo_agent_inst = fifo_agent_pkg::fifo_agent::type_id::create("fifo_agent_inst", this);
        fifo_coverage_inst = fifo_env_coverage::type_id::create("fifo_coverage_inst", this);
    endfunction

    function void connect_phase(uvm_phase phase);
        super.connect_phase(phase);
        // LLM_BODY_START: connect_phase
        // Connect children components here
        // LLM_BODY_END: connect_phase

        if (fifo_coverage_inst != null) begin
            fifo_agent_inst.monitor.ap.connect(fifo_coverage_inst.fifo_imp);
        end
    endfunction

endclass

`endif