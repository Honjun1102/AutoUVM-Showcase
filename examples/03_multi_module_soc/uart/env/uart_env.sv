`ifndef UART_ENV_SV
`define UART_ENV_SV

class uart_env extends uvm_env;
    `uvm_component_utils(uart_env)

    // Children components
    uart_agent_pkg::uart_agent uart_agent_inst;
    uart_env_coverage uart_coverage_inst;

    function new(string name, uvm_component parent);
        super.new(name, parent);
    endfunction

    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        uart_agent_inst = uart_agent_pkg::uart_agent::type_id::create("uart_agent_inst", this);
        uart_coverage_inst = uart_env_coverage::type_id::create("uart_coverage_inst", this);
    endfunction

    function void connect_phase(uvm_phase phase);
        super.connect_phase(phase);
        // LLM_BODY_START: connect_phase
        // Connect children components here
        // LLM_BODY_END: connect_phase

        if (uart_coverage_inst != null) begin
            uart_agent_inst.monitor.ap.connect(uart_coverage_inst.uart_imp);
        end
    endfunction

endclass

`endif