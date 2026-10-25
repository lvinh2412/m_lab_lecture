//------------------------------------------------------------------------------
// tb_top.sv   --   LAB 7  (SKELETON)
//
// Day la NHOM B2 + B3 cua quy trinh 3+3.
//
// Cau truc KHONG doi so voi Lab 6. Chi la moi thu nhan len:
//     1 import  ->  4 import
//     1 set     ->  6 set
//
// Neu ban hieu Lab 6, file nay khong co gi moi. Chi co cho sai nhieu hon.
//------------------------------------------------------------------------------

module tb_top;

  // ---- TB-1 -----------------------------------------------------------------
  // IMPORT.  Lab 6 co ba dong dau, gio them BA dong package UVC moi:
  //
  //     import uvm_pkg::*;
  //     `include "uvm_macros.svh"
  //     import yapp_pkg::*;
  //     import hbus_pkg::*;
  //     import channel_pkg::*;
  //     import clock_and_reset_pkg::*;
  //     `include "router_tb.sv"
  //     `include "router_test_lib.sv"
  //
  // *** THU TU QUAN TRONG O MOT CHO ***
  // Bon dong import phai di TRUOC hai dong `include.
  // Vi sao? router_tb.sv co khai bao "channel_env chan0;" -- compiler
  // phai biet channel_env la gi TRUOC khi doc dong do.
  //
  // Ngoai ra, thu tu giua BON dong import co quan trong khong?
  // Tu tra loi truoc khi go. (Lien quan cau hoi RUN-2 (2))
  // ---------------------------------------------------------------------------
	import uvm_pkg::*;
    `include "uvm_macros.svh"
    import yapp_pkg::*;
    import hbus_pkg::*;
    import channel_pkg::*;
    import clock_and_reset_pkg::*;
    `include "router_tb.sv"
    `include "router_test_lib.sv"


  initial begin

    // ---- TB-2 ---------------------------------------------------------------
    // SAU lenh set virtual interface.
    //
    // Khung chung, giong het Lab 6:
    //     <uvc>_vif_config::set( null, "<duong_dan>", "vif", hw_top.<instance> );
    //                             ^^^^                        ^^^^^^^^^^^^^^^^
    //                        goi tu module             ten dat o hw_top
    //
    // Sau dong can viet:
    //
    //   (a) YAPP     -- GIU NGUYEN tu Lab 6, khong doi
    //
    //   (b) HBUS     -- duong dan: "*.tb.hbus.*"
    //                   gia tri  : hw_top.hif
    //
    //   (c,d,e) CHANNEL x3 -- BA dong rieng:
    //                   "*.tb.chan0.*"  <- hw_top.ch0
    //                   "*.tb.chan1.*"  <- hw_top.ch1
    //                   "*.tb.chan2.*"  <- hw_top.ch2
    //
    //   (f) CLOCK_AND_RESET -- duong dan: "*.tb.clock_and_reset*"
    //                          gia tri  : hw_top.clk_rst_if
    //
    //=========================================================================
    // *** BON DIEU PHAI NGHI KY ***
    //=========================================================================
    //
    //  (1) *** VI SAO CHANNEL CAN BA LENH SET RIENG? ***
    //
    //      Khong the viet gon thanh mot dong:
    //          channel_vif_config::set(null, "*.tb.chan?.*", "vif", ???);
    //
    //      Vi GIA TRI khac nhau! chan0 phai nhan ch0, chan1 nhan ch1.
    //      Wildcard gon duoc DUONG DAN, khong gon duoc GIA TRI.
    //
    //      Doi chieu: o simple_test (TEST-3) ban SE viet duoc mot dong
    //      cho ca ba kenh -- vi o do gia tri GIONG NHAU (cung mot
    //      sequence type). Hai truong hop khac nhau o diem nay.
    //
    //      *** Day la mot trong nhung cho de nham nhat cua Lab 7. ***
    //
    //
    //  (2) *** DAU CHAM TRONG DUONG DAN CLOCK_AND_RESET ***
    //
    //      Chu y:  "*.tb.clock_and_reset*"      <- KHONG co dau cham
    //      chu khong phai
    //              "*.tb.clock_and_reset.*"     <- CO dau cham
    //
    //      Khac nhau o cho nao?
    //          "clock_and_reset*"   khop:  clock_and_reset
    //                                      clock_and_reset.agent
    //                                      clock_and_reset.agent.driver
    //          "clock_and_reset.*"  khop:  clock_and_reset.agent
    //                                      clock_and_reset.agent.driver
    //                               KHONG khop: clock_and_reset  (chinh no)
    //
    //      [Suy luan] Repo viet ban khong co dau cham. Toi cho rang vi
    //      component CHINH clock_and_reset env cung can doc vif, khong chi
    //      con cua no. Nhung toi chua doc clock_and_reset_env.sv de xac
    //      nhan. Ban tu kiem tra:
    //          grep -n "get.*vif" ../../clock_and_reset/sv/*.sv
    //      Neu chi driver va monitor doc vif thi hai cach deu duoc.
    //
    //
    //  (3) *** TEN TYPEDEF ***
    //
    //      yapp_vif_config, channel_vif_config, hbus_vif_config,
    //      clock_and_reset_vif_config -- bon typedef khac nhau, moi UVC
    //      tu dinh nghia trong package cua no.
    //
    //      Dung nham typedef cua UVC nay cho UVC kia -> set vao mot kieu,
    //      get bang kieu khac -> KHONG KHOP -> UVM_ERROR [NOVIF].
    //      Khong co loi bien dich. Section 7: config_db khop theo
    //      KIEU + DUONG DAN + TEN TRUONG, ca ba deu phai dung.
    //
    //      Tu tim dinh nghia:
    //          grep -rn "typedef.*vif_config" ../../*/sv/
    //
    //
    //  (4) *** DAT SAU LENH NAY TRUOC run_test() ***
    //      Luat cu tu Lab 6. Gio co sau dong, van phai het truoc run_test.
    // -------------------------------------------------------------------------




    // ---- TB-3 ---------------------------------------------------------------
    //     run_test();
    //
    // Giu nguyen, dat CUOI CUNG.
    // -------------------------------------------------------------------------
	
	  yapp_vif_config::set(null,"*.tb.yapp.tx_agent.*","vif", hw_top.in0);
	      hbus_vif_config::set(null,"*.tb.hbus.*","vif", hw_top.hif);
	      channel_vif_config::set(null,"*.tb.chan0.*","vif", hw_top.ch0);
	      channel_vif_config::set(null,"*.tb.chan1.*","vif", hw_top.ch1);
	      channel_vif_config::set(null,"*.tb.chan2.*","vif", hw_top.ch2);
	      clock_and_reset_vif_config::set(null, "*.tb.clock_and_reset*", "vif", hw_top.clk_rst_if);

	      run_test();







  end

endmodule : tb_top


//------------------------------------------------------------------------------
// TU KIEM TRA
//------------------------------------------------------------------------------
//
// 1. Dem: file nay co bao nhieu lenh set? hw_top.sv co bao nhieu interface
//    instance? Hai so phai bang nhau. Neu lech -> co interface khong ai
//    dung, hoac co UVC khong co vif.
//
// 2. *** CACH BAT LOI DUONG DAN NHANH NHAT ***
//
//    Cho mot lan chay hong, roi doc hai thu trong log:
//
//    (a) print_topology()  -- them vao end_of_elaboration_phase cua base_test:
//            uvm_top.print_topology();
//        Doc ra TEN THAT cua tung component. Doi chieu tung ky tu voi
//        duong dan ban go.
//
//    (b) check_config_usage() -- them vao check_phase cua base_test:
//            check_config_usage();
//        No in ra moi resource co GHI ma KHONG AI DOC.
//        Mot dong "vif" xuat hien o day = mot duong dan ban go sai.
//
//    Hai cai nay la cap doi debug cua Section 7 slide 11. Lab 7 la lan
//    dau chung THAT SU can thiet -- Lab 6 chi co mot duong dan, nhin mat
//    thuong cung ra. Sau duong dan thi khong.
//
// 3. Gia su ban go nham "*.tb.chan1.*" thanh "*.tb.chan0.*" (hai dong
//    cung tro chan0). Chuyen gi xay ra?
//      - chan0 nhan vif may lan? Lan nao thang?  (Section 7: config
//        LAST-ONE-WINS -- nguoc voi factory first-match-wins)
//      - chan1 nhan duoc gi?
//      - check_config_usage co bat duoc khong? Vi sao co / vi sao khong?
//    Tra loi ba cau tren GIAY truoc, roi thu that bang cach go sai co y.
//
// 4. So sanh so dong cua tb_top Lab 6 va Lab 7. File nay co "kho hon"
//    khong, hay chi "dai hon"? Y nghia gi ve kha nang mo rong cua UVM?
//------------------------------------------------------------------------------
