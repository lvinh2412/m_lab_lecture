module top;
  import uvm_pkg::*;
  `include "uvm_macros.svh"
  import yapp_pkg::*;

  `include "router_tb.sv"
  `include "router_test_lib.sv"

  initial
    run_test();

endmodule : top
