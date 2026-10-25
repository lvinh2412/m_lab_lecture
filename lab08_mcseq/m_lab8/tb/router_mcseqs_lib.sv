//------------------------------------------------------------------------------
// router_mcseqs_lib.sv   --   LAB 8  (SKELETON)   *** FILE MOI ***
//
// MULTICHANNEL SEQUENCE (virtual sequence).
//
// Day la noi kich ban test duoc viet ra. Tu Lab 1 den Lab 7, "kich ban"
// chi la mot dong default_sequence. Gio no la mot ham co thu tu.
//
// Tham khao: Section 12 slide 8 (buoc 2), slide 11, slide 12
//------------------------------------------------------------------------------


// ---- SEQ-1 ------------------------------------------------------------------
// Khai bao class.
//
//     class router_simple_mcseq extends uvm_sequence;
//                                       ^^^^^^^^^^^^
//                                       KHONG CO #(T)
//
// Cung ly do voi [MCS-1]: multichannel sequence KHONG tao transaction nao.
// No chi ra lenh. Khong co kieu nao de dien.
//
// *** HE QUA QUAN TRONG ***
// uvm_sequence #(T) cho ban san bien "req". uvm_sequence tran thi KHONG.
// Nen trong file nay ban se KHONG BAO GIO thay `uvm_do(req).
// Moi thu deu di qua handle cua sequence con.
// -----------------------------------------------------------------------------
class router_simple_mcseq extends uvm_sequence;



// ---- SEQ-2 ------------------------------------------------------------------
//     `uvm_object_utils(router_simple_mcseq)
//
// OBJECT, khong phai component. Hai hau qua:
//   (a) constructor mot doi so:  function new(string name="...")
//   (b) KHONG xuat hien trong print_topology()
//
// No chi hien trong log duoi dang:
//     uvm_test_top.tb.mcsequencer@@router_simple_mcseq
// -----------------------------------------------------------------------------
`uvm_object_utils(router_simple_mcseq)



// ---- SEQ-3 ------------------------------------------------------------------
//     `uvm_declare_p_sequencer(router_mcsequencer)
//
// *** DONG QUAN TRONG NHAT CUA FILE NAY ***
//
// Macro nay no ra thanh:
//     router_mcsequencer p_sequencer;
// cong voi ham m_set_p_sequencer() lam $cast(p_sequencer, m_sequencer).
//
// VI SAO CAN:
// Moi sequence da co san bien m_sequencer, nhung kieu cua no la
// uvm_sequencer_base -- lop CO SO. Lop co so khong biet gi ve yapp_seqr:
//
//     m_sequencer.yapp_seqr      <- LOI BIEN DICH
//     p_sequencer.yapp_seqr      <- OK
//
// Hai bien, MOT doi tuong. Khac nhau chi o KIEU KHAI BAO -- tuc o viec
// compiler cho phep ban go dau cham ra cai gi.
//
// *** p_sequencer LA null CHO TOI KHI SEQUENCE CHAY THAT ***
// Slide 10: "Link is made when the sequence is executed on the sequencer"
// => chi dung p_sequencer trong body(), KHONG dung trong new().
//
// Quen dong nay -> LOI BIEN DICH ("p_sequencer is not declared").
// Day la bay DE NHAT trong Lab 8 -- compiler bat duoc ngay.
// -----------------------------------------------------------------------------
`uvm_declare_p_sequencer(router_mcsequencer)



// ---- SEQ-4 ------------------------------------------------------------------
// HANDLE cho cac sequence cua UVC se duoc goi.
//
// Nam handle. Hai nhom:
//
//   // YAPP
//   six_yapp_seq  six_yapp;
//   yapp_012_seq  yapp_012;
//
//   // HBUS
//   hbus_small_packet_seq      hbus_small_pkt;
//   hbus_read_max_pkt_seq      hbus_rd_maxpkt;
//   hbus_set_default_regs_seq  hbus_large_pkt;
//
// *** DAY CHI LA HANDLE, CHUA CO DOI TUONG ***
// Buoc 1 cua 7 buoc `uvm_do la "create". Macro tu tao doi tuong qua
// factory moi lan goi. Ban khong can new() thu cong.
//
// *** TU KIEM TRA TEN CLASS TRUOC KHI GO ***
// Nam ten tren day toi chep tu repo. Tu xac minh:
//
//     grep -n "class six_yapp_seq\|class yapp_012_seq" ../../yapp/sv/yapp_tx_seqs.sv
//     grep -n "class hbus_small_packet_seq\|class hbus_read_max_pkt_seq\|class hbus_set_default_regs_seq" ../../hbus/sv/hbus_master_seqs.sv
//
// Go sai mot ten -> loi bien dich, de sua.
//
// *** BA SEQUENCE HBUS LAM GI ***
// [Da xac minh] tu hbus_master_seqs.sv:
//
//   hbus_small_packet_seq     -> `uvm_do_with(hbus_seq, {max_pkt_reg==20; enable_reg==1;})
//   hbus_set_default_regs_seq -> `uvm_do_with(hbus_seq, {max_pkt_reg==63; enable_reg==1;})
//   hbus_read_max_pkt_seq     -> doc thanh ghi, LUU vao truong max_pkt_reg cua chinh no
//
// Chu y cai thu ba: no co TRUONG DU LIEU doc duoc sau khi chay xong.
// Do la thu bạn se dung o [SEQ-11].
// -----------------------------------------------------------------------------
six_yapp_seq  six_yapp;
yapp_012_seq  yapp_012;
                                           
