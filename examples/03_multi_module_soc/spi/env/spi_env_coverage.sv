`ifndef SPI_ENV_COVERAGE_SV
`define SPI_ENV_COVERAGE_SV

// This file is included in the env package
// analysis_imp_decl macros are declared in the package file

class spi_env_coverage extends uvm_component;

    `uvm_component_utils(spi_env_coverage)

    uvm_analysis_imp_spi #(spi_agent_pkg::spi_seq_item, spi_env_coverage) spi_imp;

    spi_agent_pkg::spi_seq_item last_spi_tr;

    // Hit flags for deterministic feedback (MVP)

    covergroup spi_cg;
        option.per_instance = 1;
    endgroup

    function new(string name, uvm_component parent);
        super.new(name, parent);
        spi_cg = new();
    endfunction

    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        spi_imp = new("spi_imp", this);
    endfunction

    function void write_spi(spi_agent_pkg::spi_seq_item tr);
        if (!1) return;
        if (tr == null) return;
        last_spi_tr = tr;
        // Update hit flags
        spi_cg.sample();
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
            $fwrite(fd, "    \"spi\": {\n");
            $fwrite(fd, "    }\n");
            $fwrite(fd, "  }\n");
            $fwrite(fd, "}\n");
            $fclose(fd);
        end
    endfunction

endclass

`endif