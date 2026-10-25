//------------------------------------------------------------------------------
// yapp_if.sv   --   LAB 6  (SKELETON)   *** FILE MOI ***
//
// Day la cho PHAN MEM GAP PHAN CUNG.
// Ben tren no: class UVM (driver, monitor).
// Ben duoi no: day that noi vao router RTL.
//
// *** LUU Y QUAN TRONG ***
// File nay KHONG duoc `include vao yapp_pkg.sv.
// No phai duoc liet ke RIENG trong run.f.   (Section 10 slide 5)
//------------------------------------------------------------------------------


// ---- IF-1 -------------------------------------------------------------------
// Khai bao interface.
//
//     interface yapp_if (input clock, input reset);
//
// Cau hoi: vi sao clock va reset la PORT (truyen tu ngoai vao) ma khong phai
//          tin hieu khai ben trong interface?
//          (Goi y: ai tao ra clock? Section 10 slide 10 -- hw_top co clkgen)
// -----------------------------------------------------------------------------

interface yapp_if (input clock, input reset);

// Don vi thoi gian -- CHO SAN, de nguyen.
// Can vi interface co #delay va @edge.
timeunit 1ns;
timeprecision 100ps;

import uvm_pkg::*;
`include "uvm_macros.svh"
import yapp_pkg::*;


  // ---- IF-2 -----------------------------------------------------------------
  // BA tin hieu cua giao thuc YAPP. Tra Section 2 / Section 10 slide 5-6:
  //
  //     logic       in_data_vld;      // bao "dang co du lieu hop le"
  //     logic       in_suspend;       // DUT bao "toi ban, dung gui"
  //     logic [7:0] in_data;          // bus du lieu 8 bit
  //
  // Cau hoi: tin hieu nao do TESTBENCH lai, tin hieu nao do DUT lai?
  //          (Quan trong: cai do DUT lai thi ban chi duoc DOC)
  // ---------------------------------------------------------------------------
	logic [7:0] in_data;
	logic 		in_data_vld;
	logic		in_suspend;


  // ---- IF-3 -----------------------------------------------------------------
  // HAI bit lam "co" cho transaction recording  (Section 10 slide 9):
  //
  //     bit monstart, drvstart;
  //
  // Chung KHONG noi vao DUT. Chung chi de driver/monitor biet
  // "goi vua bat dau len bus" de goi begin_tr() dung thoi diem.
  // ---------------------------------------------------------------------------
	bit monstart, drvstart;


  // ---- IF-4 -----------------------------------------------------------------
  // Bo nho payload cuc bo:
  //
  //     logic [7:0] payload_mem [0:63];
  //
  // *** CAU HOI QUAN TRONG ***
  // yapp_packet da co "rand bit [7:0] payload[]" (mang DONG).
  // Vi sao interface lai can mot mang TINH rieng, va driver phai chep
  // tung phan tu sang?
  //
  // Goi y: Section 10 slide 8 -- "Interface must be synthesisable for
  //        acceleration". Mang dong co tong hop duoc khong?
  // ---------------------------------------------------------------------------
	logic [7:0] payload_mem [0:63];


  //============================================================================
  // TASK 1: yapp_reset  --  CHO SAN, khong phai sua
  //============================================================================
  task yapp_reset();
    @(posedge reset);
    in_data     <= 'hz;
    in_data_vld <= 1'b0;
    disable send_to_dut;      // huy goi dang gui do, neu co
  endtask


  //============================================================================
  // TASK 2: send_to_dut  --  DRIVER goi task nay       *** PHAN KHO NHAT ***
  //============================================================================
  //
  // GIAO THUC YAPP (Section 2):
  //
  //    chu ky 1      : header  = { length[5:0], addr[1:0] }   , in_data_vld = 1
  //    chu ky 2..N+1 : payload byte 0, 1, ..., N-1            , in_data_vld = 1
  //    chu ky N+2    : parity                                 , in_data_vld = 0
  //    sau do        : tha bus ve 'z
  //
  // *** LUAT CANH ***
  //    DRIVER lai o  NEGEDGE clock
  //    MONITOR doc o POSEDGE clock
  //    (nguoc nhau de khong tranh chap -- lai o nua chu ky nay, doc o nua kia)
  //
  // *** LUAT FLOW CONTROL ***
  //    Truoc MOI byte, phai cho den khi DUT khong ban:
  //        @(negedge clock iff (!in_suspend))
  //    Bo "iff" di thi gui de len khi DUT dang ban -> mat du lieu.

  task send_to_dut(input bit [5:0] length,
                         bit [1:0] addr,
                         bit [7:0] payload[],
                         bit [7:0] parity,
                         int       packet_delay);

    // ---- IF-5 ---------------------------------------------------------------
    // (a) Cho packet_delay chu ky truoc khi bat dau.
    //     Day la "knob" ban dat tu Lab 1 -- gio no moi co tac dung that.
    //
    //         repeat(packet_delay)
    //           @(negedge clock);
    //
    //     Chu y: cho KHONG can iff o day, vi chua gui gi ca.
    //
    // (b) Cho den canh am dau tien ma DUT khong ban.
    //
    // (c) Bat co drvstart = 1'b1   (cho begin_tr cua driver)
    //
    // (d) in_data_vld <= 1'b1
    //
    // (e) Dat HEADER len bus:  in_data <= { length, addr };
    //     Chu y thu tu: length 6 bit o TREN, addr 2 bit o DUOI  = 8 bit.
    //     Dung dung thu tu nay thi monitor moi tach nguoc lai duoc.
    // -------------------------------------------------------------------------
	repeat(packet_delay)
		@(negedge clock);

	@(negedge clock iff(!in_suspend));

	drvstart = 1'b1;

	in_data_vld <= 1'b1;

	in_data <= {length, addr};


    // ---- IF-6 ---------------------------------------------------------------
    // Vong lap gui PAYLOAD.
    //
    //     for (int i = 0; i < length; i++) begin
    //       @(negedge clock iff (!in_suspend))
    //       in_data <= payload_mem[i];
    //     end
    //
    // *** HAI CAU HOI ***
    //  (1) Vi sao dung payload_mem[i] chu khong phai payload[i],
    //      trong khi payload LA doi so cua task nay?
    //      (Lien quan IF-4)
    //
    //  (2) Vi sao dieu kien lap la "i < length" chu khong phai
    //      "i < payload.size()"?  Hai cai nay co luon bang nhau khong?
    //      (Goi y: constraint payload_size trong yapp_packet.sv)
    // -------------------------------------------------------------------------
	  for(int i=0; i < length; i++) begin
		@(negedge clock iff(!in_suspend));
		  in_data <= payload_mem[i];
	  end


    // ---- IF-7 ---------------------------------------------------------------
    // Ket thuc goi:
    //
    //  (a) Cho mot canh am nua (co iff)
    //  (b) HA in_data_vld ve 1'b0     <- lam TRUOC/CUNG LUC voi dat parity
    //  (c) Dat parity len in_data
    //
    //     *** VI SAO in_data_vld = 0 O BYTE PARITY? ***
    //     Vi parity KHONG phai du lieu. DUT dung canh xuong cua in_data_vld
    //     de biet "goi het roi, byte nay la parity".
    //     Lam sai -> DUT coi parity la mot byte payload -> goi hong.
    //
    //  (d) Cho them mot canh am, tha bus:  in_data <= 8'bz;
    //  (e) Ha co:  drvstart = 1'b0;
    // -------------------------------------------------------------------------
	@(negedge clock iff(!in_suspend));

	in_data_vld <= 1'b0;
	in_data 	<= parity;
	
	@(negedge clock);
	in_data <= 8'bz;
	drvstart = 1'b0;

  endtask : send_to_dut


  //============================================================================
  // TASK 3: collect_packet  --  MONITOR goi task nay
  //============================================================================
  //
  // Lam NGUOC lai send_to_dut. Chu y doi so la OUTPUT -- task nay
  // DO KET QUA RA cho monitor, giong nhu get() do vif ra cho driver.

  task collect_packet(output bit [5:0] length,
                            bit [1:0] addr,
                            bit [7:0] payload[],
                            bit [7:0] parity);

    // ---- IF-8 ---------------------------------------------------------------
    // (a) Cho den canh DUONG dau tien ma:  khong ban VA co du lieu hop le
    //
    //         @(posedge clock iff (!in_suspend & in_data_vld))
    //
    //     Day la diem bat dau goi. Dung posedge -- NGUOC voi driver.
    //
    // (b) Bat co:  monstart = 1'b1;
    //
    // (c) Tach HEADER:   { length, addr } = in_data;
    //
    //     Chu y: dung "=" (blocking) chu khong phai "<=".
    //     Vi sao? Monitor dang DOC, khong phai lai. Doc thi can gia tri
    //     co ngay de dung o dong sau.
    //
    // (d) Cap phat mang payload theo do dai vua doc:
    //         payload = new[length];
    //
    //     *** DAY LA LY DO monitor dung payload[] mang DONG
    //         con driver dung payload_mem[] mang TINH. ***
    //     Monitor khong biet truoc goi dai bao nhieu -- phai doc header roi
    //     moi cap phat. Driver thi biet truoc.
    // -------------------------------------------------------------------------
	@(posedge clock iff(!in_suspend & in_data_vld))
	monstart = 1'b1;

	`uvm_info("YAPP_IF", "collect packets", UVM_HIGH)

	{length, addr} = in_data;
	payload = new[length];

    // ---- IF-9 ---------------------------------------------------------------
    // (a) Vong lap thu PAYLOAD:
    //
    //         foreach (payload [i]) begin
    //           @(posedge clock iff (!in_suspend))
    //           payload[i] = in_data;
    //         end
    //
    //     Dung foreach duoc vi payload vua duoc new[length] o IF-8.
    //
    // (b) Thu PARITY: cho mot canh duong nua (co iff), gan parity = in_data;
    //
    // (c) Ha co: monstart = 1'b0;
    //
    // *** KHONG tinh parity_type o day. ***
    // Interface chi THU tin hieu tho. Viec so sanh parity dung/sai la
    // viec cua MONITOR (xem MON-5). Interface khong biet gi ve yapp_packet.
    // -------------------------------------------------------------------------
	foreach (payload[i]) begin
		@(posedge clock iff (!in_suspend))
		payload[i] = in_data;
	end

	@(posedge clock iff (!in_suspend))
	  parity = in_data;

	monstart = 1'b0;


  endtask : collect_packet


