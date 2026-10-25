// run.f  --  LAB 6  (SKELETON)
//
// File nay thay doi NHIEU so voi Lab 5. Lan dau tien co RTL va interface.
//
// Chay:  xrun -f run.f +UVM_TESTNAME=exhaustive_seq_test -l log6.log

-64
-uvmhome $UVMHOME
-timescale 1ns/100ps
-incdir ../sv

+UVM_VERBOSITY=UVM_HIGH
//+UVM_TESTNAME=base_test
//+UVM_TESTNAME=test2
//+UVM_TESTNAME=short_packet_test
//+UVM_TESTNAME=incr_payload_test
+UVM_TESTNAME=exhaustive_seq_test
//+UVM_TESTNAME=set_config_test


// ---- RUN-1 ------------------------------------------------------------------
// Package cua UVC -- GIU NGUYEN dong nay tu Lab 5:
//
//     ../sv/yapp_pkg.sv
//
// Bay gio THEM dong bien dich INTERFACE, ngay sau no:
//
//     ../sv/yapp_if.sv
//
// *** VI SAO PHAI LIET KE RIENG? ***
// Section 10 slide 5: "An interface must be compiled separately like a module.
//                      Cannot include inside a package or other module."
//
// Moi file .sv khac cua UVC (packet, driver, monitor...) deu di vao compiler
// qua `include trong yapp_pkg.sv. Interface la NGOAI LE DAU TIEN.
//
// *** THU TU CUNG QUAN TRONG ***
// yapp_if.sv co dong "import yapp_pkg::*;" -> package phai bien dich TRUOC.
// Dao nguoc hai dong nay se loi bien dich.
// -----------------------------------------------------------------------------
../sv/yapp_pkg.sv
../sv/yapp_if.sv



// ---- RUN-2 ------------------------------------------------------------------
// HAI module top. Lab 5 chi co "top.sv", gio tach lam hai:
//
//     clkgen.sv
//     tb_top.sv
//     hw_top.sv
//
// Va XOA dong "top.sv" cu di.
//
// Cau hoi: thu tu ba dong nay co quan trong khong? Vi sao?
//          (Khac voi RUN-1 -- nghi ky truoc khi tra loi)
// -----------------------------------------------------------------------------
clkgen.sv
tb_top.sv
hw_top.sv



// ---- RUN-3 ------------------------------------------------------------------
// RTL cua DUT. Lan dau tien testbench co phan cung that de kiem tra.
//
//     ../../router_rtl/yapp_router.sv
//
// Kiem tra duong dan tuong doi cho dung voi cay thu muc cua BAN.
// Tu lab06_my/tb/ di nguoc len hai cap la toi thu muc goc cua repo.
// Neu cay thu muc cua ban khac, sua lai cho phu hop:
//
//     ls ../../router_rtl/
//
// -----------------------------------------------------------------------------
../../../router_rtl/yapp_router.sv



//------------------------------------------------------------------------------
// BANG DOI CHIEU: Lab 5 -> Lab 6
//
//   Lab 5                      Lab 6
//   ----------------------     -------------------------------
//   ../sv/yapp_pkg.sv          ../sv/yapp_pkg.sv       (giu)
//   (khong co)                 ../sv/yapp_if.sv        (THEM)
//   top.sv                     clkgen.sv               (THEM)
//                              tb_top.sv               (THEM)
//                              hw_top.sv               (THEM)
//   (khong co)                 ../../router_rtl/yapp_router.sv  (THEM)
//
//   -timescale khong bat buoc  -timescale BAT BUOC
//     (driver chi #10ns)         (interface co @edge va #delay that)
//------------------------------------------------------------------------------
