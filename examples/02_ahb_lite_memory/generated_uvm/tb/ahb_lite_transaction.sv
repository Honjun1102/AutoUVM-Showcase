//==============================================================================
// AHB-Lite Transaction
//==============================================================================

class ahb_lite_transaction extends uvm_sequence_item;
    
    rand bit [15:0]  addr;
    rand bit [31:0]  data;
    rand bit         write;
    rand bit [2:0]   size;
    rand bit [2:0]   burst_type;
    rand bit [1:0]   trans_type;
    bit              resp;  // 0=OKAY, 1=ERROR
    
    `uvm_object_utils_begin(ahb_lite_transaction)
        `uvm_field_int(addr, UVM_ALL_ON)
        `uvm_field_int(data, UVM_ALL_ON)
        `uvm_field_int(write, UVM_ALL_ON)
        `uvm_field_int(size, UVM_ALL_ON)
        `uvm_field_int(burst_type, UVM_ALL_ON)
        `uvm_field_int(trans_type, UVM_ALL_ON)
        `uvm_field_int(resp, UVM_ALL_ON)
    `uvm_object_utils_end
    
    function new(string name = "ahb_lite_transaction");
        super.new(name);
    endfunction
    
    // Constraints
    constraint addr_align {
        if (size == 3'b001) addr[0] == 0;      // Halfword aligned
        if (size == 3'b010) addr[1:0] == 0;    // Word aligned
    }
    
    constraint valid_size {
        size inside {3'b000, 3'b001, 3'b010};  // Byte, halfword, word
    }
    
    constraint valid_burst {
        burst_type inside {3'b000, 3'b001, 3'b011, 3'b101, 3'b111};  // SINGLE, INCR, INCR4/8/16
    }
    
endclass