// HBUS
hbus_small_packet_seq      hbus_small_pkt;
hbus_read_max_pkt_seq      hbus_rd_maxpkt;
hbus_set_default_regs_seq  hbus_large_pkt;


// ---- SEQ-5 ------------------------------------------------------------------
// Constructor.
//
//     function new(string name="router_simple_mcseq");
//       super.new(name);
//     endfunction
//
// MOT doi so (object), khong phai hai (component).
// -----------------------------------------------------------------------------

	function new(string name="router_simple_mcseq");
		super.new(name);
	endfunction



//==============================================================================
// SEQ-6, SEQ-7 : OBJECTION  --  *** CHO SAN, CHEP Y NGUYEN ***
//==============================================================================
//
// Day la dung mau ban da viet o Lab 5 cho yapp_base_seq, chi doi lop co so.
// Toi cho san de ban tap trung vao phan moi (than ham).
//
// Slide 12 viet "starting_phase" truc tiep -- DEPRECATED tren CDNS-1.2
// cua ban, se ra UVM_WARNING. Ban duoi day dung dung mau tuong thich.

  task pre_body();
    uvm_phase phase;
    `ifdef UVM_VERSION_1_2
      // in UVM1.2, get starting phase from method
      phase = get_starting_phase();
    `else
      phase = starting_phase;
    `endif
    if (phase != null) begin
      phase.raise_objection(this, get_type_name());
      `uvm_info(get_type_name(), "raise objection", UVM_MEDIUM)
    end
  endtask : pre_body

  task post_body();
    uvm_phase phase;
    `ifdef UVM_VERSION_1_2
      phase = get_starting_phase();
    `else
      phase = starting_phase;
    `endif
    if (phase != null) begin
      phase.drop_objection(this, get_type_name());
      `uvm_info(get_type_name(), "drop objection", UVM_MEDIUM)
    end
  endtask : post_body

// *** HAI DIEU PHAI HIEU VE HAI HAM TREN ***
//
// (1) pre_body/post_body CHI CHAY CHO ROOT SEQUENCE  (luat Section 9).
//     router_simple_mcseq duoc start qua default_sequence -> no la ROOT.
//     Moi sequence no goi bang `uvm_do_on deu la SUB -> pre_body cua
//     chung KHONG chay -> chung khong raise objection.
//     => MOT cap raise/drop cho ca kich ban 8 buoc.
//
// (2) Vi sao phai kiem tra "if (phase != null)"?
//     Khi sequence duoc start tu mot test bang seq.start(seqr), phase
//     la null. Khong kiem tra -> null pointer.
//     (Ban da gap truong hop do o seq_from_test cua Lab 6)
//
//==============================================================================




