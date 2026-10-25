//------------------------------------------------------------------------------
// router_module_pkg.sv   --   LAB 9B  (SKELETON)   *** FILE MOI ***
//
// *** FILE NAY BIEN MODULE UVC THANH MOT UVC THAT SU ***
//
// Section 11: UVC = THU MUC + PACKAGE.
//   Lab 9A: moi co thu muc sv/ -> chua phai UVC
//   Lab 9B: them package nay   -> gio la UVC
//
// File ngan nhat cua Lab 9B (khoang 12 dong), nhung no doi cach ca
// testbench nhin thay scoreboard.
//
// Doi chieu voi bon package ban da biet:
//     yapp_pkg.sv, channel_pkg.sv, hbus_pkg.sv, clock_and_reset_pkg.sv
// Cau truc y het.
//------------------------------------------------------------------------------


// ---- PKG-1 ------------------------------------------------------------------
// Mo package + nhap thu vien UVM.
//
//     package router_module_pkg;
//     import uvm_pkg::*;
//     `include "uvm_macros.svh"
//
// Giong het dau cua bon package UVC kia.
//
// *** CHU Y THU TU ***
// [Da xac minh] Repo viet import TRUOC `include "uvm_macros.svh".
// (clock_and_reset_pkg.sv thi nguoc lai -- `include truoc, import sau.
//  Ca hai deu chay. Lai mot cho khong nhat quan cua repo.)
// -----------------------------------------------------------------------------
package router_module_pkg;
	import uvm_pkg::*;
	`include "uvm_macros.svh"




// ---- PKG-2 ------------------------------------------------------------------
// BA dong import UVC.   *** PHAN QUAN TRONG NHAT CUA FILE ***
//
//     // import YAPP package for visibility of YAPP data item
//     import yapp_pkg::*;
//     // import Channel package for visibility of Channel data item
//     import channel_pkg::*;
//     // import HBUS package for visibility of HBUS data item
//     import hbus_pkg::*;
//
//=============================================================================
// *** VI SAO CAN CA BA ***
//=============================================================================
//
// Module UVC phai NHIN THAY ba kieu transaction:
//
//   +------------------+-------------------+------------------------------+
//   | import           | de thay           | dung o dau                   |
//   +------------------+-------------------+------------------------------+
//   | yapp_pkg::*      | yapp_packet       | reference.yapp_in            |
//   |                  |                   | reference.sb_add_out         |
//   |                  |                   | scoreboard.sb_yapp_in        |
//   |                  |                   | scoreboard.sb_queue0/1/2     |
//   +------------------+-------------------+------------------------------+
//   | channel_pkg::*   | channel_packet    | scoreboard.sb_chan0/1/2      |
//   +------------------+-------------------+------------------------------+
//   | hbus_pkg::*      | hbus_transaction  | reference.hbus_in            |
//   |                  | HBUS_WRITE (enum) | reference.write_hbus()       |
//   +------------------+-------------------+------------------------------+
//
// Thieu dong nao -> loi "<kieu> is not declared" o file con duoc include.
//
// *** DIEU NAY KHANG DINH LAI: MODULE UVC KHONG DUNG LAI DUOC ***
//
// Bon UVC giao thuc (yapp, channel, hbus, clock_and_reset) KHONG import
// nhau -- doc lai channel_pkg.sv, dong "import yapp_pkt_pkg::*" bi
// COMMENT. Chung doc lap hoan toan.
//
// Module UVC thi import CA BA. No phu thuoc vao ca ba.
// => khong the chep sang du an khac.
// Do chinh la dinh nghia "Module UVC" cua Section 11 slide 4.
//
// *** THU TU TRONG run.f ***
// Ba package kia phai bien dich TRUOC router_module_pkg.sv.
// Xem [RUN-2].
// -----------------------------------------------------------------------------


	import yapp_pkg::*;
	import channel_pkg::*;
	import hbus_pkg::*;

// ---- PKG-3 ------------------------------------------------------------------
// BA dong `include + dong package.
//
//     `include "router_scoreboard.sv"
//     `include "router_reference.sv"
//     `include "router_module_env.sv"
//
//     endpackage
//
//=============================================================================
// *** THU TU BA DONG NAY BAT BUOC ***
//=============================================================================
//
//   router_scoreboard.sv        <- khong nhac den class nao khac
//          ^
//   router_reference.sv         <- cung khong nhac (chi dung yapp_packet)
//          ^
//   router_module_env.sv        <- khai CA HAI:
//                                    router_reference  reference;
//                                    router_scoreboard scoreboard;
//
// router_module_env.sv phai di CUOI.
//
// [Da xac minh] Repo dat dung thu tu tren. Hai dong dau co the dao cho
// nhau -- thu di de xac nhan.
//
// Dao router_module_env.sv len dau -> loi "router_reference is not
// declared".
//
// Luat cu tu Lab 6: `include la DAN CHU. Sau khi dan, ca package thanh
// MOT file tuyen tinh, class phai khai truoc khi duoc nhac den.
//
//=============================================================================
// *** SO SANH VOI LAB 9A ***
//=============================================================================
//
//   Lab 9A:  tb_top.sv  `include "router_scoreboard.sv"
//            -> class nam trong PHAM VI cua module tb_top
//
//   Lab 9B:  router_module_pkg.sv  `include "router_scoreboard.sv"
//            tb_top.sv             import router_module_pkg::*;
//            -> class nam trong PHAM VI cua package
//
// Khac biet thuc te:
//   (a) run.f phai liet ke router_module_pkg.sv  (Lab 9A khong liet ke gi)
//   (b) tb_top doi tu `include sang import
//   (c) log bien dich co them mot dong "package worklib.router_module_pkg"
//   (d) ba class gio co the duoc import tu NHIEU module khac nhau
//       (Lab 9A thi chi tb_top thay)
// -----------------------------------------------------------------------------
`include "router_scoreboard.sv"
	`include "router_reference.sv"
	`include "router_module_env.sv"

endpackage

//==============================================================================
// TU KIEM TRA
//==============================================================================
//
// 1. Dem so dong code that (bo comment): khoang 12. File ngan nhat cua
//    Lab 9B, nhung thu bo no di xem testbench con bien dich duoc khong.
//
// 2. Doi chieu file nay voi ../../yapp/sv/yapp_pkg.sv. Diem giong?
//    Diem khac lon nhat la gi?
//    (Goi y: yapp_pkg co import package nao khac khong?)
//
// 3. File nay KHONG co dong typedef vif_config nhu bon UVC kia:
//        typedef uvm_config_db#(virtual yapp_if) yapp_vif_config;
//    Vi sao Module UVC khong can? (Goi y: no co interface khong?
//    No co cham vao day nao khong?)
//
// 4. Sau khi them file nay, chay va grep:
//        grep -E "^file:|package worklib" log9b.log
//    Phai thay them dong:
//        file: ../sv/router_module_pkg.sv
//            package worklib.router_module_pkg:sv
//    Tong so dong "file:" la bao nhieu? (Lab 9A la 12)
//
// 5. Thu them "../sv/router_scoreboard.sv" vao run.f (ngoai package).
//    Loi gi? O dong nao? Vi sao?
//
//==============================================================================
