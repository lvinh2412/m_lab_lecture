//------------------------------------------------------------------------------
// tb_top.sv   --   LAB 6  (SKELETON)   *** FILE MOI ***
//
// PHAN MEM. Day la top.sv cu cua ban, THEM mot viec:
// noi virtual interface truoc khi chay test.
//
// Tham khao: Section 10 slide 10, 11
//------------------------------------------------------------------------------

module tb_top;

  // ---- TB-1 -----------------------------------------------------------------
  // Phan nay GIONG HET top.sv cu cua Lab 5. Chep sang:
  //
  //     import uvm_pkg::*;
  //     `include "uvm_macros.svh"
  //     import yapp_pkg::*;
  //     `include "router_tb.sv"
  //     `include "router_test_lib.sv"
  //
  // Khong doi gi.
  // ---------------------------------------------------------------------------
	import uvm_pkg::*;
	`include "uvm_macros.svh"
	import yapp_pkg::*;
	`include "router_tb.sv"
	`include "router_test_lib.sv"


  initial begin

    // ---- TB-2 ---------------------------------------------------------------
    // *** DONG QUAN TRONG NHAT CUA LAB 6 ***
    //
    // Gui interface vat ly vao config database, de driver va monitor
    // lay ra duoc.
    //
    //     <ten_typedef>::set( <context>, <instance>, <field>, <value> );
    //
    // Bon doi so:
    //
    //  (a) context   -- ban dang goi tu MODULE, khong phai component.
    //                   Module khong co "this". Dien gi?
    //                   (Section 10 slide 11 -- "Context is null")
    //
    //  (b) instance  -- vi context la (a), duong dan phai la TUYET DOI.
    //                   Phai khop CA driver LAN monitor, nen can wildcard.
    //                   Lay duong dan tu print_topology() cua chinh ban:
    //                       uvm_test_top.tb.yapp.tx_agent.driver
    //                       uvm_test_top.tb.yapp.tx_agent.monitor
    //                   Viet mot chuoi khop CA HAI.
    //
    //                   Repo viet:  "*.tb.yapp.tx_agent.*"
    //                   Slide viet: "uvm_test_top.tb.yapp.*"
    //                   Ca hai deu duoc. Dau "*" o dau BEN hon -- vi sao?
    //
    //  (c) field     -- ten mon hang. PHAI GIONG HET ben get trong
    //                   driver/monitor. Repo dung "vif".
    //
    //  (d) value     -- interface THAT, lay tu module kia:
    //                       hw_top.in0
    //                   (ten instance ban dat o HW-2)
    // -------------------------------------------------------------------------
	yapp_vif_config::set(null, "*.tb.yapp.tx_agent.*", "vif", hw_top.in0);


    // ---- TB-3 ---------------------------------------------------------------
    //     run_test();
    //
    // *** VI TRI DONG NAY QUYET DINH THANH BAI ***
    //
    // run_test() la cho ca cay UVM duoc dung len (build_phase chay tu day).
    // Lenh set() o TB-2 phai nam TRUOC no.
    //
    // Dat sai thu tu:
    //     run_test();              <- cay dung xong, driver da connect_phase
    //     ...::set(...);           <- gui vao kho, QUA MUON, khong ai lay
    //
    //     => vif = null  ->  [NOVIF] error  ->  hoac crash khi vif.send_to_dut
    //
    // Day la luat cu tu Section 7: "config phai set TRUOC khi dich duoc build".
    // -------------------------------------------------------------------------
	run_test();


  end

endmodule : tb_top


//------------------------------------------------------------------------------
// TU KIEM TRA
//
// 1. So sanh dong set() o TB-2 voi dong set() trong base_test:
//
//       base_test :  uvm_config_int::set( this, "tb.yapp.tx_agent", "is_active", ...)
//       tb_top    :  yapp_vif_config::set( null, "*.tb.yapp...",     "vif",      ...)
//                                           ^^^^
//    Vi sao mot ben "this" mot ben "null"?
//
// 2. Neu ban go sai ten field thanh "v_if", chuyen gi xay ra?
//    Co loi bien dich khong? Co UVM_ERROR khong? Cai nao bao cho ban biet?
//    (Goi y: [NOVIF] tu driver, va [CFGNRD] tu check_config_usage)
//
// 3. Lab 6 chi co MOT lenh set. Lab 7 se co SAU.
//    Doc truoc lab07_integ/tb/tb_top.sv de thay no mo rong the nao.
//------------------------------------------------------------------------------
