`ifndef I2C_ENV_COVERAGE_SV
`define I2C_ENV_COVERAGE_SV

// This file is included in the env package
// analysis_imp_decl macros are declared in the package file

class i2c_env_coverage extends uvm_component;

    `uvm_component_utils(i2c_env_coverage)

    uvm_analysis_imp_i2c #(i2c_agent_pkg::i2c_seq_item, i2c_env_coverage) i2c_imp;

    i2c_agent_pkg::i2c_seq_item last_i2c_tr;

    // Hit flags for deterministic feedback (MVP)

    covergroup i2c_cg;
        option.per_instance = 1;
    endgroup

    function new(string name, uvm_component parent);
        super.new(name, parent);
        i2c_cg = new();
    endfunction

    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        i2c_imp = new("i2c_imp", this);
    endfunction

    function void write_i2c(i2c_agent_pkg::i2c_seq_item tr);
        if (!1) return;
        if (tr == null) return;
        last_i2c_tr = tr;
        // Update hit flags
        i2c_cg.sample();
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
            $fwrite(fd, "    \"i2c\": {\n");
            $fwrite(fd, "    }\n");
            $fwrite(fd, "  }\n");
            $fwrite(fd, "}\n");
            $fclose(fd);
        end
    endfunction

endclass

`endif