//==============================================================================
// ASSERTION -- CHO SAN, de nguyen.
// Bat loi "in_suspend ket o 1" -- neu khong co, mo phong se treo im lang
// va ban khong biet vi sao.  (Bay 3c trong README)
//==============================================================================
  property yapp_suspended;
    @(posedge clock) !in_suspend ##1 in_suspend[*20] |=> !in_suspend;
  endproperty

  YAPP_SUSPENDED: assert property (yapp_suspended)
    else begin
      $display("\n**Assertion Error - YAPP interface is suspended: Check channel suspend ports!\n");
      $finish;
    end


endinterface : yapp_if


//==============================================================================
// TU KIEM TRA SAU KHI VIET XONG
//==============================================================================
//
// 1. Dem canh clock cua MOT goi length = 3:
//       1 (header) + 3 (payload) + 1 (parity) = 5 canh am
//    Sau nay xem waveform, dem lai cho khop.
//
// 2. Driver dung canh gi? Monitor dung canh gi? Hai cai co NGUOC nhau khong?
//
// 3. Co bao nhieu cho dung "iff (!in_suspend)"? Dem lai.
//    Moi lan DAT du lieu moi len bus deu phai co. Bo sot mot cho
//    la mat mot byte khi DUT ban.
//
// 4. send_to_dut dung "<=" hay "="?  collect_packet dung cai gi?
//    Vi sao khac nhau?
//
//==============================================================================