//==============================================================================
// THAN HAM -- viet theo HAI GIAI DOAN
//==============================================================================

  virtual task body();

    // ---- SEQ-8 --------------------------------------------------------------
    // *** GIAI DOAN 1 (buoc 3 trong README): CHI MOT LENH ***
    //
    //     `uvm_info("router_simple_mcseq", "Executing router_simple_mcseq", UVM_LOW)
    //     `uvm_do_on(hbus_small_pkt, p_sequencer.hbus_seqr)
    //
    // Viet dung hai dong nay truoc. Chay. Xac nhan:
    //   - log co dong "Executing router_simple_mcseq"
    //   - log co dong tu hbus_master_seqs.sv
    //   - khong treo
    //
    // *** CU PHAP `uvm_do_on ***
    //
    //     `uvm_do_on( <handle sequence>, <sequencer chay tren do> )
    //                                     `--------+------------'
    //                               LUON LUON la p_sequencer.<ten_seqr>
    //
    // So voi `uvm_do ma ban da dung tu Lab 5:
    //
    //   +---------------------------+---------------------------+
    //   | `uvm_do(seq)              | `uvm_do_on(seq, SQR)      |
    //   +---------------------------+---------------------------+
    //   | 7 buoc day du             | 7 buoc day du -- Y HET    |
    //   | chay tren m_sequencer     | chay tren SQR             |
    //   +---------------------------+---------------------------+
    //
    // Chi khac DUY NHAT buoc 2 (start_item -> wait_for_grant): xin phep
    // sequencer nao.
    //
    // *** NEU VIET NHAM `uvm_do(hbus_small_pkt) ***
    // -> chay tren m_sequencer = mcsequencer -> khong co driver -> TREO.
    // Mo phong chay het thoi gian, 0 goi, khong loi. (bay 2 trong readme)
    // -------------------------------------------------------------------------

	  `uvm_info("router_simple_mcseq", "Executing router_simple_mcseq", UVM_LOW )
	  `uvm_do_on(hbus_small_pkt, p_sequencer.hbus_seqr)



    // ---- SEQ-9 --------------------------------------------------------------
    // *** GIAI DOAN 2 (buoc 6 trong README): day du 8 lenh ***
    //
    // Phan HBUS cau hinh goi nho:
    //
    //   (a) `uvm_do_on(hbus_small_pkt, p_sequencer.hbus_seqr)
    //       -> ghi MAXPKTSIZE = 20, bat router
    //
    //   (b) `uvm_do_on(hbus_rd_maxpkt, p_sequencer.hbus_seqr)
    //       -> doc lai MAXPKTSIZE
    // -------------------------------------------------------------------------
	`uvm_do_on(hbus_small_pkt, p_sequencer.hbus_seqr)
	`uvm_do_on(hbus_rd_maxpkt, p_sequencer.hbus_seqr)



    // ---- SEQ-10 -------------------------------------------------------------
    // *** DONG DAC BIET NHAT CUA CA LAB 8 ***
    //
    //     `uvm_info(get_type_name(),
    //               $sformatf("router MAXPKTSIZE register read: %0h",
    //                         hbus_rd_maxpkt.max_pkt_reg),
    //               UVM_LOW)
    //                           ^^^^^^^^^^^^^^^^^^^^^^^^^^
    //                           DOC TRUONG CUA SEQUENCE VUA CHAY XONG
    //
    // *** HAI DIEU DONG NAY CHUNG MINH ***
    //
    //  (1) DU LIEU CHAY NGUOC
    //      Tu Lab 1 den Lab 7, du lieu chi di MOT CHIEU: test -> DUT.
    //      Dong nay la lan dau: DUT -> hbus_rd_maxpkt.max_pkt_reg -> mcseq.
    //
    //  (2) `uvm_do_on LA BLOCKING
    //      Neu no khong blocking, dong uvm_info nay se chay TRUOC khi
    //      giao dich doc xong -> in ra gia tri cu hoac rac.
    //      Ban se thay gia tri dung -> chung minh macro cho den khi xong.
    //
    // Cau hoi: %0h in ra he 16. Ban ghi 20 (thap phan) o buoc (a).
    //          Log se in ra con so nao? Du doan truoc khi chay.
    // -------------------------------------------------------------------------
	`uvm_info(get_type_name(), $sformatf("router MAXPKTSIZE register read: %0h", hbus_rd_maxpkt.max_pkt_reg), UVM_LOW)
	



    // ---- SEQ-11 -------------------------------------------------------------
    // Phan YAPP: gui goi.
    //
    //     `uvm_do_on(yapp_012, p_sequencer.yapp_seqr)
    //     `uvm_do_on(yapp_012, p_sequencer.yapp_seqr)
    //
    // HAI LAN, cung mot handle.
    //
    // *** CAU HOI QUAN TRONG ***
    // Hai lan do dung CHUNG mot doi tuong hay HAI doi tuong khac nhau?
    // (Goi y: buoc 1 cua 7 buoc `uvm_do la gi? Macro lam gi o buoc do?)
    //
    // Tra loi dung thi ban hieu vi sao khai bao o SEQ-4 chi la "handle"
    // chu khong phai "doi tuong".
    //
    // Moi lan yapp_012_seq gui 3 goi (addr 0, 1, 2) -> tong 6 goi.
    // -------------------------------------------------------------------------
	`uvm_do_on(yapp_012, p_sequencer.yapp_seqr)
	`uvm_do_on(yapp_012, p_sequencer.yapp_seqr)



    // ---- SEQ-12 -------------------------------------------------------------
    // Doi cau hinh roi gui tiep:
    //
    //   (a) `uvm_do_on(hbus_large_pkt, p_sequencer.hbus_seqr)
    //       -> ghi MAXPKTSIZE = 63
    //
    //   (b) `uvm_do_on(hbus_rd_maxpkt, p_sequencer.hbus_seqr)
    //       -> doc lai
    //
    //   (c) lap lai dong `uvm_info cua SEQ-10
    //       -> gia tri PHAI khac lan truoc
    //
    //   (d) `uvm_do_on(six_yapp, p_sequencer.yapp_seqr)
    //       -> 6 goi ngau nhien
    //
    // *** DAY LA LY DO CA LAB 8 TON TAI ***
    // Doan nay the hien dung mot thu khong lam duoc bang default_sequence:
    //
    //     doi cau hinh DUT  ->  roi moi gui goi tiep
    //     `-- HBUS UVC --'      `-- YAPP UVC --'
    //
    // Hai UVC khac nhau, co THU TU giua chung. default_sequence khoi dong
    // tat ca cung luc tai t=0 -- khong co cho nao de dat chu "roi moi".
    // -------------------------------------------------------------------------
	`uvm_do_on(hbus_large_pkt, p_sequencer.hbus_seqr)
	`uvm_do_on(hbus_rd_maxpkt, p_sequencer.hbus_seqr)
	`uvm_info(get_type_name(), $sformatf("router MAXPKTSIZE register read: %0h", hbus_rd_maxpkt.max_pkt_reg), UVM_LOW)
	`uvm_do_on(six_yapp, p_sequencer.yapp_seqr)



  endtask

endclass : router_simple_mcseq


//==============================================================================
// TU KIEM TRA SAU KHI VIET XONG
//==============================================================================
//
// 1. Dem so lenh `uvm_do_on trong body(). Dem so lenh `uvm_do.
//    `uvm_do phai bang 0. Neu khac 0, ban dang dinh bay 2.
//
// 2. Moi lenh `uvm_do_on co doi so thu hai bat dau bang "p_sequencer."
//    khong? Kiem tra tung dong.
//
// 3. Dem goi YAPP se gui:
//       yapp_012 lan 1 = ___
//       yapp_012 lan 2 = ___
//       six_yapp       = ___
//       tong           = ___
//    So sanh voi "grep -c 'Sending Packet' log8.log" sau khi chay.
//
// 4. Co bao nhieu dong `uvm_info in gia tri thanh ghi? Hai gia tri do
//    co phai khac nhau khong? Neu giong nhau thi sai o dau?
//
// 5. File nay se duoc `include SAU router_mcsequencer.sv. Vi sao bat buoc?
//    (Goi y: dong nao trong file nay nhac den ten router_mcsequencer?)
//
//==============================================================================
