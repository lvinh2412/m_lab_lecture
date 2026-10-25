//------------------------------------------------------------------------------
// router_reference.sv   --   LAB 9B  (SKELETON)   *** FILE MOI ***
//
// REFERENCE MODEL -- chuc nang (1) trong ba chuc nang cua slide 5:
//     "Transfer function (reference model)"
//
// Voi YAPP router, ham bien doi gan nhu khong lam gi (router khong doi
// du lieu, chi dinh tuyen). Nen cong viec that cua class nay la:
//
//     THEO DOI THANH GHI  +  LOC GOI
//
// No la mot BO LOC dung GIUA monitor va scoreboard.
//
// Tham khao: Section 13 slide 4, 5, 7, 16
//------------------------------------------------------------------------------


// ---- REF-1 ------------------------------------------------------------------
//     class router_reference extends uvm_component;
//
// Chu y: extends uvm_component, KHONG PHAI uvm_scoreboard.
// No khong so sanh gi ca -- no loc. Dat dung ten lop co so la mot
// cach ghi lai y dinh thiet ke.
// -----------------------------------------------------------------------------
class router_reference extends uvm_component;



// ---- REF-2 ------------------------------------------------------------------
// HAI macro imp_decl.
//
//     `uvm_analysis_imp_decl(_hbus)
//     `uvm_analysis_imp_decl(_yapp)
//
// *** DAY LA CAU TRA LOI CHO CAU HOI "_hbus O DAU" ***
// Lab 9A: scoreboard co 4 imp (_yapp, _chan0/1/2), khong co _hbus.
// Lab 9B: _hbus o DAY, trong reference.
//
// Dem toan he: 2 (reference) + 4 (scoreboard) = 6 imp.
//
// Vi sao _hbus thuoc ve reference chu khong phai scoreboard?
// Vi chi reference moi can biet router dang cau hinh the nao.
// Scoreboard chi can biet "goi nay co khop goi kia khong".
// -----------------------------------------------------------------------------
`uvm_analysis_imp_decl(_hbus)
`uvm_analysis_imp_decl(_yapp)



// ---- REF-3 ------------------------------------------------------------------
// HAI doi tuong imp -- dau VAO.
//
//     uvm_analysis_imp_hbus #(hbus_transaction, router_reference) hbus_in;
//     uvm_analysis_imp_yapp #(yapp_packet,      router_reference) yapp_in;
//
// Hai kieu transaction KHAC NHAU: hbus_transaction va yapp_packet.
// Day la ly do phai dung macro imp_decl (slide 14: "Only one
// uvm_analysis_imp object can be declared in a component").
// -----------------------------------------------------------------------------
	uvm_analysis_imp_hbus #(hbus_transaction, router_reference) hbus_in;
	uvm_analysis_imp_yapp #(yapp_packet,      router_reference) yapp_in;



// ---- REF-4 ------------------------------------------------------------------
// MOT doi tuong port -- dau RA.   *** DIEM KHAC BIET LON NHAT ***
//
//     uvm_analysis_port #(yapp_packet) sb_add_out;
//
// *** PORT, KHONG PHAI IMP ***
//
// Slide 11:
//     imp  -> "Used inside TARGET components. PROVIDES an implementation"
//     port -> "Used inside INITIATOR components. PROVIDES ACCESS TO
//              an implementation"
//
// reference vua la TARGET (nhan tu monitor) vua la INITIATOR (gui sang
// scoreboard). Nen no co CA HAI loai:
//
//     monitor  --[ ]--> (O) reference (O) --[ ]--> scoreboard
//                        ^^^           ^^^
//                        imp (nhan)    port (phat)
//
// Day la component dau tien trong ca khoa hoc dong ca hai vai.
//
// *** CHU Y KIEU: yapp_packet ***
// No chuyen tiep goi YAPP, khong phai goi channel. Scoreboard se nhan
// no bang sb_yapp_in (kieu yapp_packet) -- khop.
// -----------------------------------------------------------------------------
	uvm_analysis_port #(yapp_packet) sb_add_out;



