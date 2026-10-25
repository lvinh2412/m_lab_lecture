// run.f  --  LAB 3  (SKELETON)
// Chay:  xrun -f run.f +UVM_TESTNAME=base_test

-64
-uvmhome $UVMHOME

// ---- RUN-1 -----------------------------------------------------------------
// Lab 3 co #10ns trong driver -> BAT BUOC phai co timescale.
// Thieu dong nay, Xcelium co the bao loi hoac dung don vi mac dinh khong mong muon.
// Them dong:   -timescale 1ns/100ps
// ----------------------------------------------------------------------------
-timescale 1ns/100ps

// Thu muc chua file include
-incdir ../sv


// ---- RUN-2 -----------------------------------------------------------------
// Danh sach file bien dich. CHI HAI FILE.
//
// Cau hoi truoc khi viet: trong 11 file cua Lab 3, vi sao chi 2 file
// xuat hien o day?  7 file trong sv/ di vao compiler bang duong nao?
// 2 file trong tb/ (router_tb.sv, router_test_lib.sv) thi sao?
// ----------------------------------------------------------------------------
+UVM_TESTNAME=base_test
../sv/yapp_pkg.sv
top.sv
