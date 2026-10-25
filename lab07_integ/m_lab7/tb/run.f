// run.f  --  LAB 7  (SKELETON)
//
// Day la NHOM A cua quy trinh 3+3: ba dong cho moi UVC moi.
//
// Chay:  xrun -f run.f +UVM_TESTNAME=simple_test -l log7.log

-64
-uvmhome $UVMHOME
-timescale 1ns/100ps

+UVM_VERBOSITY=UVM_LOW
+UVM_TESTNAME=base_test
//+UVM_TESTNAME=simple_test


// ---- RUN-1 ------------------------------------------------------------------
// *** DUONG DAN DOI ***
//
// Lab 6:  -incdir ../sv              <- yapp/sv nam ngay canh tb/
// Lab 7:  -incdir ../../yapp/sv      <- yapp/sv gio la thu muc DUNG CHUNG
//
// Sua dong -incdir cu cho dung, roi THEM ba dong -incdir nua:
//
//     -incdir ../../yapp/sv
//     -incdir ../../channel/sv
//     -incdir ../../hbus/sv
//     -incdir ../../clock_and_reset/sv
//
// *** -incdir LAM GI ***
// Khi compiler gap `include "channel_packet.sv" ben trong channel_pkg.sv,
// no tim file do trong cac thu muc liet ke boi -incdir.
// Thieu -incdir -> loi "cannot find include file".
//
// Cau hoi: vi sao can -incdir cho channel/sv trong khi dong duoi day da
//          ghi RO duong dan day du "../../channel/sv/channel_pkg.sv"?
//          (Goi y: duong dan do la cho CHINH file pkg. Con cac file
//           BEN TRONG no thi sao?)
//
// Kiem tra truoc khi chay:
//     ls ../../yapp/sv ../../channel/sv ../../hbus/sv ../../clock_and_reset/sv
// -----------------------------------------------------------------------------
-incdir ../../../yapp/sv
-incdir ../../../channel/sv
-incdir ../../../hbus/sv
-incdir ../../../clock_and_reset/sv


// ---- RUN-2 ------------------------------------------------------------------
// BON CAP package + interface.
//
// Quy tac tu Lab 6 (Section 10 slide 5), gio lap lai bon lan:
//     <uvc>_pkg.sv  TRUOC
//     <uvc>_if.sv   SAU
// vi file _if.sv co dong "import <uvc>_pkg::*;".
//
// Viet tam day:
//
//     ../../yapp/sv/yapp_pkg.sv
//     ../../yapp/sv/yapp_if.sv
//     ../../channel/sv/channel_pkg.sv
//     ../../channel/sv/channel_if.sv
//     ../../hbus/sv/hbus_pkg.sv
//     ../../hbus/sv/hbus_if.sv
//     ../../clock_and_reset/sv/clock_and_reset_pkg.sv
//     ../../clock_and_reset/sv/clock_and_reset_if.sv
//
// *** BA CAU HOI ***
//
//  (1) BA kenh chan0/chan1/chan2 nhung chi MOT dong channel_if.sv.
//      Vi sao khong phai ba dong?
//      (Goi y: mot dong nay bien dich DINH NGHIA kieu. Instantiate bao
//       nhieu lan la viec cua hw_top.)
//
//  (2) Thu tu GIUA cac UVC co quan trong khong?
//      Vi du: dat ca cum clock_and_reset len dau tien duoc khong?
//      (Goi y: co package nao import package khac khong? Kiem tra:
//           grep -n "import" ../../channel/sv/channel_pkg.sv)
//
//  (3) Co UVC nao KHONG co file _if.sv khong? Kiem tra:
//           ls ../../*/sv/*_if.sv
//      Neu co, bang 3+3 cua UVC do chi con 2+3. Ghi lai vao README.
// -----------------------------------------------------------------------------
../../../yapp/sv/yapp_pkg.sv
../../../yapp/sv/yapp_if.sv
../../../channel/sv/channel_pkg.sv
../../../channel/sv/channel_if.sv
../../../hbus/sv/hbus_pkg.sv
../../../hbus/sv/hbus_if.sv
../../../clock_and_reset/sv/clock_and_reset_pkg.sv
../../../clock_and_reset/sv/clock_and_reset_if.sv





// ---- RUN-3 ------------------------------------------------------------------
// Ba module top -- GIU NGUYEN tu Lab 6, khong doi:
//
//     clkgen.sv
//     tb_top.sv
//     hw_top.sv
//
// (Noi dung clkgen.sv doi hoan toan, nhung DONG trong run.f thi khong doi.)
// -----------------------------------------------------------------------------

clkgen.sv
tb_top.sv
hw_top.sv


// ---- RUN-4 ------------------------------------------------------------------
// RTL -- GIU NGUYEN tu Lab 6:
//
//     ../../router_rtl/yapp_router.sv
//
// Duong dan nay khong doi vi lab07_my/ nam cung cap voi lab06_my/.
// Neu ban dat thu muc o cho khac thi sua lai.
// -----------------------------------------------------------------------------

../../../router_rtl/yapp_router.sv


//------------------------------------------------------------------------------
// BANG DOI CHIEU: Lab 6 -> Lab 7
//
//   Lab 6                         Lab 7
//   ---------------------------   -----------------------------------------
//   -incdir ../sv                 -incdir ../../yapp/sv            (SUA)
//   (khong co)                    -incdir ../../channel/sv         (THEM)
//   (khong co)                    -incdir ../../hbus/sv            (THEM)
//   (khong co)                    -incdir ../../clock_and_reset/sv (THEM)
//
//   ../sv/yapp_pkg.sv             ../../yapp/sv/yapp_pkg.sv        (SUA)
//   ../sv/yapp_if.sv              ../../yapp/sv/yapp_if.sv         (SUA)
//   (khong co)                    channel_pkg.sv + channel_if.sv   (THEM)
//   (khong co)                    hbus_pkg.sv + hbus_if.sv         (THEM)
//   (khong co)                    clock_and_reset_pkg + _if        (THEM)
//
//   clkgen.sv                     clkgen.sv          (dong giu, FILE doi)
//   tb_top.sv                     tb_top.sv          (giu)
//   hw_top.sv                     hw_top.sv          (giu)
//   ../../router_rtl/...          ../../router_rtl/...  (giu)
//
//   TONG: 6 dong                  TONG: 14 dong
//------------------------------------------------------------------------------
