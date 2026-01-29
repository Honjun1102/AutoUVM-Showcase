`ifndef PWM_ENV_SV
`define PWM_ENV_SV

class pwm_env extends uvm_env;
    `uvm_component_utils(pwm_env)

    // Children components
    pwm_agent_pkg::pwm_agent pwm_agent_inst;
    pwm_env_coverage pwm_coverage_inst;

    function new(string name, uvm_component parent);
        super.new(name, parent);
    endfunction

    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        pwm_agent_inst = pwm_agent_pkg::pwm_agent::type_id::create("pwm_agent_inst", this);
        pwm_coverage_inst = pwm_env_coverage::type_id::create("pwm_coverage_inst", this);
    endfunction

    function void connect_phase(uvm_phase phase);
        super.connect_phase(phase);
        // LLM_BODY_START: connect_phase
        // Connect children components here
        // LLM_BODY_END: connect_phase

        if (pwm_coverage_inst != null) begin
            pwm_agent_inst.monitor.ap.connect(pwm_coverage_inst.pwm_imp);
        end
    endfunction

endclass

`endif