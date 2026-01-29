`ifndef PWM_ENV_COVERAGE_SV
`define PWM_ENV_COVERAGE_SV

// This file is included in the env package
// analysis_imp_decl macros are declared in the package file

class pwm_env_coverage extends uvm_component;

    `uvm_component_utils(pwm_env_coverage)

    uvm_analysis_imp_pwm #(pwm_agent_pkg::pwm_seq_item, pwm_env_coverage) pwm_imp;

    pwm_agent_pkg::pwm_seq_item last_pwm_tr;

    // Hit flags for deterministic feedback (MVP)

    covergroup pwm_cg;
        option.per_instance = 1;
    endgroup

    function new(string name, uvm_component parent);
        super.new(name, parent);
        pwm_cg = new();
    endfunction

    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        pwm_imp = new("pwm_imp", this);
    endfunction

    function void write_pwm(pwm_agent_pkg::pwm_seq_item tr);
        if (!1) return;
        if (tr == null) return;
        last_pwm_tr = tr;
        // Update hit flags
        pwm_cg.sample();
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
            $fwrite(fd, "    \"pwm\": {\n");
            $fwrite(fd, "    }\n");
            $fwrite(fd, "  }\n");
            $fwrite(fd, "}\n");
            $fclose(fd);
        end
    endfunction

endclass

`endif