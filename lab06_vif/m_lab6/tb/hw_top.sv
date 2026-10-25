//------------------------------------------------------------------------------
// hw_top.sv   --   LAB 6  (SKELETON)   *** FILE MOI ***
//
// PHAN CUNG. Tat ca trong file nay deu tong hop duoc.
// KHONG co class UVM nao o day. Khong import uvm_pkg.
//
// Ba viec:  (1) tao tin hieu clock/reset
//           (2) instantiate INTERFACE
//           (3) instantiate DUT va noi day
//
// Tham khao: Section 10 slide 10
//------------------------------------------------------------------------------

module hw_top;

  // ---- HW-1 -----------------------------------------------------------------
  // Khai hai tin hieu dung chung:
  //
  //     logic clock;
  //     logic reset;
  //
  // Chung do clkgen lai (xem clkgen.sv), va duoc truyen VAO interface
  // nhu port.
  // ---------------------------------------------------------------------------
	logic clock;
	logic reset;


  // ---- HW-2 -----------------------------------------------------------------
  // INSTANTIATE interface YAPP.
  //
  //     yapp_if in0(clock, reset);
  //       │     │     └──────┬────┘
  //       │     │            └─ hai PORT cua interface (xem IF-1)
  //       │     └─ TEN INSTANCE
  //       └─ kieu interface
  //
  // *** TEN INSTANCE QUAN TRONG ***
  // Ten nay se xuat hien trong tb_top:   yapp_vif_config::set(..., hw_top.in0)
  //                                                                      ^^^
  // Doi ten o day thi phai doi ca o kia. Repo dung "in0".
  // ---------------------------------------------------------------------------
	yapp_if in0(clock, reset);


  // ---- HW-3 -----------------------------------------------------------------
  // INSTANTIATE clock generator.
  //
  //     clkgen clkgen (.clock(clock), .reset(reset));
  //
  // (Xem clkgen.sv -- da cho san, khong phai viet)
  //
  // *** NEU QUEN DONG NAY ***
  // clock khong bao gio doi -> moi @(negedge clock) trong interface treo mai
  // -> mo phong chay vo han, 0 goi, khong loi gi.  (Bay 3a trong README)
  // ---------------------------------------------------------------------------
	clkgen clkgen(.clock(clock), .reset(reset));


  // ---- HW-4 -----------------------------------------------------------------
  // INSTANTIATE DUT va noi tin hieu interface vao port cua no.
  //
  //     yapp_router dut(
  //       .reset        (reset),
  //       .clock        (clock),
  //       .error        (),                  // de trong -- chua dung
  //       // ba tin hieu YAPP -- lay TU INTERFACE ra
  //       .in_data      (in0.in_data),
  //       .in_data_vld  (in0.in_data_vld),
  //       .in_suspend   (in0.in_suspend),
  //       // ba kenh ra -- Lab 6 CHUA co Channel UVC nen de trong
  //       .data_0(), .data_vld_0(), .suspend_0(1'b0),
  //       .data_1(), .data_vld_1(), .suspend_1(1'b0),
  //       .data_2(), .data_vld_2(), .suspend_2(1'b0),
  //       // host bus -- Lab 6 chua co HBUS UVC
  //       .haddr(), .hdata(), .hen(1'b0), .hwr_rd(1'b0)
  //     );
  //
  // *** BA DIEU PHAI TU KIEM ***
  //
  //  (1) Mo router_rtl/yapp_router.sv, tim dong "module yapp_router(...)"
  //      va DOI CHIEU TEN PORT. Ten tren day la toi suy ra tu lab08_mcseq
  //      -- co the khac o ban RTL ban dang co.
  //
  //  (2) suspend_0/1/2 PHAI buoc ve 0, KHONG duoc de trong.
  //      De trong -> no la 'z -> router coi la "dang ban" -> in_suspend
  //      len 1 mai -> interface treo o @(... iff !in_suspend)
  //      -> assertion YAPP_SUSPENDED se bat va $finish.
  //      Day la Bay 3c trong README.
  //
  //  (3) Cu phap ".in_data(in0.in_data)" la lay MOT TIN HIEU trong
  //      interface ra noi vao mot port. Khong phai noi ca interface.
  //      (Section 10 slide 5: "truy cap qua toan tu cham")
  // ---------------------------------------------------------------------------

	yapp_router dut(
		.reset        (reset),
		.clock        (clock),
		.error        (),
		.in_data      (in0.in_data),
		.in_data_vld  (in0.in_data_vld),
		.in_suspend   (in0.in_suspend),
		.data_0(), .data_vld_0(), .suspend_0(1'b0),
		.data_1(), .data_vld_1(), .suspend_1(1'b0),
		.data_2(), .data_vld_2(), .suspend_2(1'b0),
		.haddr(), .hdata(), .hen(1'b0), .hwr_rd(1'b0)
	);


endmodule : hw_top


//------------------------------------------------------------------------------
// CAU HOI
//
// 1. File nay co import uvm_pkg khong? Co `include "uvm_macros.svh" khong?
//    Vi sao?
//
// 2. Neu doi ten instance "in0" thanh "yapp_in", ban phai sua them o dau?
//
// 3. hw_top va tb_top deu la module top-level (khong ai instantiate chung).
//    Lam sao tb_top "nhin thay" duoc hw_top.in0?
//    (Goi y: hai module top-level cung nam trong mot do root scope)
//------------------------------------------------------------------------------
