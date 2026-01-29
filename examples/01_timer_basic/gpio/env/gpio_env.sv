`ifndef GPIO_ENV_SV
`define GPIO_ENV_SV

class gpio_env extends uvm_env;
    `uvm_component_utils(gpio_env)

    // Children components
    gpio_agent_pkg::gpio_agent gpio_agent_inst;
    gpio_env_coverage gpio_coverage_inst;

    function new(string name, uvm_component parent);
        super.new(name, parent);
    endfunction

    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        gpio_agent_inst = gpio_agent_pkg::gpio_agent::type_id::create("gpio_agent_inst", this);
        gpio_coverage_inst = gpio_env_coverage::type_id::create("gpio_coverage_inst", this);
    endfunction

    function void connect_phase(uvm_phase phase);
        super.connect_phase(phase);
        // LLM_BODY_START: connect_phase
        // Connect children components here
        // LLM_BODY_END: connect_phase

        if (gpio_coverage_inst != null) begin
            gpio_agent_inst.monitor.ap.connect(gpio_coverage_inst.gpio_imp);
        end
    endfunction

endclass

`endif