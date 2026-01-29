`ifndef TIMER_ENV_COVERAGE_SV
`define TIMER_ENV_COVERAGE_SV

// This file is included in the env package
// analysis_imp_decl macros are declared in the package file

class timer_env_coverage extends uvm_component;

    `uvm_component_utils(timer_env_coverage)

    uvm_analysis_imp_apb #(apb_agent_pkg::apb_seq_item, timer_env_coverage) apb_imp;

    apb_agent_pkg::apb_seq_item last_apb_tr;

    // Hit flags for deterministic feedback (MVP)

    covergroup apb_cg;
        option.per_instance = 1;
    endgroup

    function new(string name, uvm_component parent);
        super.new(name, parent);
        apb_cg = new();
    endfunction

    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        apb_imp = new("apb_imp", this);
    endfunction

    function void write_apb(apb_agent_pkg::apb_seq_item tr);
        if (!1) return;
        if (tr == null) return;
        last_apb_tr = tr;
        // Update hit flags
        apb_cg.sample();
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
            $fwrite(fd, "    \"apb\": {\n");
            $fwrite(fd, "    }\n");
            $fwrite(fd, "  }\n");
            $fwrite(fd, "}\n");
            $fclose(fd);
        end
    endfunction

endclass

`endif