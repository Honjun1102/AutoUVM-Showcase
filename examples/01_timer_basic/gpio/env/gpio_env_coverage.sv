`ifndef GPIO_ENV_COVERAGE_SV
`define GPIO_ENV_COVERAGE_SV

// This file is included in the env package
// analysis_imp_decl macros are declared in the package file

class gpio_env_coverage extends uvm_component;

    `uvm_component_utils(gpio_env_coverage)

    uvm_analysis_imp_gpio #(gpio_agent_pkg::gpio_seq_item, gpio_env_coverage) gpio_imp;

    gpio_agent_pkg::gpio_seq_item last_gpio_tr;

    // Hit flags for deterministic feedback (MVP)

    covergroup gpio_cg;
        option.per_instance = 1;
    endgroup

    function new(string name, uvm_component parent);
        super.new(name, parent);
        gpio_cg = new();
    endfunction

    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        gpio_imp = new("gpio_imp", this);
    endfunction

    function void write_gpio(gpio_agent_pkg::gpio_seq_item tr);
        if (!1) return;
        if (tr == null) return;
        last_gpio_tr = tr;
        // Update hit flags
        gpio_cg.sample();
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
            $fwrite(fd, "    \"gpio\": {\n");
            $fwrite(fd, "    }\n");
            $fwrite(fd, "  }\n");
            $fwrite(fd, "}\n");
            $fclose(fd);
        end
    endfunction

endclass

`endif