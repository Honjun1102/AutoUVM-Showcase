`ifndef SPI_ENV_SV
`define SPI_ENV_SV

class spi_env extends uvm_env;
    `uvm_component_utils(spi_env)

    // Children components
    spi_agent_pkg::spi_agent spi_agent_inst;
    spi_env_coverage spi_coverage_inst;

    function new(string name, uvm_component parent);
        super.new(name, parent);
    endfunction

    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        spi_agent_inst = spi_agent_pkg::spi_agent::type_id::create("spi_agent_inst", this);
        spi_coverage_inst = spi_env_coverage::type_id::create("spi_coverage_inst", this);
    endfunction

    function void connect_phase(uvm_phase phase);
        super.connect_phase(phase);
        // LLM_BODY_START: connect_phase
        // Connect children components here
        // LLM_BODY_END: connect_phase

        if (spi_coverage_inst != null) begin
            spi_agent_inst.monitor.ap.connect(spi_coverage_inst.spi_imp);
        end
    endfunction

endclass

`endif