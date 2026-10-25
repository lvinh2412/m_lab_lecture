//------------------------------------------------------------------------------
// clkgen.sv   --   LAB 7   *** CHO SAN -- CHEP DE, KHONG PHAI VIET ***
//
// [Da xac minh] File nay toi lay nguyen van tu lab08_mcseq/tb/clkgen.sv
// trong repo cua ban. Ban Lab 7 giong ban Lab 8.
//
// *** DAY LA FILE DOI NHIEU NHAT SO VOI LAB 6 ***
//
//   Lab 6:  clkgen tu sinh clock VA reset. Chu ky cung nhac (parameter).
//           Khong ai dieu khien duoc no tu testbench.
//
//   Lab 7:  clkgen tro thanh mot thiet bi THU DONG.
//           No nhan hai tin hieu VAO:  run_clock, clock_period
//           Hai tin hieu do do CLOCK_AND_RESET UVC lai.
//           No khong con sinh reset nua -- UVC lai reset.
//
//   => Doi chu ky clock gio la doi mot so trong sequence, khong phai
//      sua file nay va bien dich lai.
//------------------------------------------------------------------------------

// TODO Parameterize clock_period
`ifdef IXCOM_1X

module clkgen(output logic clock=0, input run_clock, logic [31:0] clock_period);
  always begin
    #10;
    clock = ~clock;
  end
endmodule

`else

module clkgen(output logic clock=0, input run_clock, logic [31:0] clock_period);

  `ifdef IXCOM_UXE
  initial $ixc_ctrl("map_delays");
  `endif

  always begin
    #(clock_period/2);
    clock = (run_clock == 1) ? ~clock : 0;
  end

endmodule

`endif


//------------------------------------------------------------------------------
// DOC HIEU FILE NAY  (bat buoc -- no giai thich ca kien truc Lab 7)
//------------------------------------------------------------------------------
//
// DONG QUAN TRONG NHAT:
//
//     clock = (run_clock == 1) ? ~clock : 0;
//
// Doc ra tieng Viet: "neu dang duoc phep chay thi dao, khong thi giu o 0".
//
//   - run_clock = 0  ->  clock dung im o muc 0.   KHONG PHAI dung bang
//                        cach dung vong lap, ma bang cach VAN QUAY
//                        nhung lan nao cung gan 0.
//   - run_clock = 1  ->  clock dao moi nua chu ky.
//
// *** HAI DIEU PHAI NHAN RA ***
//
// (1) O t = 0, run_clock chua ai lai -> no la 'x hoac 'z.
//     So sanh ('x == 1) cho ket qua FALSE -> clock = 0.
//     => clock DUNG YEN cho den khi clock_and_reset UVC lai run_clock = 1.
//
//     Day la ly do Buoc 1 trong README se HONG: ban thay clkgen moi vao
//     nhung chua co UVC lai run_clock -> clock khong bao gio dao
//     -> moi @(negedge clock) trong yapp_if treo mai
//     -> mo phong chay den het thoi gian, 0 goi, khong loi gi.
//
// (2) #(clock_period/2) -- clock_period cung chua ai lai o t=0.
//     'x / 2 = 'x. #('x) la mot delay khong xac dinh.
//     [Suy luan] Toi khong chac Xcelium xu ly #('x) the nao -- co the
//     coi la #0, co the bao warning. Ban tu quan sat o Buoc 1 va ghi lai.
//     Day la mot cau hoi tot de tu tra loi bang thuc nghiem.
//
//------------------------------------------------------------------------------
// HAI NHANH `ifdef LA GI
//------------------------------------------------------------------------------
//
//   IXCOM_1X, IXCOM_UXE  -> cac che do chay tren PALLADIUM (emulator phan
//                           cung cua Cadence).
//
// Nhanh IXCOM_1X cung nhac #10 (chu ky 20ns) vi tren emulator phan cung
// khong the dung bien thoi gian chay (clock_period) lam delay -- phan cung
// khong tong hop duoc "doi mot so bien".
//
// Chay mo phong thuong (xrun khong dinh nghia hai macro nay) -> vao nhanh
// `else, dung ban co clock_period. Day la ban ban se chay.
//
// *** LIEN HE VOI SECTION 10 SLIDE 8 ***
// "Interface must be synthesisable for acceleration."
// Hai nhanh nay la BANG CHUNG SONG cho cau do: cung mot chuc nang, hai
// cach viet, vi mot ben chay bang phan mem, mot ben chay bang phan cung.
//
//------------------------------------------------------------------------------
// CAU HOI
//
// 1. clkgen Lab 6 co port reset. Ban nay KHONG co. Reset gio tu dau ra?
//    (Goi y: xem hw_top HW-5 -- clock_and_reset_if co port reset,
//     va UVC lai no)
//
// 2. Ban Lab 6 dung "initial ... forever". Ban nay dung "always".
//    Co khac nhau ve hanh vi khong? Vi sao ban nay phai dung always?
//    (Goi y: "output logic clock=0" -- gia tri khoi tao o ngay khai bao)
//
// 3. Neu clock_and_reset UVC dat clock_period = 0, chuyen gi xay ra?
//    #(0/2) = #0. Vong always chay bao nhieu lan trong mot buoc thoi gian?
//    => Day la mot cach lam treo mo phong. Thu neu muon thay.
//------------------------------------------------------------------------------
