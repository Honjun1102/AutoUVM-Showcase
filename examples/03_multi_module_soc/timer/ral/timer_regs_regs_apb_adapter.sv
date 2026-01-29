// ------------------------------------------------------------------------
// APB RAL Adapter for timer_regs_regs
// ------------------------------------------------------------------------

class timer_regs_regs_apb_adapter extends uvm_reg_adapter;
    `uvm_object_utils(timer_regs_regs_apb_adapter)

    function new(string name = "timer_regs_regs_apb_adapter");
        super.new(name);
    endfunction : new

    // Convert register operation to APB transaction
    virtual function uvm_sequence_item reg2bus(const ref uvm_reg_bus_op rw);
        apb_seq_item apb_tr;
        apb_tr = apb_seq_item::type_id::create("apb_tr");

        // Set APB signals
        apb_tr.pwrite = (rw.kind == UVM_WRITE);
        apb_tr.paddr = rw.addr;
        apb_tr.psel = 1'b1;
        apb_tr.penable = 1'b1;

        if (rw.kind == UVM_WRITE) begin
            apb_tr.pwdata = rw.data;
            apb_tr.pstrb = '1;  // All bytes
        end

        return apb_tr;
    endfunction : reg2bus

    // Convert APB transaction to register operation
    virtual function void bus2reg(uvm_sequence_item bus_item, ref uvm_reg_bus_op rw);
        apb_seq_item apb_tr;

        if (!$cast(apb_tr, bus_item)) begin
            `uvm_fatal(get_type_name(), "Failed to cast bus_item to apb_seq_item")
        end

        // Extract information
        rw.kind = apb_tr.pwrite ? UVM_WRITE : UVM_READ;
        rw.addr = apb_tr.paddr;
        rw.data = apb_tr.pwrite ? apb_tr.pwdata : apb_tr.prdata;
        rw.status = (apb_tr.pready && apb_tr.pslverr == 0) ? UVM_IS_OK : UVM_NOT_OK;
    endfunction : bus2reg

endclass : timer_regs_regs_apb_adapter