// ---- REF-5 ------------------------------------------------------------------
// HAI thanh ghi -- ban sao cua thanh ghi trong DUT.
//
//     bit [7:0] max_pktsize_reg   = 8'h3F;
//     bit [7:0] router_enable_reg = 1'b1;
//
// *** GIA TRI KHOI TAO QUAN TRONG ***
//
//     8'h3F = 63 = goi dai nhat ma yapp_packet cho phep
//     1'b1  = router BAT
//
// Day phai la gia tri cua thanh ghi trong DUT SAU RESET. Neu dat sai,
// reference se loc sai trong khoang thoi gian truoc khi co giao dich
// HBUS dau tien.
//
// *** CAU HOI PHAI TU TRA LOI ***
// Lam sao biet gia tri reset that cua router la gi?
//    grep -n "max_pktsize\|MAXPKTSIZE\|router_en" ../../router_rtl/yapp_router.sv
// Doi chieu. Neu RTL reset ve gia tri khac, sua hai dong tren.
//
// [Chua xac minh] Toi chua doc yapp_router.sv nen khong biet gia tri
// reset that. Hai so tren toi chep tu repo.
//
// *** DIA CHI THANH GHI ***
// [Da xac minh] hbus_if.sv giai ma dung hai dia chi:
//     16'h1000 -> max_pktsize_reg
//     16'h1001 -> router_enable_reg
// -----------------------------------------------------------------------------
	bit [7:0] max_pktsize_reg   = 8'h3F;
	bit [7:0] router_enable_reg = 1'b1;



// ---- REF-6 ------------------------------------------------------------------
// BON bo dem thong ke.
//
//     int packets_dropped   = 0;
//     int packets_forwarded = 0;
//     int jumbo_packets     = 0;
//     int bad_addr_packets  = 0;
//
// Y nghia:
//     packets_forwarded : goi da gui sang scoreboard
//     packets_dropped   : TONG so goi bi loc (ca ba ly do)
//     jumbo_packets     : rieng ly do "qua dai"
//     bad_addr_packets  : rieng ly do "addr == 3"
//
// Chu y: packets_dropped la TONG, hai cai kia la CHI TIET. Nen
//     packets_dropped >= jumbo_packets + bad_addr_packets
// (ly do thu ba -- router tat -- khong co bo dem rieng)
//
// *** CAU HOI THIET KE ***
// Co nen them bo dem "disabled_packets" cho du bo khong?
// [Da xac minh] lab09_sbd (ban FIFO) CO bo dem do:
//     int disabled_packets = 0;
// Ban co the them vao. Repo ban 9B thi khong.
//
// *** BO DEM QUAN TRONG NHAT: packets_forwarded ***
// No PHAI bang scoreboard.packets_in. Day la phep kiem tra cheo cua
// Lab 9B -- xem PHAN 6 cua README.
// -----------------------------------------------------------------------------
int packets_dropped   = 0;
   int packets_forwarded = 0;
   int jumbo_packets     = 0;
   int bad_addr_packets  = 0;



