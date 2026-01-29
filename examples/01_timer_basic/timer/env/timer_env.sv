`ifndef TIMER_ENV_SV
`define TIMER_ENV_SV

class timer_env extends uvm_env;
    `uvm_component_utils(timer_env)

    // Children components
    apb_agent_pkg::apb_agent apb_agent_inst;
    timer_env_coverage timer_coverage_inst;

    function new(string name, uvm_component parent);
        super.new(name, parent);
    endfunction

    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        apb_agent_inst = apb_agent_pkg::apb_agent::type_id::create("apb_agent_inst", this);
        timer_coverage_inst = timer_env_coverage::type_id::create("timer_coverage_inst", this);
    endfunction

    function void connect_phase(uvm_phase phase);
        super.connect_phase(phase);
        // LLM_BODY_START: connect_phase
        // Connect children components here
        // LLM_BODY_END: connect_phase

        if (timer_coverage_inst != null) begin
            apb_agent_inst.monitor.ap.connect(timer_coverage_inst.apb_imp);
        end
    endfunction

endclass

`endif