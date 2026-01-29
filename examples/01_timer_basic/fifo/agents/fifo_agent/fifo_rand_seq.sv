`ifndef FIFO_RAND_SEQ_SV
`define FIFO_RAND_SEQ_SV

class fifo_rand_seq extends uvm_sequence #(uvm_sequence_item);
    `uvm_object_utils(fifo_rand_seq)

    function new(string name = "fifo_rand_seq");
        super.new(name);
    endfunction

    extern virtual task body();

endclass

task fifo_rand_seq::body();
    uvm_sequence_item req;
    int n_txn;
    n_txn = 50;
    void'($value$plusargs("AUTO_TXN_N=%0d", n_txn));

    // Generated using basic randomization (fallback)

    // Basic Randomized Sequence (Fallback)
    for (int i = 0; i < n_txn; i++) begin
        req = uvm_sequence_item::type_id::create($sformatf("req_%0d", i));
        start_item(req);
        assert(req.randomize());
        `uvm_info(get_type_name(), $sformatf("Transaction[%0d] sent", i), UVM_MEDIUM)
        finish_item(req);
    end

endtask

`endif