// ---- REF-7 ------------------------------------------------------------------
// Macro dang ky + constructor.
//
//     `uvm_component_utils(router_reference)
//
//     function new (string name = "", uvm_component parent = null);
//       super.new(name, parent);
//       // TLM Connections to Interface UVCs
//       hbus_in    = new("hbus_in",    this);
//       yapp_in    = new("yapp_in",    this);
//       // TLM Connections to the Scoreboard
//       sb_add_out = new("sb_add_out", this);
//     endfunction: new
//
// BA doi tuong TLM, ca ba tao trong constructor bang new(), khong phai
// type_id::create(). Port/imp khong di qua factory.
//
// *** VE HAI GIA TRI MAC DINH name="" va parent=null ***
// Repo viet vay. Chung gan nhu chac chan khong bao gio duoc dung, vi
// factory luon truyen du hai doi so. Ban co the bo di:
//     function new(string name, uvm_component parent);
// -> compiler se bat loi neu ban quen "this" luc create.
// (Da ban ky o cau hoi truoc cua ban)
// -----------------------------------------------------------------------------
`uvm_component_utils(router_reference)
  
   function new (string name = "", uvm_component parent = null);
     super.new(name, parent);
     // TLM Connections to Interface UVCs
     hbus_in  = new("hbus_in",  this);
     yapp_in  = new("yapp_in",  this);
     // TLM Connections to the Scoreboard
     sb_add_out    = new("sb_add_out", this);
   endfunction: new 




// ---- REF-8 ------------------------------------------------------------------
// write_hbus  --  THEO DOI THANH GHI
//
// Slide 16: "HBUS write updates reference model enable and maxpktsize
//            registers."
//
//   function void write_hbus(hbus_transaction hbus_cmd);
//     `uvm_info(get_type_name(),
//       $sformatf("Received HBUS Transaction: \n%s", hbus_cmd.sprint()), UVM_MEDIUM)
//     // For now - capture the max_pktsize_reg and router_enable_reg
//     // values whenever a hbus transaction is written
//     if (hbus_cmd.hwr_rd == HBUS_WRITE)
//       case (hbus_cmd.haddr)
//         'h1000 : max_pktsize_reg   = hbus_cmd.hdata;
//         'h1001 : router_enable_reg = hbus_cmd.hdata;
//       endcase
//   endfunction
//
//=============================================================================
// *** DIEU KIEN "if (hbus_cmd.hwr_rd == HBUS_WRITE)" LA BAT BUOC ***
//=============================================================================
//
// Chi phan ung voi lenh GHI. Lenh DOC bi bo qua -- dung, vi doc khong
// lam doi thanh ghi.
//
// Bo dieu kien do di: router_simple_mcseq co HAI lenh doc MAXPKTSIZE.
// Luc doc, truong hdata chua gia tri DOC VE -- tinh co van dung.
// Nhung neu ai do doc mot dia chi khac thi thanh ghi bi ghi de bay ba.
//
// *** NHANH default KHONG CO ***
// case khong co default -> dia chi khac 0x1000/0x1001 thi khong lam gi.
// Dung: router chi co hai thanh ghi do.
// Co nen them default de canh bao dia chi la khong? Thu nghiem di.
//
// *** hbus_read_write_enum ***
// HBUS_WRITE va HBUS_READ la enum khai trong hbus_pkg. Day la ly do
// router_module_pkg.sv phai "import hbus_pkg::*" ([PKG-2]).
// -----------------------------------------------------------------------------
function void write_hbus(hbus_transaction hbus_cmd);
    `uvm_info(get_type_name(),
      $sformatf("Received HBUS Transaction: \n%s", hbus_cmd.sprint()), UVM_MEDIUM)
    // For now - capture the max_pktsize_reg and router_enable_reg
    // values whenever a hbus transaction is written
    if (hbus_cmd.hwr_rd == HBUS_WRITE)
      case (hbus_cmd.haddr)
        'h1000 : max_pktsize_reg = hbus_cmd.hdata;
        'h1001 : router_enable_reg = hbus_cmd.hdata;
      endcase
  endfunction




//==============================================================================
// write_yapp  --  BO LOC   *** HAM TRUNG TAM CUA LAB 9B ***
//
// Viet theo HAI giai doan: [REF-9] truoc (Buoc 1), roi [REF-10..11]
// (Buoc 5).
//==============================================================================

    // ---- REF-9 --------------------------------------------------------------
    // *** GIAI DOAN 1 (Buoc 1): CHUA LOC GI ***
    //
    //   function void write_yapp(yapp_packet packet);
    //     `uvm_info(get_type_name(),
    //       $sformatf("Received Input YAPP Packet: \n%s", packet.sprint()), UVM_LOW)
    //
    //     sb_add_out.write(packet);          // chuyen tiep MOI goi
    //     packets_forwarded++;
    //     `uvm_info(get_type_name(), "Sent YAPP Packet to Scoreboard", UVM_LOW)
    //   endfunction
    //
    // Ban nay hanh xu Y HET Lab 9A -- moi goi deu vao scoreboard.
    // Muc dich: xac nhan DAY NOI dung truoc, roi moi them logic.
    //
    // Chay o Buoc 4 va kiem:
    //     reference.packets_forwarded == scoreboard.packets_in
    // Hai so bang nhau -> day noi dung -> sang Buoc 5.
    // -------------------------------------------------------------------------
function void write_yapp(yapp_packet packet);
    `uvm_info(get_type_name(),
      $sformatf("Received Input YAPP Packet: \n%s", packet.sprint()), UVM_LOW)
    
    // Check if router is enabled and  packet has "valid size" before 
    // sending to scoreboard
    if (packet.addr == 3) begin
      bad_addr_packets++;
      packets_dropped++;
      `uvm_info(get_type_name(), "YAPP Packet Dropped [BAD ADDRESS]", UVM_LOW)
    end
    else if ((router_enable_reg != 0) && (packet.length <= max_pktsize_reg)) begin
      // Send packet to Scoreboard via TLM port
      sb_add_out.write(packet);
      packets_forwarded++;
      `uvm_info(get_type_name(), "Sent YAPP Packet to Scoreboard", UVM_LOW)
    end
    else if ((router_enable_reg != 0) && (packet.length > max_pktsize_reg)) begin
      jumbo_packets++;
      packets_dropped++;
      `uvm_info(get_type_name(), $sformatf("YAPP Packet Dropped [OVERSIZED] - pkt size %h max size %h",packet.length, max_pktsize_reg), UVM_LOW)
    end
    else if (router_enable_reg == 0) begin
      packets_dropped++;
      `uvm_info(get_type_name(), "YAPP Packet Dropped [DISABLED]", UVM_LOW)
    end

  endfunction




    // ---- REF-10 -------------------------------------------------------------
    // *** GIAI DOAN 2 (Buoc 5): BON NHANH LOC ***
    //
    // Khung day du:
    //
    //   function void write_yapp(yapp_packet packet);
    //     `uvm_info(get_type_name(),
    //       $sformatf("Received Input YAPP Packet: \n%s", packet.sprint()), UVM_LOW)
    //
    //     // Check if router is enabled and packet has "valid size" before
    //     // sending to scoreboard
    //     if (packet.addr == 3) begin
    //       bad_addr_packets++;
    //       packets_dropped++;
    //       `uvm_info(get_type_name(), "YAPP Packet Dropped [BAD ADDRESS]", UVM_LOW)
    //     end
    //     else if ((router_enable_reg != 0) && (packet.length <= max_pktsize_reg)) begin
    //       // Send packet to Scoreboard via TLM port
    //       sb_add_out.write(packet);
    //       packets_forwarded++;
    //       `uvm_info(get_type_name(), "Sent YAPP Packet to Scoreboard", UVM_LOW)
    //     end
    //     else if ((router_enable_reg != 0) && (packet.length > max_pktsize_reg)) begin
    //       jumbo_packets++;
    //       packets_dropped++;
    //       `uvm_info(get_type_name(), $sformatf("YAPP Packet Dropped [OVERSIZED] - pkt size %h max size %h",
    //                 packet.length, max_pktsize_reg), UVM_LOW)
    //     end
    //     else if (router_enable_reg == 0) begin
    //       packets_dropped++;
    //       `uvm_info(get_type_name(), "YAPP Packet Dropped [DISABLED]", UVM_LOW)
    //     end
    //   endfunction
    //
    //=========================================================================
    // *** BON NHANH, BA LY DO DROP ***
    //=========================================================================
    //
    //   +----------------------------+--------------------+-------------------+
    //   | dieu kien                  | nhan trong log     | bo dem            |
    //   +----------------------------+--------------------+-------------------+
    //   | addr == 3                  | [BAD ADDRESS]      | bad_addr_packets  |
    //   | bat & length <= max        | "Sent ... to SB"   | packets_forwarded |
    //   | bat & length > max         | [OVERSIZED]        | jumbo_packets     |
    //   | tat                        | [DISABLED]         | (chi dropped)     |
    //   +----------------------------+--------------------+-------------------+
    //
    // *** THU TU BON NHANH QUAN TRONG ***
    //
    // addr == 3 kiem TRUOC TIEN, truoc ca enable va length.
    // Vi sao? Goi co addr sai thi router khong biet gui di dau, bat ke
    // no bat hay tat, bat ke dai hay ngan.
    //
    // *** DIEU KIEN "router_enable_reg != 0" LAP LAI HAI LAN ***
    // Nhanh 2 va nhanh 3 deu co no. Nhin thua, nhung no tach duoc hai
    // truong hop:
    //     bat + ngan -> forward
    //     bat + dai  -> OVERSIZED
    // Nhanh 4 (tat) gom moi truong hop con lai.
    //
    // *** BAI TAP: VE BANG CHAN LY ***
    // Ba bien: addr==3? / enable? / length>max?  -> 8 to hop.
    // Dien bon nhanh vao bang 8 dong.
    // Co to hop nao KHONG roi vao nhanh nao khong?
    // Co to hop nao roi vao HAI nhanh khong?
    // (if/else if nen chi vao nhanh dau tien khop -- nhung ban van nen
    //  kiem de hieu logic)
    // -------------------------------------------------------------------------




    // ---- REF-11 -------------------------------------------------------------
    // report_phase -- BANG THONG KE RIENG CUA REFERENCE
    //
    //   function void report_phase(uvm_phase phase);
    //     `uvm_info(get_type_name(), $sformatf(
    //       "Report:\n   Router Reference: Packet Statistics \n     Packets Dropped:   %0d\n     Packets Forwarded: %0d\n     Oversized Packets: %0d\n",
    //       packets_dropped, packets_forwarded, jumbo_packets ), UVM_LOW)
    //   endfunction : report_phase
    //
    // *** GIO LOG CO HAI BANG THONG KE ***
    //
    //     Router Reference: Packet Statistics     <- bao nhieu goi bi loc, vi sao
    //     Scoreboard: Packet Statistics           <- bao nhieu goi khop / lech
    //
    // *** PHEP KIEM TRA CHEO ***
    //
    //     reference.packets_forwarded  ==  scoreboard.packets_in
    //
    // Hai so nay PHAI bang nhau. Lech -> day TLM co van de.
    // Day la loi KHONG BAO GI CA neu khong tu doi chieu.
    //
    // *** CO NEN THEM check_phase CHO REFERENCE KHONG? ***
    // Repo khong co. Nhung ban co the them:
    //
    //     function void check_phase(uvm_phase phase);
    //       if (packets_dropped + packets_forwarded != <so goi yapp monitor thu>)
    //         `uvm_error(...)
    //     endfunction
    //
    // Van de: reference khong biet monitor thu bao nhieu goi.
    // Nghi xem lam the nao de kiem duoc bat bien do. (Goi y: them mot
    // bo dem packets_received++ ngay dau write_yapp)
    // -------------------------------------------------------------------------
// UVM report_phase
  function void report_phase(uvm_phase phase);
    `uvm_info(get_type_name(), $sformatf("Report:\n   Router Reference: Packet Statistics \n     Packets Dropped:   %0d\n     Packets Forwarded: %0d\n     Oversized Packets: %0d\n", packets_dropped, packets_forwarded, jumbo_packets ), UVM_LOW)
  endfunction : report_phase




//==============================================================================
 endclass: router_reference
//==============================================================================


//==============================================================================
// TU KIEM TRA SAU KHI VIET XONG
//==============================================================================
//
// 1. Dem: 2 imp_decl, 2 imp object, 1 port, 3 dong new() trong
//    constructor. Bon so nay co nhat quan khong?
//
// 2. File nay co clone() khong? Scoreboard thi co. Tai sao khac nhau?
//    (Goi y: slide 17 noi clone "before STORAGE". Ai LUU, ai chi
//     CHUYEN TIEP?)
//
// 3. sb_add_out la port, hbus_in/yapp_in la imp. Mot component vua co
//    port vua co imp -- no dong vai gi trong chuoi TLM?
//    Ve lai so do ba muc "monitor -> reference -> scoreboard" va danh
//    dau [ ] va (O) vao dung cho.
//
// 4. Chay voi UVM_LOW. Bon nhan loc ([BAD ADDRESS], [OVERSIZED],
//    [DISABLED], "Sent ... to Scoreboard") co hien ra khong?
//    Ca bon deu dung UVM_LOW -- nghia la gi?
//
// 5. Dem trong log:
//        so lan "Received Input YAPP Packet"  = ___
//        so lan "Sent YAPP Packet to Scoreboard" = ___
//        so lan "[BAD ADDRESS]"  + "[OVERSIZED]" + "[DISABLED]" = ___
//    Quan he giua ba so nay phai la gi?
//
// 6. Voi test_mc CO short_yapp_packet override (length < 20) va
//    MAXPKTSIZE = 20 o buoc dau: co goi nao bi [OVERSIZED] khong?
//    Du doan truoc, roi dem trong log.
//    (Goi y: short_yapp_packet rang buoc length < 20 hay <= 20?
//     Va dieu kien o nhanh 2 la <= hay < ? Hai cai co khop khong?)
//
//==============================================================================
