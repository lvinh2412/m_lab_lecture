//------------------------------------------------------------------------------
// top.sv   --   LAB 2  (phien ban SKELETON)
//
// MODULE TOP: cho nay kich hoat toan bo co che phasing cua UVM.
//
// Tham khao:  Section 3 slide 20  (Compiling UVM Code)
//             Section 4 slide 11  (How Are Phases Activated?)
//             Section 5 slide 11  (Selecting a Test: Option 1)
//             Section 5 slide 12  (Selecting a Test: Option 2)
//------------------------------------------------------------------------------

module top;

  // ---- TODO-13 -------------------------------------------------------------
  // Hai dong bat buoc de dung duoc thu vien UVM trong pham vi module nay:
  //   (a) import package cua thu vien UVM
  //   (b) include file macro
  // Cau hoi: vi sao (b) KHONG duoc gop vao (a)?
  //          (import lam viec voi TEN; macro la co che gi?)
  // --------------------------------------------------------------------------
	import uvm_pkg::*;
	`include "uvm_macros.svh"


  // ---- TODO-14 -------------------------------------------------------------
  // Import package YAPP (de co yapp_packet tu Lab 1).
  // Luu y: yapp_pkg nam o ../sv/, duoc bien dich rieng trong run.f.
  // --------------------------------------------------------------------------
	import yapp_pkg::*;

  // ---- TODO-15 -------------------------------------------------------------
  // Include hai file class vua viet.
  // Cau hoi: thu tu include co quan trong khong?  Vi sao?
  //   (base_test co mot handle kieu router_tb -- compiler can biet
  //    router_tb la gi TRUOC hay SAU?)
  // --------------------------------------------------------------------------
	`include "router_tb.sv"
	`include "router_test_lib.sv"

  initial
    // ---- TODO-16 -----------------------------------------------------------
    // Goi task toan cuc nao de khoi dong UVM?
    //
    // Ba lua chon, chon MOT:
    //   (i)   run_test("base_test");   -- khac cung ten test vao code
    //   (ii)  run_test();              -- bat buoc phai co +UVM_TESTNAME
    //   (iii) run_test("base_test");   + van cho phep +UVM_TESTNAME ghi de
    //
    // Cau hoi: (i) va (iii) khac nhau o cho nao? (Goi y: KHONG khac nhau ve
    //          cu phap -- doc lai Section 5 slide 12 dong cuoi.)
    //
    // Lab 2 muc tieu la "Launch DIFFERENT tests" -> nen chon cai nao?
    // ------------------------------------------------------------------------
	run_test();

endmodule : top
