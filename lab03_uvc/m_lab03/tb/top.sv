//------------------------------------------------------------------------------
// top.sv   --   LAB 3  (SKELETON)
//
// GIONG HET Lab 2. Khong phai sua gi.
// Cho vao day de bo file day du.
//------------------------------------------------------------------------------

module top;

  // import the UVM library
  import uvm_pkg::*;

  // include the UVM macros
  `include "uvm_macros.svh"

  // import the yapp UVC
  import yapp_pkg::*;

  // include the testbench and test library
  `include "router_tb.sv"
  `include "router_test_lib.sv"

  initial
    run_test();

endmodule : top


//------------------------------------------------------------------------------
// CAU HOI:
//   File nay KHONG doi gi so voi Lab 2, du UVC da duoc them vao.
//   Vi sao?  (Goi y: 7 file cua UVC di vao compiler bang duong nao?
//             -- Section 6 slide 18)
//------------------------------------------------------------------------------
