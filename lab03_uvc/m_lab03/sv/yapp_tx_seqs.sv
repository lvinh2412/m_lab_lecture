//------------------------------------------------------------------------------
// yapp_tx_seqs.sv   --   LAB 3  (SKELETON)
//
// *** FILE NAY DUOC CHO GAN NHU DAY DU ***
//
// Sequence la noi dung cua SECTION 9, ban chua hoc. Nhung Lab 3 can mot
// sequence de "generate packets and view in the log file" (muc tieu slide 20).
//
// Nen: yapp_base_seq duoc cho SAN -- doc hieu la du, chua can tu viet.
//      yapp_5_packets thi ban dien phan body().
//
// Tham khao:  Section 6 slide 14
//------------------------------------------------------------------------------


//==============================================================================
// yapp_base_seq -- sequence GOC.  CHO SAN, khong phai sua.
//
// Nhiem vu duy nhat cua no: quan ly OBJECTION.
//   - raise_objection  = "khoan ket thuc mo phong, toi dang lam viec"
//   - drop_objection   = "toi xong roi"
// Khong co cai nay, mo phong ket thuc ngay o thoi diem 0 truoc khi
// gói nao kip gui.  Section 9 slide 19-26 giai thich day du.
//
// pre_body()  chay TRUOC body()
// post_body() chay SAU  body()
// -> moi sequence ke thua tu day deu tu dong duoc bao ve, khong phai viet lai.
//==============================================================================

class yapp_base_seq extends uvm_sequence #(yapp_packet);

  `uvm_object_utils(yapp_base_seq)

  function new(string name="yapp_base_seq");
    super.new(name);
  endfunction

  task pre_body();
    uvm_phase phase;
    `ifdef UVM_VERSION_1_2
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

endclass : yapp_base_seq


//==============================================================================
// yapp_5_packets -- gui 5 gói.  BAN DIEN.
//==============================================================================

// ---- SEQS-1 ----------------------------------------------------------------
// Ke thua tu dau?
//   Hai lua chon:  uvm_sequence #(yapp_packet)   hay   yapp_base_seq ?
//   Cau hoi: ban co muon objection tu dong khong?
// ----------------------------------------------------------------------------
class yapp_5_packets extends yapp_base_seq;


  // ---- SEQS-2 --------------------------------------------------------------
  // Macro dang ky.
  //   Sequence la COMPONENT hay OBJECT?   (Section 1 slide 21: nhanh nao?)
  //   -> chon `uvm_object_utils hay `uvm_component_utils ?
  // --------------------------------------------------------------------------
	`uvm_object_utils(yapp_5_packets)


  // ---- SEQS-3 --------------------------------------------------------------
  // Constructor.
  //   May doi so?  Co gia tri mac dinh khong?
  //   (Khac voi component o cho nao?  -- Section 3 slide 11 vs Section 5 slide 6)
  // --------------------------------------------------------------------------
	function new(string name = "yapp_5_packet");
		super.new(name);
	endfunction


  // ---- SEQS-4 --------------------------------------------------------------
  // body() -- noi dinh nghia transaction.  (Section 6 slide 14)
  //
  // Can lam:
  //   (a) in mot dong log bao sequence dang chay, verbosity UVM_LOW
  //   (b) gui 5 gói
  //
  // Cho (b), dung macro:    `uvm_do(req)
  //
  //   `uvm_do lam 4 viec trong mot dong: tao gói, randomize, gui toi
  //   sequencer, cho driver xu ly xong.  Section 9 se mo xe no.
  //
  //   Luu y: `uvm_do KHONG co dau ; o cuoi.
  //   Lap 5 lan: dung  repeat(5)
  //
  // body() la task hay function?  (no phai CHO driver -> ???)
  // --------------------------------------------------------------------------
	task body();
		`uvm_info(get_type_name(), "Executing yapp_5_packets sequence", UVM_LOW)
		repeat (5)
			`uvm_do(req)
	endtask : body



endclass : yapp_5_packets
