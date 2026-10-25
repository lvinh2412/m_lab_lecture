//------------------------------------------------------------------------------
// hw_top.sv   --   LAB 7  (SKELETON)
//
// Day la NHOM B1 cua quy trinh 3+3, lap lai cho ba UVC moi.
//
// File nay doi NHIEU nhat sau clkgen.sv:
//   - tu 1 interface  ->  6 interface
//   - clock/reset tu local  ->  do UVC lai
//   - cac port DUT dang buoc 1'b0  ->  noi vao interface that
//
// VAN KHONG co class UVM nao o day. Khong import uvm_pkg.
//------------------------------------------------------------------------------

module hw_top;

  // ---- HW-1 -----------------------------------------------------------------
  // *** BON tin hieu dung chung, khong phai hai nhu Lab 6 ***
  //
  //     logic [31:0] clock_period;
  //     logic        run_clock;
  //     logic        clock;
  //     logic        reset;
  //
  // Lab 6 chi co clock va reset. Hai cai moi (clock_period, run_clock)
  // la DAY DIEU KHIEN tu clock_and_reset UVC xuong clkgen.
  //
  // So do luong tin hieu:
  //
  //    clock_and_reset UVC (phan mem)
  //            |
  //            |  lai qua virtual interface
  //            v
  //    clk_rst_if  .run_clock, .clock_period     .reset
  //            |         |            |              |
  //            |         +------+-----+              |
  //            |                v                    |
  //            |             clkgen ---> clock       |
  //            |                           |         |
  //            +---------------------------+---------+
  //                                        |
  //                          moi interface khac + DUT
  //
  // Chu y chieu: reset di RA TU clk_rst_if (UVC lai no truc tiep),
  //              clock di RA TU clkgen (UVC lai gian tiep qua run_clock).
  // ---------------------------------------------------------------------------
	logic [31:0] clock_period;
	logic        run_clock;
	logic        clock;
	logic        reset;



  // ---- HW-2 -----------------------------------------------------------------
  // Interface YAPP -- GIU NGUYEN tu Lab 6, khong doi mot ky tu:
  //
  //     yapp_if in0(clock, reset);
  // ---------------------------------------------------------------------------
	yapp_if in0(clock, reset);



  // ---- HW-3 -----------------------------------------------------------------
  // BA interface CHANNEL.
  //
  //     channel_if ch0(clock, reset);
  //     channel_if ch1(clock, reset);
  //     channel_if ch2(clock, reset);
  //
  // *** DAY LA KHOANH KHAC "REUSABLE" TRO THANH CU THE ***
  // Mot file channel_if.sv, mot dong trong run.f, BA instance.
  // Doi chieu voi Section 11 slide 4: "Interface UVC -- reusable".
  //
  // Chu y: ca ba deu nhan CUNG clock va CUNG reset. Day la ly do
  // clock/reset phai la PORT cua interface chu khong phai tin hieu
  // ben trong -- cau hoi ban da hoi o Lab 6, gio thay hieu qua that.
  // Neu moi interface tu sinh clock rieng, sau clock nay se lech nhau.
  //
  // *** TEN INSTANCE ***
  // ch0/ch1/ch2 se xuat hien lai trong tb_top (TB-2) va trong duong dan
  // config. Doi ten o day thi phai doi dong bo.
  // ---------------------------------------------------------------------------
	channel_if ch0(clock, reset);
	channel_if ch1(clock, reset);
	channel_if ch2(clock, reset);



  // ---- HW-4 -----------------------------------------------------------------
  // Interface HBUS:
  //
  //     hbus_if hif(clock, reset);
  //
  // Mot cai thoi -- HBUS la bus cau hinh, chi co mot.
  // ---------------------------------------------------------------------------
	hbus_if hif(clock, reset);



  // ---- HW-5 -----------------------------------------------------------------
  // Interface CLOCK_AND_RESET.  *** CAI NAY KHAC HAN BON CAI KIA ***
  //
  //     clock_and_reset_if clk_rst_if (.clock(clock),
  //                                    .reset(reset),
  //                                    .run_clock(run_clock),
  //                                    .clock_period(clock_period));
  //
  // *** HAI DIEU PHAI NHAN RA ***
  //
  // (1) Bon interface kia NHAN clock/reset vao (input).
  //     Cai nay LAI RA clock... khong, chinh xac hon: no lai ra
  //     reset, run_clock, clock_period. Con clock thi no NHAN vao
  //     (de biet nhip ma lai).
  //
  //     Tu xac minh chieu cua tung port:
  //         grep -n "interface clock_and_reset_if" -A 10 \
  //              ../../clock_and_reset/sv/clock_and_reset_if.sv
  //
  //     [Chua xac minh] Toi chua doc file nay. Ban doc va ghi lai chieu
  //     (input/output) cua bon port vao day truoc khi viet.
  //
  // (2) Viet theo kieu ".port(tin_hieu)" chu khong phai theo thu tu.
  //     Bon port, de nham thu tu la noi sai ma khong bao loi.
  //     Bon interface kia chi co hai port nen viet theo thu tu con duoc.
  //
  // *** VONG LAP TIN HIEU ***
  // clk_rst_if nhan .clock(clock), ma clock lai do clkgen sinh, ma clkgen
  // lai nhan run_clock tu clk_rst_if. Vong tron?
  // Khong -- vi day la hai tin hieu KHAC NHAU di hai chieu. Ve so do
  // ra giay neu thay roi.
  // ---------------------------------------------------------------------------
	clock_and_reset_if clk_rst_if (.clock(clock),
                                   .reset(reset),
                                   .run_clock(run_clock),
                                   .clock_period(clock_period));


  // ---- HW-6 -----------------------------------------------------------------
  // CLKGEN -- *** DANH SACH PORT DOI HOAN TOAN ***
  //
  //     Lab 6:  clkgen clkgen (.clock(clock), .reset(reset));
  //     Lab 7:  clkgen clkgen (.clock(clock),
  //                            .run_clock(run_clock),
  //                            .clock_period(clock_period));
  //
  // Khong con port reset. Reset gio do clk_rst_if lai truc tiep (HW-5).
  //
  // Viet dong moi, XOA dong cu.
  // ---------------------------------------------------------------------------
	clkgen clkgen (.clock(clock),
                   .run_clock(run_clock),
                   .clock_period(clock_period));




  // ---- HW-7 -----------------------------------------------------------------
  // DUT. Khung giong Lab 6, nhung CHIN port doi tu "buoc cung" sang
  // "noi vao interface that".
  //
  //     yapp_router dut(
  //       .reset        (reset),
  //       .clock        (clock),
  //       .error        (),
  //
  //       // YAPP -- GIU NGUYEN tu Lab 6
  //       .in_data      (in0.in_data),
  //       .in_data_vld  (in0.in_data_vld),
  //       .in_suspend   (in0.in_suspend),
  //
  //       // BA KENH RA -- Lab 6 de trong / buoc 0, GIO NOI THAT
  //       .data_0(ch0.data), .data_vld_0(ch0.data_vld), .suspend_0(ch0.suspend),
  //       .data_1(ch1.data), .data_vld_1(ch1.data_vld), .suspend_1(ch1.suspend),
  //       .data_2(ch2.data), .data_vld_2(ch2.data_vld), .suspend_2(ch2.suspend),
  //
  //       // HOST BUS -- Lab 6 de trong / buoc 0, GIO NOI THAT
  //       .haddr(hif.haddr), .hdata(hif.hdata_w),
  //       .hen(hif.hen),     .hwr_rd(hif.hwr_rd)
  //     );
  //
  //===========================================================================
  // *** BON DIEU PHAI TU KIEM TRUOC KHI CHAY ***
  //===========================================================================
  //
  //  (1) *** .hdata(hif.hdata_w)  -- CHU Y HAU TO _w ***
  //
  //      [Da xac minh tu lab08_mcseq/tb/hw_top.sv] Dung la hdata_w,
  //      khong phai hdata.
  //
  //      Vi sao? hdata la bus HAI CHIEU (master ghi -> DUT doc;
  //      master doc -> DUT lai). Mot bien "logic" trong interface chi
  //      co mot nguon lai -- khong lam hai chieu duoc. Phai co mot
  //      "wire" rieng. Section 10 slide 14 noi ve chinh viec nay.
  //
  //      Tu kiem tra interface khai bao the nao:
  //          grep -n "hdata" ../../hbus/sv/hbus_if.sv
  //
  //      Ghi lai o day sau khi doc:
  //          hdata    la gi? ______________
  //          hdata_w  la gi? ______________
  //          chung noi voi nhau bang gi? ______________
  //
  //      Go thanh .hdata(hif.hdata) -> co the van bien dich duoc nhung
  //      du lieu doc ve sai hoac 'z. Loi im lang.
  //
  //
  //  (2) *** TEN TIN HIEU TRONG channel_if ***
  //
  //      Ten tren day (.data, .data_vld, .suspend) la toi chep tu
  //      lab08_mcseq/tb/hw_top.sv. Tu doi chieu voi interface that:
  //          grep -n "logic\|wire" ../../channel/sv/channel_if.sv
  //
  //
  //  (3) *** SO SANH VOI LAB 6 -- dem cho da doi ***
  //
  //      Lab 6:  .suspend_0(1'b0)       <- buoc cung ve 0
  //      Lab 7:  .suspend_0(ch0.suspend) <- Channel UVC lai
  //
  //      Day la BAY 5 trong README. Quen doi mot trong ba dong suspend
  //      -> kenh do khong bao gio "ban" -> flow control khong duoc kiem
  //      tra -> test van bao PASS. Loi khong bao gi ca.
  //
  //      Cach tu bat: sau khi chay, mo waveform, xem ch0.suspend /
  //      ch1.suspend / ch2.suspend. Ca ba phai co doi gia tri. Cai nao
  //      phang li ca mo phong la cai ban quen noi.
  //
  //
  //  (4) *** TEN PORT CUA RTL ***
  //
  //      Mo ../../router_rtl/yapp_router.sv, tim "module yapp_router"
  //      va doi chieu TEN + SO LUONG port. Danh sach tren day toi suy ra
  //      tu lab08_mcseq -- phien ban RTL cua ban co the khac.
  // ---------------------------------------------------------------------------


       yapp_router dut(
         .reset        (reset),
         .clock        (clock),
         .error        (),
  
         // YAPP -- GIU NGUYEN tu Lab 6
         .in_data      (in0.in_data),
         .in_data_vld  (in0.in_data_vld),
         .in_suspend   (in0.in_suspend),
  
         // BA KENH RA -- Lab 6 de trong / buoc 0, GIO NOI THAT
         .data_0(ch0.data), .data_vld_0(ch0.data_vld), .suspend_0(ch0.suspend),
         .data_1(ch1.data), .data_vld_1(ch1.data_vld), .suspend_1(ch1.suspend),
         .data_2(ch2.data), .data_vld_2(ch2.data_vld), .suspend_2(ch2.suspend),
  
         // HOST BUS -- Lab 6 de trong / buoc 0, GIO NOI THAT
         .haddr(hif.haddr), .hdata(hif.hdata_w),
         .hen(hif.hen),     .hwr_rd(hif.hwr_rd)
       );
 




endmodule : hw_top


//------------------------------------------------------------------------------
// CAU HOI
//
// 1. Dem so interface instance trong file nay. Dem so lenh
//    <uvc>_vif_config::set trong tb_top.sv. Hai so nay co bang nhau khong?
//    Phai bang nhau khong? Vi sao?
//
// 2. clk_rst_if nhan .clock(clock). Nhung clock do clkgen sinh, ma clkgen
//    nhan run_clock tu clk_rst_if. Tai thoi diem t=0, cai nao co gia tri
//    truoc? Co deadlock khong?
//    (Goi y: xem clkgen.sv -- "output logic clock=0". Gia tri khoi tao
//     pha vo vong cho.)
//
// 3. Neu doi ten instance ch0 -> chan0 trong file nay, ban phai sua
//    them o NHUNG DAU nao? Liet ke truoc khi lam.
//
// 4. hw_top khong import uvm_pkg. Nhung channel_if.sv co "import
//    channel_pkg::*". Vay khi instantiate channel_if o day, hw_top co
//    gian tiep "biet" channel_pkg khong?
//    (Goi y: import trong interface co pham vi la interface do thoi.
//     Day la ly do ranh gioi phan mem/phan cung sach se.)
//------------------------------------------------------------------------------
