//------------------------------------------------------------------------------
// yapp_tx_seqs.sv   --   LAB 5  (SKELETON)
//
// Hai class dau (yapp_base_seq, yapp_5_packets) CHO SAN -- ban da viet o Lab 3.
// Sau do la 6 sequence moi phai tu viet.
//
// *** LUAT CHUNG CHO MOI SEQUENCE TRONG FILE NAY ***
//   1. extends yapp_base_seq   (KHONG phai uvm_sequence)  <- Section 9 slide 24
//   2. `uvm_object_utils(<ten class>)                     <- Section 9 slide 7
//   3. constructor co gia tri mac dinh cho name           <- Section 1 slide 26
//   4. virtual task body()
//   5. dong `uvm_info dau body() de nhin thay trong log
//------------------------------------------------------------------------------


//==============================================================================
// yapp_base_seq -- CHO SAN. Khong sua.
// Day la noi xu ly objection cho MOI sequence ke thua no.
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
// yapp_5_packets -- CHO SAN (Lab 3). Khong sua.
// Dung lam MAU cho cac sequence ben duoi.
//==============================================================================

class yapp_5_packets extends yapp_base_seq;

  `uvm_object_utils(yapp_5_packets)

  function new(string name="yapp_5_packets");
    super.new(name);
  endfunction

  virtual task body();
    `uvm_info(get_type_name(), "Executing yapp_5_packets sequence", UVM_LOW)
    repeat(5)
      `uvm_do(req)
  endtask

endclass : yapp_5_packets



//==============================================================================
// (1) yapp_012_seq  --  DIRECTED
//     Gui 3 goi random toi channel 0, roi 1, roi 2 -- DUNG THU TU DO.
//==============================================================================

// ---- SEQ-1 ------------------------------------------------------------------
// Khai bao class + macro + constructor.
// Theo dung 5 luat o dau file. Chep khuon tu yapp_5_packets.
// -----------------------------------------------------------------------------
class yapp_012_seq extends yapp_base_seq;
	`uvm_object_utils(yapp_012_seq)

	function new(string name = "yapp_012_seq");
		super.new(name);
	endfunction : new


  // ---- SEQ-2 ----------------------------------------------------------------
  // Dong `uvm_info dau body().  Dung UVM_LOW de luon nhin thay.
  // ---------------------------------------------------------------------------
	virtual task body();
	`uvm_info(get_type_name(), "Executing YAPP_012_SEQ", UVM_LOW)

  // ---- SEQ-3 ----------------------------------------------------------------
  // Ba dong gui goi, moi dong rang buoc addr mot gia tri.
  //
  // Dung macro nao?  (Section 9 slide 7, 11)
  //    `uvm_do          -> random hoan toan, KHONG dat duoc addr
  //    `uvm_do_with     -> random + rang buoc inline      <- dung cai nay
  //
  // Cu phap:   `uvm_do_with( req, { <rang buoc>; } )
  //
  // Cau hoi: viet  {addr == 0;}  hay  {req.addr == 0;}  ?
  //          Thu ca hai, xem cai nao bien dich duoc.
  //          (Repo dung mot trong hai -- tu tim ra la cai nao)
  // ---------------------------------------------------------------------------
		`uvm_do_with( req, {req.addr == 2'b00;} )
		`uvm_do_with( req, {req.addr == 2'b01;} )
		`uvm_do_with( req, {req.addr == 2'b10;} )

	endtask
endclass : yapp_012_seq


// TU KIEM TRA [SEQ-1..3]: chay rieng sequence nay, phai ra DUNG 3 goi,
//                         addr lan luot 0, 1, 2.



//==============================================================================
// (2) yapp_1_seq  --  DIRECTED
//     Gui MOT goi random toi channel 1.
//     Sequence nho nhat cua lab -- nhung se duoc dung lai o (3) va (6).
//==============================================================================

// ---- SEQ-4 ------------------------------------------------------------------
// Khai bao class + macro + constructor.
// -----------------------------------------------------------------------------
class yapp_1_seq extends yapp_base_seq;
	`uvm_object_utils(yapp_1_seq)

	function new(string name = "yapp_1_seq");
		super.new(name);
	endfunction : new


  // ---- SEQ-5 ----------------------------------------------------------------
  // body(): mot dong `uvm_info + MOT dong gui goi toi addr 1.
  // ---------------------------------------------------------------------------
	virtual task body();
		`uvm_info(get_type_name(), "Executing YAPP_1_SEQ", UVM_LOW)
		`uvm_do_with( req, {req.addr == 2'b01;} )
	endtask
endclass : yapp_1_seq


//==============================================================================
// (3) yapp_111_seq  --  NESTED
//     Gui 3 goi toi channel 1, bang cach GOI LAI yapp_1_seq ba lan.
//     KHONG duoc viet `uvm_do_with ba lan -- phai LONG sequence.
//==============================================================================


// ---- SEQ-6 ------------------------------------------------------------------
// Khai bao class + macro + constructor.
// -----------------------------------------------------------------------------
class yapp_111_seq extends yapp_base_seq;
	`uvm_object_utils(yapp_111_seq)
	
	function new(string name = "yapp_111_seq");
		super.new(name);
	endfunction

  // ---- SEQ-7 ----------------------------------------------------------------
  // HANDLE toi sequence con.
  //
  //     <kieu>  <ten_bien>;
  //
  // Chu y chu thich Section 9 slide 14: "Choose meaningful name for debug!"
  // Ten bien nay se hien trong log -- dat ten noi len y nghia.
  // ---------------------------------------------------------------------------
	yapp_1_seq addr_1_seq;


  // ---- SEQ-8 ----------------------------------------------------------------
  // body(): `uvm_info + lap 3 lan goi sequence con.
  //
  //     repeat (3)
  //       `uvm_do( <ten_bien_o_SEQ-7> )
  //
  // *** DIEM QUAN TRONG ***
  // Cung macro `uvm_do, nhung lan nay doi so la mot SEQUENCE chu khong phai
  // mot PACKET. Buoc 6 cua bang slide 9 xu ly khac:
  //     - packet   -> gui toi sequencer, cho item_done
  //     - sequence -> chay body() cua no
  // Ban khong phai lam gi them. Macro tu nhin kieu.
  //
  // Cau hoi: yapp_1_seq khi chay o day la ROOT hay SUBSEQUENCE?
  //          pre_body() cua no co chay khong?
  // ---------------------------------------------------------------------------
	virtual task body();
		`uvm_info(get_type_name(), "Executing YAPP_111_SEQ", UVM_LOW)
		repeat(3)
			`uvm_do(addr_1_seq)
	endtask


endclass : yapp_111_seq


//==============================================================================
// (4) yapp_repeat_addr_seq  --  PROPERTY-CONTROLLED     *** PHAN KHO ***
//     Gui 2 goi toi CUNG MOT channel, nhung channel nao thi RANDOM.
//
//  >>> LAM DUNG THU TU SEQ-9 -> 10 -> 11 -> 12.  SEQ-11 LA DE BAN GAP LOI. <<<
//==============================================================================

// ---- SEQ-9 ------------------------------------------------------------------
// Khai bao class + macro + constructor.
// -----------------------------------------------------------------------------
class yapp_repeat_addr_seq extends yapp_base_seq;

	`uvm_object_utils(yapp_repeat_addr_seq)

	function new(string name = "yapp_repeat_addr_seq");
		super.new(name);
	endfunction : new

  // ---- SEQ-10 ---------------------------------------------------------------
  // (a) Khai mot PROPERTY cua sequence:
  //
  //         rand bit [1:0] seqaddr;
  //
  //     Day la bien cua SEQUENCE, khong phai cua packet.
  //     No duoc randomize MOT LAN moi khi sequence chay.  (slide 13)
  //
  // (b) body(): `uvm_info + lap 2 lan gui goi, ca hai cung dung seqaddr:
  //
  //         repeat (2)
  //           `uvm_do_with(req, { ... == seqaddr; })
  //
  // *** CHUA THEM CONSTRAINT NAO CHO seqaddr. Co y nhu vay. ***
  // ---------------------------------------------------------------------------
	rand bit [1:0] seqaddr;
	constraint legal_addr {seqaddr != 3;}

	virtual task body();
		`uvm_info(get_type_name(), "Executing YAPP_REPEAT_ADDR_SEQ", UVM_LOW)
		repeat(2)
			`uvm_do_with(req, {req.addr == seqaddr;})
	endtask


endclass : yapp_repeat_addr_seq


// ---- SEQ-11 -----------------------------------------------------------------
// DUNG VIET CODE. CHAY THU.
//
//   1. Them sequence nay vao run.f / test (hoac tam dat lam default_sequence)
//   2. Chay NHIEU LAN voi seed khac nhau:
//
//        for i in 1 2 3 4 5 6 7 8; do
//          xrun -f run.f +UVM_TESTNAME=<test cua ban> +SVSEED=random \
//               -l log_$i.log
//        done
//        grep -c "UVM_WARNING" log_*.log
//
//   3. Mot so lan chay se co UVM_WARNING. Mot so lan KHONG.
//
// CAU HOI PHAI TRA LOI TRUOC KHI SANG SEQ-12:
//   a) Vi sao chi THINH THOANG moi loi, khong phai lan nao cung loi?
//   b) seqaddr la bit[1:0] -- no nhan duoc nhung gia tri nao?
//   c) Mo lai sv/yapp_packet.sv. Constraint "default_addr" noi gi ve addr?
//   d) Khi seqaddr nhan gia tri NAO thi hai constraint mau thuan nhau?
//   e) Luc mau thuan, goi gui di co length bang bao nhieu? Vi sao?
//      (Goi y: randomize() that bai -> cac bien rand GIU NGUYEN gia tri cu;
//       ma `uvm_create vua tao object moi -> moi field = 0)
//
// Ghi cau tra loi ra giay roi moi lam SEQ-12.
// -----------------------------------------------------------------------------


  // ---- SEQ-12 ---------------------------------------------------------------
  // Gio sua. Them MOT constraint cho seqaddr de mau thuan khong the xay ra.
  //
  //     constraint <ten> { ... }
  //
  // Dat ten constraint sao cho doc vao hieu ngay y do.
  //
  // Chay lai 8 lan nhu SEQ-11. Gio phai 0 WARNING o moi lan.
  // ---------------------------------------------------------------------------



//==============================================================================
// (5) yapp_incr_payload_seq  --  DIRECTED (payload)     *** PHAN KHO ***
//     Gui MOT goi, payload la day tang dan: 0, 1, 2, 3, ...
//     Moi thu khac (length, addr, delay, parity_type) van RANDOM.
//
//     Day la khuon "semi-directed" cua Section 9 slide 12.
//==============================================================================

// ---- SEQ-13 -----------------------------------------------------------------
// Khai bao class + macro + constructor.
// -----------------------------------------------------------------------------
class yapp_incr_payload_seq extends yapp_base_seq;
	`uvm_object_utils(yapp_incr_payload_seq)

	function new(string name = "yapp_incr_payload_seq");
		super.new(name);
	endfunction : new


  // ---- SEQ-14 ---------------------------------------------------------------
  // body() -- buoc 1 va 2 cua khuon slide 12.
  //
  //   (a) Tao goi, CHUA randomize:
  //           `uvm_create(req)
  //       (macro nay chi lam buoc 1 trong 7 buoc -- slide 11)
  //
  //   (b) Randomize de co MOT GOI HOP LE hoan chinh:
  //           ??? req.randomize() ???
  //
  //       *** DAY LA CHO BAN PHAI CHON ***
  //       Ba cach viet:
  //           req.randomize();                  <- vut ket qua, co the bi warning
  //           ok = req.randomize();             <- nuot ket qua, KHONG kiem tra
  //           assert(req.randomize());          <- kiem tra that su
  //
  //       Slide 12 dung cach 2. Ban UVC chuan cua khoa hoc dung cach 3.
  //       Chon mot, va viet ra giay VI SAO ban chon cai do.
  // ---------------------------------------------------------------------------
	virtual task body();
		int ok;
		`uvm_info(get_type_name(), "Executing YAPP_INCR_PAYLOAD_SEQ", UVM_LOW)
		`uvm_create(req);

		ok = req.randomize();

  // ---- SEQ-15 ---------------------------------------------------------------
  // body() -- buoc 3 va 4 cua khuon.
  //
  //   (c) GHI DE payload thanh day tang dan.
  //       Vong lap chay bao nhieu lan?  (Goi y: payload.size() vua duoc
  //       randomize khop voi length -- constraint payload_size cua packet)
  //
  //       Hai cach viet, chon mot:
  //           foreach (req.payload[i])  req.payload[i] = i;
  //           for (int i=0; i<req.length; i++)  req.payload[i] = i;
  //
  //   (d) Tinh lai parity:
  //           req.set_parity();
  //
  //       *** VI SAO PHAI GOI DONG NAY? ***
  //       Mo yapp_packet.sv, doc calc_parity(). Parity phu thuoc vao gi?
  //       post_randomize() da goi set_parity() roi -- nhung LUC NAO?
  //       Ban vua doi payload SAU do. Hau qua?
  // ---------------------------------------------------------------------------
	foreach(req.payload [i])
		req.payload[i] = i;
	req.set_parity();


  // ---- SEQ-16 ---------------------------------------------------------------
  // body() -- buoc 5, gui goi di.
  //
  //   Dung macro nao?  Doc ky bang slide 11:
  //       `uvm_send            buoc 2-7, BO QUA buoc 4 (randomization)
  //       `uvm_rand_send       buoc 2-7, CO randomization
  //
  //   Neu chon nham, chuyen gi xay ra voi payload ban vua gan o SEQ-15?
  //   Tra loi truoc, roi viet.
  // ---------------------------------------------------------------------------
	`uvm_send(req);

	endtask

endclass : yapp_incr_payload_seq


//==============================================================================
// (6) yapp_exhaustive_seq  --  NESTED nhieu tang
//     Chay LAN LUOT tat ca 5 sequence ban vua viet.
//==============================================================================

// ---- SEQ-17 -----------------------------------------------------------------
// Khai bao class + macro + constructor.
// -----------------------------------------------------------------------------
class yapp_exhaustive_seq extends yapp_base_seq;
	`uvm_object_utils(yapp_exhaustive_seq);
	function new(string name = "yapp_exhaustive_seq");
		super.new(name);
	endfunction : new


  // ---- SEQ-18 ---------------------------------------------------------------
  // Khai 5 HANDLE, moi handle cho mot sequence o tren:
  //     yapp_012_seq, yapp_1_seq, yapp_111_seq,
  //     yapp_repeat_addr_seq, yapp_incr_payload_seq
  // ---------------------------------------------------------------------------
	  yapp_012_seq y012;
	  yapp_1_seq y1; 
	  yapp_111_seq y111;
	  yapp_repeat_addr_seq yaddr;
	  yapp_incr_payload_seq yinc;


  // ---- SEQ-19 ---------------------------------------------------------------
  // body(): `uvm_info + 5 dong `uvm_do, moi dong mot handle.
  //
  // TRUOC KHI CHAY, du doan:
  //   a) Tong cong bao nhieu goi duoc gui?  (cong tung sequence lai)
  //   b) Chay voi +UVM_VERBOSITY=UVM_MEDIUM roi  grep -i objection
  //      -> se thay BAO NHIEU dong "raise objection"?
  //         Du doan truoc roi moi chay.  (Section 9 slide 23-24)
  //   c) yapp_111_seq long yapp_1_seq ben trong -> co 3 TANG sequence.
  //      Tang 3 co raise objection khong?
  // ---------------------------------------------------------------------------
	virtual task body();
		`uvm_info(get_type_name(), "Executing YAPP_EXHAUSTIVE_SEQ", UVM_LOW)
		    `uvm_do(y012)
		    `uvm_do(y1)
		    `uvm_do(y111)
		    `uvm_do(yaddr)
		    `uvm_do(yinc)
	endtask


endclass : yapp_exhaustive_seq


//==============================================================================
// TU KIEM TRA SAU KHI VIET XONG CA FILE
//==============================================================================
//
// 1. Dem lai: ca 6 class moi co extends yapp_base_seq khong?
//        grep -n "^class" yapp_tx_seqs.sv
//    Neu co cai nao "extends uvm_sequence" (ngoai yapp_base_seq) -> SAI.
//
// 2. Ca 6 class co `uvm_object_utils khong? (khong phai uvm_component_utils)
//
// 3. Constructor cua ca 6 co gia tri mac dinh cho name khong?
//
// 4. Thu nghiem: tam doi yapp_1_seq thanh "extends uvm_sequence #(yapp_packet)"
//    roi dat no lam default_sequence. Du doan ket qua truoc khi chay.
//    (Nho tra lai sau khi thu.)
//
//==============================================================================
