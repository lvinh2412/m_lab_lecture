//------------------------------------------------------------------------------
// clkgen.sv   --   LAB 6   *** CHO SAN -- KHONG PHAI VIET ***
//
// Sinh clock va reset cho ca testbench.
// Khong co gi lien quan UVM. Verilog thuan.
//
// [Suy luan] Ban nay toi viet don gian cho Lab 6 (clock tu do chay).
// Tu Lab 7 tro di, repo thay no bang CLOCK_AND_RESET UVC -- luc do
// clock va reset do mot UVC dieu khien, va clkgen nhan them port
// run_clock / clock_period. Lab 6 chua can.
//------------------------------------------------------------------------------

module clkgen (output logic clock,
               output logic reset);

  // Chu ky clock: 10ns (5ns muc cao, 5ns muc thap)
  parameter CLOCK_PERIOD = 10;

  //--------------------------------------------------------------------------
  // Sinh clock -- chay mai
  //--------------------------------------------------------------------------
  initial begin
    clock = 1'b0;
    forever #(CLOCK_PERIOD/2) clock = ~clock;
  end

  //--------------------------------------------------------------------------
  // Sinh reset -- len mot lan roi xuong, giu nguyen den het mo phong
  //
  // Day la ly do driver/monitor viet:
  //     @(posedge vif.reset);     <- cho reset LEN
  //     @(negedge vif.reset);     <- cho reset XUONG
  // Qua duoc hai dong do nghia la "reset da xay ra va da xong".
  //--------------------------------------------------------------------------
  initial begin
    reset = 1'b0;
    #1  reset = 1'b1;        // len
    #50 reset = 1'b0;        // xuong sau 5 chu ky
  end

endmodule : clkgen


//------------------------------------------------------------------------------
// CAU HOI
//
// 1. Neu doi "#1 reset = 1'b1;" thanh "reset = 1'b1;" ngay tu dau
//    (khong co #1), driver cho @(posedge vif.reset) co bao gio thay khong?
//    (Goi y: posedge la mot SU KIEN CHUYEN TIEP 0->1. Neu no da bang 1
//     tu t=0 thi co chuyen tiep nao khong?)
//
// 2. Neu BO HAN khoi reset di (reset khong bao gio len), driver se ket
//    o dong nao? Mo phong se the nao?
//    Du doan truoc, roi thu that bang cach comment khoi do lai.
//------------------------------------------------------------------------------
