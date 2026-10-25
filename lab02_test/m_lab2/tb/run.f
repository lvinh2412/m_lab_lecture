// run.f  --  LAB 2  (phien ban SKELETON)
// Chay:  xrun -f run.f

// 64-bit
-64

// Tro toi thu vien UVM
-uvmhome $UVMHOME

// Thu muc chua file include (yapp_packet.sv nam trong ../sv/)
-incdir ../sv


// ---- TODO-17 ---------------------------------------------------------------
// Hai option dong lenh. Bo comment va dien gia tri.
//
//   +UVM_VERBOSITY=?     <- de thay cac dong `uvm_info verbosity UVM_HIGH
//                           (mac dinh la gi?  Section 5 slide 17)
//   +UVM_TESTNAME=?      <- ten test muon chay
//
// Meo: bo comment o day thi moi lan doi test phai sua file.
//      De nguyen comment va truyen trong dong lenh thi linh hoat hon:
//          xrun -f run.f +UVM_TESTNAME=test2
// -----------------------------------------------------------------------------
+UVM_VERBOSITY=UVM_HIGH
+UVM_TESTNAME=test2


// ---- TODO-18 ---------------------------------------------------------------
// Danh sach file bien dich. THU TU QUAN TRONG.
//   - package yapp_pkg (chua yapp_packet tu Lab 1)
//   - module top
// Cau hoi: vi sao KHONG liet ke yapp_packet.sv o day?
//          vi sao KHONG liet ke router_tb.sv va router_test_lib.sv?
// -----------------------------------------------------------------------------

../sv/yapp_pkg.sv
top.sv
