`ifndef UART_ENV_COVERAGE_SV
`define UART_ENV_COVERAGE_SV

// This file is included in the env package
// analysis_imp_decl macros are declared in the package file

class uart_env_coverage extends uvm_component;

    `uvm_component_utils(uart_env_coverage)

    uvm_analysis_imp_uart #(uart_agent_pkg::uart_seq_item, uart_env_coverage) uart_imp;

    uart_agent_pkg::uart_seq_item last_uart_tr;

    // Hit flags for deterministic feedback (MVP)

    covergroup uart_cg;
        option.per_instance = 1;
    endgroup

    function new(string name, uvm_component parent);
        super.new(name, parent);
        uart_cg = new();
    endfunction

    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        uart_imp = new("uart_imp", this);
    endfunction

    function void write_uart(uart_agent_pkg::uart_seq_item tr);
        if (!1) return;
        if (tr == null) return;
        last_uart_tr = tr;
        // Update hit flags
        uart_cg.sample();
    endfunction

    function void report_phase(uvm_phase phase);
        int fd;
        super.report_phase(phase);
        // Generate coverage_summary.json (standard format: {"policy": {"relaxations": [...]}, "missing": {...}})
        fd = $fopen("coverage_summary.json", "w");
        if (fd) begin
            $fwrite(fd, "{\n");
            $fwrite(fd, "  \"policy\": {\n");
            $fwrite(fd, "    \"relaxations\": []\n");
            $fwrite(fd, "  },\n");
            $fwrite(fd, "  \"missing\": {\n");
            $fwrite(fd, "    \"uart\": {\n");
            $fwrite(fd, "    }\n");
            $fwrite(fd, "  }\n");
            $fwrite(fd, "}\n");
            $fclose(fd);
        end
    endfunction

endclass

`endif