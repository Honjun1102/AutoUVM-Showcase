`ifndef PWM_SEQUENCER_SV
`define PWM_SEQUENCER_SV

class pwm_sequencer extends uvm_sequencer #(pwm_seq_item);
    `uvm_component_utils(pwm_sequencer)

    function new(string name, uvm_component parent);
        super.new(name, parent);
    endfunction

endclass

`endif