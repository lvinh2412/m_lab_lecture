//------------------------------------------------------------------------------
// router_scoreboard.sv   --   LAB 9A  (SKELETON)   *** FILE MOI ***
//
// File chinh cua Lab 9A. Day la MODULE UVC: no biet router co ba kenh,
// biet addr quyet dinh kenh nao. KHONG dung lai duoc cho DUT khac.
//
// *** DIEU LA NHAT VE FILE NAY ***
// Khong co run_phase. Khong co forever. Khong co fork. Khong co task.
// Toan bo la FUNCTION.
//
// Scoreboard THUAN BI DONG: no chi chay khi co ai do goi write_*().
// So voi driver/monitor (co run_phase, chu dong) thi nguoc han.
//
// Tham khao: Section 13 slide 5, 14, 16, 17, 18, 19
//------------------------------------------------------------------------------


// ---- SB-1 -------------------------------------------------------------------
// Enum chon cach so sanh. Khai NGOAI class.
//
//     typedef enum bit {EQUALITY, UVM} comp_t;
//
// Hai cach so sanh se viet o [SB-8] va [SB-9]. Enum nay cho phep doi
// giua chung bang CONFIG tu test, khong phai sua code.
//
// Khai ngoai class de test cung nhin thay duoc ten EQUALITY / UVM.
// -----------------------------------------------------------------------------
typedef enum bit {EQUALITY, UVM} comp_t;



// ---- SB-2 -------------------------------------------------------------------
//     class router_scoreboard extends uvm_scoreboard;
//
// uvm_scoreboard la lop co so cho scoreboard. [Suy luan] No gan nhu
// khong them gi so voi uvm_component -- chu yeu de phan loai khi in
// topology. Toi chua doc uvm_scoreboard.svh de xac nhan.
//
// Tu kiem:  grep -n "class uvm_scoreboard" -A 20 $UVMHOME/src/comps/uvm_scoreboard.svh
// -----------------------------------------------------------------------------
class router_scoreboard extends uvm_scoreboard;



// ---- SB-3 -------------------------------------------------------------------
// BON macro imp_decl.
//
//     `uvm_analysis_imp_decl(_yapp)
//     `uvm_analysis_imp_decl(_chan0)
//     `uvm_analysis_imp_decl(_chan1)
//     `uvm_analysis_imp_decl(_chan2)
//
// *** MOI MACRO SINH RA HAI THU ***
//
//     `uvm_analysis_imp_decl(_yapp)
//                            ^^^^^ hau to
//            +-----------------+------------------+
//            v                                    v
//     class uvm_analysis_imp_yapp          ham  write_yapp()
//           (lop MOI duoc tao ra)          (ban PHAI dinh nghia)
//
// Dap an quiz slide 23 cau 3 noi dung dieu nay.
//
// *** VI SAO CAN MACRO ***
// Slide 14: "Only one uvm_analysis_imp object can be declared in a
// component."
// Vi imp goi ham ten "write". Hai imp -> hai ham cung ten -> khong duoc.
// Macro tao ra cac LOP CON khac nhau, moi lop goi mot ham ten khac.
//
// *** BAY: PHAI CO GACH DUOI ***
//     `uvm_analysis_imp_decl(yapp)   -> uvm_analysis_impyapp, writeyapp()
//     `uvm_analysis_imp_decl(_yapp)  -> uvm_analysis_imp_yapp, write_yapp()
//
// Cau hoi: neu DUT co 8 kenh thi can bao nhieu macro? Co thay cach nay
//          bat dau khong on o quy mo lon khong?
// -----------------------------------------------------------------------------
`uvm_analysis_imp_decl(_yapp)
`uvm_analysis_imp_decl(_chan0)
`uvm_analysis_imp_decl(_chan1)
`uvm_analysis_imp_decl(_chan2)



// ---- SB-4 -------------------------------------------------------------------
// BON doi tuong imp -- khai bao.
//
//     uvm_analysis_imp_yapp  #(yapp_packet,    router_scoreboard) sb_yapp_in;
//     uvm_analysis_imp_chan0 #(channel_packet, router_scoreboard) sb_chan0;
//     uvm_analysis_imp_chan1 #(channel_packet, router_scoreboard) sb_chan1;
//     uvm_analysis_imp_chan2 #(channel_packet, router_scoreboard) sb_chan2;
//
// *** HAI THAM SO KIEU -- chu y ***
//
//     uvm_analysis_imp_yapp #( <kieu transaction>, <kieu COMPONENT> )
//                               ^^^^^^^^^^^^^^^^   ^^^^^^^^^^^^^^^^
//                               du lieu nhan vao   class chua write_yapp()
//
// So voi port o phia monitor:
//     uvm_analysis_port #(yapp_packet) item_collected_port;   <- MOT tham so
//
// Vi sao imp can hai ma port chi can mot?
// [Suy luan] imp phai biet GOI HAM CUA AI -- no giu mot con tro kieu do
// va goi m_imp.write_yapp(t). Port thi khong can biet, dich den do
// connect() quyet dinh luc chay.
//
// *** CHU Y KIEU TRANSACTION KHAC NHAU ***
//     _yapp  -> yapp_packet
//     _chan* -> channel_packet
// Hai kieu KHAC NHAU. Day chinh la ly do [SB-8]/[SB-9] phai tu viet
// ham so sanh thay vi dung compare() co san.
// -----------------------------------------------------------------------------
	uvm_analysis_imp_yapp  #(yapp_packet,    router_scoreboard) sb_yapp_in;
uvm_analysis_imp_chan0 #(channel_packet, router_scoreboard) sb_chan0;
uvm_analysis_imp_chan1 #(channel_packet, router_scoreboard) sb_chan1;
uvm_analysis_imp_chan2 #(channel_packet, router_scoreboard) sb_chan2;

// ---- SB-5 -------------------------------------------------------------------
// EXPECTED DATA STORE: ba hang doi.
//
//     yapp_packet sb_queue0[$];
//     yapp_packet sb_queue1[$];
//     yapp_packet sb_queue2[$];
//
// *** VI SAO QUEUE MA KHONG PHAI ASSOCIATIVE ARRAY ***
// Slide 6: "Queues are OK when output packets are same order as input
// packets. Associative array is much better when output packets can
// come out in a different order."
//
// Moi kenh cua router la mot FIFO doc lap -> goi ra dung thu tu goi vao
// -> queue dung duoc.
//
// *** VI SAO BA QUEUE MA KHONG PHAI MOT ***
// Ba kenh hoat dong SONG SONG. Goi vao kenh 0 va kenh 1 co the ra
// khong theo thu tu tuong doi nhau. Mot queue chung se sai.
//
// *** CHU Y KIEU: yapp_packet, KHONG PHAI channel_packet ***
// Hang doi luu goi VAO (du doan), so voi goi RA khi no den.
// -----------------------------------------------------------------------------
yapp_packet sb_queue0[$];
yapp_packet sb_queue1[$];
yapp_packet sb_queue2[$];





// ---- SB-6 -------------------------------------------------------------------
// Bo dem thong ke.
//
//     int packets_in,  in_dropped;
//     int packets_ch0, compare_ch0, miscompare_ch0, dropped_ch0;
//     int packets_ch1, compare_ch1, miscompare_ch1, dropped_ch1;
//     int packets_ch2, compare_ch2, miscompare_ch2, dropped_ch2;
//
// Y nghia:
//     packets_in     : so goi YAPP vao scoreboard
//     in_dropped     : goi co addr = 3 (dia chi khong hop le) -> khong push
//     packets_chN    : so goi kenh N thu duoc
//     compare_chN    : so lan so sanh KHOP
//     miscompare_chN : so lan so sanh KHONG KHOP
//     dropped_chN    : so goi kenh N nhan duoc khi hang doi RONG
//
// Slide 16: "Every write updates statistics which are summarized in
// the report phase."
//
// Cau hoi: packets_ch0 co luon bang compare_ch0 + miscompare_ch0 +
//          dropped_ch0 khong? Kiem lai sau khi viet xong ba ham write.
// -----------------------------------------------------------------------------
int packets_in,  in_dropped;
int packets_ch0, compare_ch0, miscompare_ch0, dropped_ch0;
int packets_ch1, compare_ch1, miscompare_ch1, dropped_ch1;
int packets_ch2, compare_ch2, miscompare_ch2, dropped_ch2;






// ---- SB-7 -------------------------------------------------------------------
// Chinh sach so sanh + macro dang ky.
//
//     comp_t compare_policy = EQUALITY;     // <- BAT DAU bang EQUALITY
//
//     `uvm_component_utils_begin(router_scoreboard)
//       `uvm_field_enum(comp_t, compare_policy, UVM_ALL_ON)
//     `uvm_component_utils_end
//
// *** VI SAO BAT DAU BANG EQUALITY ***
// comp_equal da duoc cho san ben duoi. Dat EQUALITY thi Buoc 4-6 chay
// duoc ngay. Den Buoc 7 ban viet comp_uvm roi doi thanh UVM.
// (Repo dat mac dinh la UVM.)
//
// *** uvm_field_enum lam duoc gi ***
// Nho field automation, test co the doi chinh sach bang mot dong:
//     uvm_config_int::set(this, "tb.router_sb", "compare_policy", EQUALITY);
// khong phai sua scoreboard.
//
// Day la Section 7 ap dung vao Section 13. Thu dong do o Buoc 7 thay vi
// sua gia tri mac dinh -- se thay ro hon.
// -----------------------------------------------------------------------------
	comp_t compare_policy = EQUALITY;

	`uvm_component_utils_begin(router_scoreboard)
		`uvm_field_enum(comp_t, compare_policy, UVM_ALL_ON)
	`uvm_component_utils_end




// ---- SB-8 -------------------------------------------------------------------
// CONSTRUCTOR -- noi tao bon doi tuong imp.
//
//     function new(string name="", uvm_component parent=null);
//       super.new(name, parent);
//       sb_yapp_in = new("sb_yapp_in", this);
//       sb_chan0   = new("sb_chan0",   this);
//       sb_chan1   = new("sb_chan1",   this);
//       sb_chan2   = new("sb_chan2",   this);
//     endfunction
//
// *** BA DIEU PHAI NHAN RA ***
//
//  (1) new(), KHONG PHAI type_id::create()
//      Port va imp la ha tang TLM, khong di qua factory, khong bao gio
//      bi override.
//
//  (2) Trong CONSTRUCTOR, khong phai build_phase
//      [Suy luan] Vi connect_phase cua router_tb goi connect() tren
//      chung, va chung phai ton tai truoc do. Tao trong constructor la
//      chac chan nhat. Thu dat vao build_phase xem co hong khong --
//      mot thi nghiem 2 phut.
//
//  (3) Doi so thu hai la "this"
//      Imp la mot uvm_component con cua scoreboard. No SE xuat hien
//      trong print_topology() duoi router_sb.
// -----------------------------------------------------------------------------
	function new(string name ="", uvm_component parent=null);
		super.new(name, parent);
		sb_yapp_in = new("sb_yapp_in", this);
		sb_chan0   = new("sb_chan0",   this);
		sb_chan1   = new("sb_chan1",   this);
		sb_chan2   = new("sb_chan2",   this);
	endfunction



//==============================================================================
// comp_equal  --  *** CHO SAN, CHEP Y NGUYEN ***
//
// So sanh bang toan tu. Slide 18.
// Toi cho san de ban co mot bo so sanh CHAY DUOC ngay tu Buoc 4,
// truoc khi phai hoc uvm_comparer.
//==============================================================================

   // custom packet compare function using inequality operators
   function bit comp_equal (input yapp_packet yp, input channel_packet cp);
      // returns first mismatch only
      if (yp.addr != cp.addr) begin
        `uvm_error("PKT_COMPARE",$sformatf("Address mismatch YAPP %0d Chan %0d",yp.addr,cp.addr))
        return(0);
      end
      if (yp.length != cp.length) begin
        `uvm_error("PKT_COMPARE",$sformatf("Length mismatch YAPP %0d Chan %0d",yp.length,cp.length))
        return(0);
      end
      foreach (yp.payload [i])
        if (yp.payload[i] != cp.payload[i]) begin
          `uvm_error("PKT_COMPARE",$sformatf("Payload[%0d] mismatch YAPP %0d Chan %0d",i,yp.payload[i],cp.payload[i]))
          return(0);
        end
      if (yp.parity != cp.parity) begin
        `uvm_error("PKT_COMPARE",$sformatf("Parity mismatch YAPP %0d Chan %0d",yp.parity,cp.parity))
        return(0);
      end
      return(1);
   endfunction

// *** DOC KY HAM NAY TRUOC KHI VIET [SB-9] ***
//
// Comment dong dau: "returns first mismatch only".
// Moi "return(0)" DUNG HAM NGAY. Neu goi sai ca addr lan parity,
// ban chi biet addr sai.
//
// Do la diem yeu, va la ly do slide 19 ton tai.
//
// Bon truong duoc so: addr, length, payload[] (vong lap), parity.
// Chu y KHONG so packet_delay va parity_type. Vi sao?
// (Goi y: channel_packet co hai truong do khong? Monitor co doc duoc
//  packet_delay tu day khong? -- ban da tra loi cau nay o Lab 6)
//==============================================================================




// ---- SB-9 -------------------------------------------------------------------
// comp_uvm  --  so sanh bang uvm_comparer. Slide 19.
//
// *** VIET O BUOC 7, SAU KHI MOI THU DA CHAY ***
//
// Khung:
//
//   function bit comp_uvm(input yapp_packet yp, input channel_packet cp,
//                         uvm_comparer comparer = null);
//     string str;
//     if (comparer == null)
//       comparer = new();
//     comp_uvm  = comparer.compare_field("addr",   yp.addr,   cp.addr,   2);
//     comp_uvm &= comparer.compare_field("length", yp.length, cp.length, 6);
//     foreach (yp.payload [i]) begin
//       str.itoa(i);
//       comp_uvm &= comparer.compare_field({"payload[",str,"]"},
//                                          yp.payload[i], cp.payload[i], 8);
//     end
//     comp_uvm &= comparer.compare_field("parity", yp.parity, cp.parity, 8);
//   endfunction
//
//=============================================================================
// *** NAM DIEU PHAI HIEU ***
//=============================================================================
//
//  (1) KHONG CO "return". Gan thang vao TEN HAM.
//      Trong SystemVerilog, gan vao ten ham = dat gia tri tra ve.
//      Lan dau dung "=", cac lan sau dung "&=".
//
//  (2) "&=" thay vi "return(0)"  <- KHAC BIET CAN BAN voi comp_equal
//      Chay HET moi truong, AND don ket qua.
//      -> bao MOI loi, khong chi loi dau tien.
//
//  (3) Tham so thu tu cua compare_field la SO BIT
//          addr       -> 2   (rand bit [1:0] addr)
//          length     -> 6   (rand bit [5:0] length)
//          payload[i] -> 8   (bit [7:0])
//          parity     -> 8   (bit [7:0])
//      Tu doi chieu voi khai bao trong yapp_packet.sv truoc khi go.
//
//  (4) "comparer = new()" neu khong duoc truyen vao
//      Cho phep nguoi dung truyen comparer rieng (co cau hinh rieng).
//      Slide 19: "Users can set up and pass in their own comparer instance"
//
//  (5) str.itoa(i) -- doi so nguyen thanh chuoi
//      De ten truong in ra la "payload[3]" chu khong phai "payload[]".
//      Khong co dong nay thi moi phan tu payload deu bao cung mot ten.
//
// *** SAU KHI VIET XONG ***
// Doi compare_policy mac dinh (hoac set bang config) thanh UVM.
// Chay lai. So sanh thong bao loi cua hai cach -- co chu y lam HONG
// mot goi de thay (xem CAU HOI 3 o cuoi file).
// -----------------------------------------------------------------------------

function bit comp_uvm(input yapp_packet yp, input channel_packet cp, uvm_comparer comparer = null);
       string str;
       if (comparer == null)
           comparer = new();
       comp_uvm = comparer.compare_field("addr", yp.addr, cp.addr,2);
       comp_uvm &= comparer.compare_field("length", yp.length, cp.length,6);
       foreach (yp.payload [i]) begin
           str.itoa(i);
           comp_uvm &= comparer.compare_field({"payload[",str,"]"}, yp.payload[i], cp.payload[i],8);
       end
       comp_uvm &= comparer.compare_field("parity", yp.parity, cp.parity,8);
   endfunction






// ---- SB-10 ------------------------------------------------------------------
// write_yapp  --  *** HAM QUAN TRONG NHAT VE MAT KHAI NIEM ***
//
// Slide 16: "YAPP write checks reference model registers and pushes
//            packets to queue."
//
// Lab 9A chua co reference model, nen chi con phan "pushes to queue".
//
// Khung:
//
//   virtual function void write_yapp(yapp_packet packet);
//     yapp_packet sb_packet;
//     // Make a copy for storing in the scoreboard
//     $cast( sb_packet, packet.clone() );   // Clone returns uvm_object type
//     packets_in++;
//     case (sb_packet.addr)
//       2'b00: begin
//                sb_queue0.push_back(sb_packet);
//                `uvm_info(get_type_name(), "Added packet to Scoreboard Queue 0", UVM_HIGH)
//              end
//       2'b01: ...  // Queue 1
//       2'b10: ...  // Queue 2
//       default: begin
//                `uvm_info(get_type_name(), $sformatf("Packet Dropped: Bad Address=%d\n%s",
//                          sb_packet.addr, sb_packet.sprint()), UVM_LOW)
//                in_dropped++;
//              end
//     endcase
//   endfunction
//
//=============================================================================
// *** DONG $cast(...clone()) LA DONG QUAN TRONG NHAT CUA CA LAB 9A ***
//=============================================================================
//
// Slide 17: "write only sends a reference: Pointer to packet instance"
//
// KHONG clone:
//    t=100  monitor: pkt.length=5  -> write(pkt)  -> q0 = [@472]
//    t=200  monitor: pkt.length=9  -> write(pkt)  -> q0 = [@472, @472]
//                    ^^^^^^^^^^^^
//                    GHI DE len chinh doi tuong dang nam trong queue!
//    -> q0[0].length gio cung = 9. Goi dau tien BIEN MAT.
//    -> toan bo queue thanh N ban sao cua goi cuoi cung.
//
// CO clone:
//    q0 = [@583, @625, @747]   <- ba doi tuong RIENG BIET
//
// *** VI SAO $cast ***
// clone() khai bao tra ve uvm_object (lop co so).
//    yapp_packet ypkt = packet.clone();   // ✗ loi bien dich
//    $cast(ypkt, packet.clone());         // ✓
// Cung co che $cast ma `uvm_declare_p_sequencer dung.
//
// *** NHANH default -- addr == 3 ***
// yapp_packet cho phep addr 0..3 nhung router chi co ba kenh.
// addr = 3 -> router khong biet gui di dau -> DROP.
// Scoreboard phai biet dieu do, neu khong no se doi mot goi khong
// bao gio den.
//
// Day la manh REFERENCE MODEL duy nhat cua Lab 9A: mot cau case.
// Lab 9B se them hai dieu kien nua (MAXPKTSIZE va ROUTER_EN).
//
// Chu y "virtual function void" -- ham write_* nen la virtual de
// lop con (Lab 9B) co the mo rong.
// -----------------------------------------------------------------------------

virtual function void write_yapp(yapp_packet packet);
     yapp_packet sb_packet;
     // Make a copy for storing in the scoreboard
     $cast( sb_packet,  packet.clone());  // Clone returns uvm_object type
     packets_in++;
     case (sb_packet.addr)
        2'b00: begin 
                sb_queue0.push_back(sb_packet);
                `uvm_info(get_type_name(), "Added packet to Scoreboard Queue 0", UVM_HIGH)
               end
        2'b01: begin
                sb_queue1.push_back(sb_packet);
                `uvm_info(get_type_name(), "Added packet to Scoreboard Queue 1", UVM_HIGH)
               end
        2'b10: begin
                sb_queue2.push_back(sb_packet);
                `uvm_info(get_type_name(), "Added packet to Scoreboard Queue 2", UVM_HIGH)
               end
        default: begin
                `uvm_info(get_type_name(), $sformatf("Packet Dropped: Bad Address=%d\n%s",
                                sb_packet.addr, sb_packet.sprint()), UVM_LOW)
                in_dropped++;
               end
     endcase
    endfunction








// ---- SB-11 ------------------------------------------------------------------
// write_chan0  --  CHECKING LOGIC
//
// Slide 16: "Channel write compares received packet with packet from queue."
//
// Khung:
//
//   virtual function void write_chan0(channel_packet packet);
//     bit pktcompare;
//     yapp_packet sb_packet;
//     packets_ch0++;
//
//     // (a) Hang doi rong?  -- PHAI KIEM TRA TRUOC
//     if( sb_queue0.size() == 0 ) begin
//       `uvm_error(get_type_name(),
//         $sformatf("Scoreboard Error [EMPTY]: Received Unexpected Channel_0 Packet!\n%s",
//                   packet.sprint()))
//       dropped_ch0++;
//       return;
//     end
//
//     // (b) Chon bo so sanh theo chinh sach
//     if (compare_policy == UVM)
//       pktcompare = comp_uvm(sb_queue0[0], packet);
//     else
//       pktcompare = comp_equal(sb_queue0[0], packet);
//
//     // (c) Xu ly ket qua
//     if( pktcompare ) begin
//       void'(sb_queue0.pop_front());
//       `uvm_info(get_type_name(),
//         $sformatf("Scoreboard Compare Match: Channel_0 Packet\n%s", packet.sprint()),
//         UVM_MEDIUM)
//       compare_ch0++;
//     end
//     else begin
//       sb_packet = sb_queue0[0];
//       `uvm_warning(get_type_name(),
//         $sformatf("Scoreboard Error [MISCOMPARE]: Received Channel_0 Packet:\n%s\nExpected Channel_0 Packet:\n%s",
//                   packet.sprint(), sb_packet.sprint()))
//       miscompare_ch0++;
//     end
//   endfunction
//
//=============================================================================
// *** BON QUYET DINH THIET KE TRONG HAM NAY ***
//=============================================================================
//
//  (1) KIEM TRA RONG TRUOC KHI POP
//      pop_front() tren queue rong la hanh vi khong xac dinh.
//      Va "goi ra ma khong co goi vao" la mot loi THAT -- phai bao.
//
//      [Da xac minh] lab09_sba dung `uvm_error cho cho nay;
//      lab09_sbb va router/sv dung `uvm_warning.
//      Ban chon cai nao? Suy nghi: day la loi cua DUT (phat goi thua)
//      hay cua testbench (scoreboard mat dong bo)?
//
//  (2) NHIN TRUOC (sb_queue0[0]), POP SAU
//      Khong pop ngay, vi khi MISCOMPARE ban can goi mong doi DE IN RA.
//      Pop truoc roi thi mat.
//
//  (3) KHONG POP KHI MISCOMPARE
//      Hang doi khong voi di -> goi tiep theo lai so voi cung goi cu
//      -> MOT loi gay ra mot CHUOI loi.
//      Do la lua chon co y thuc cua tac gia repo. Co the tranh cai.
//      Thu doi: pop ca khi miscompare, roi so sanh hai log.
//
//  (4) MISCOMPARE dung `uvm_warning, khong phai `uvm_error
//      [Da xac minh] Repo lam vay. Nhung report_phase o [SB-14] SE
//      bien tong so miscompare thanh `uvm_error.
//      => mot thong bao chi tiet moi lan sai, mot phan quyet cuoi cung.
//      Thiet ke nay cho phep mo phong CHAY TIEP de thu thap het loi
//      thay vi dung o loi dau.
//
// *** packet.sprint() ***
// In ca goi ra dang bang. Dung sprint() (tra ve string) chu khong
// print() (in thang), vi ta dang nhet no vao $sformatf.
// -----------------------------------------------------------------------------

virtual function void write_chan0(channel_packet packet);
      bit pktcompare;
      yapp_packet sb_packet;
      packets_ch0++;
      if( sb_queue0.size() == 0 ) begin
        `uvm_error(get_type_name(),
        $sformatf("Scoreboard Error [EMPTY]: Received Unexpected Channel_0 Packet!\n%s", packet.sprint()))
        dropped_ch0++;
        return;
      end

      if (compare_policy == UVM)
        // use custom comparer with UVM methods
        pktcompare =  comp_uvm(sb_queue0[0],packet);
      else
        // use custom comparer with equality operators
        pktcompare =  comp_equal(sb_queue0[0],packet);

      if( pktcompare ) begin
        void'(sb_queue0.pop_front());
        `uvm_info(get_type_name(), $sformatf("Scoreboard Compare Match: Channel_0 Packet\n%s", packet.sprint()), UVM_MEDIUM)
        compare_ch0++;
      end
      else begin
        sb_packet = sb_queue0[0];
        `uvm_warning(get_type_name(), $sformatf("Scoreboard Error [MISCOMPARE]: Received Channel_0 Packet:\n%s\nExpected Channel_0 Packet:\n%s", packet.sprint(), sb_packet.sprint()))
        miscompare_ch0++;
      end
   endfunction



// ---- SB-12 ------------------------------------------------------------------
// write_chan1 va write_chan2
//
// CHEP y het write_chan0, doi:
//     sb_queue0 -> sb_queue1 / sb_queue2
//     packets_ch0, compare_ch0, miscompare_ch0, dropped_ch0  -> ..._ch1 / ..._ch2
//     "Channel_0" -> "Channel_1" / "Channel_2"
//
// *** CHEP-DAN BA LAN -- CO KHO CHIU KHONG? ***
// Co. Va do la mot bai hoc.
//
// Cau hoi thiet ke: co cach nao viet MOT ham cho ca ba kenh khong?
//   (a) Dung mang: yapp_packet sb_queue[3][$];  int packets_ch[3];
//       -> lab09_sbd lam dung vay: "int packets_ch [2:0];"
//   (b) Nhung write_chan0/1/2 VAN phai la ba ham rieng -- vi sao?
//       (Goi y: ai goi chung? macro imp_decl sinh ra cai gi?)
//
// => Ba ham vo bat buoc phai rieng, nhung RUOT co the goi chung mot
//    ham co tham so kenh:
//        function void write_chan0(channel_packet p);  check_chan(0, p);  endfunction
//        function void write_chan1(channel_packet p);  check_chan(1, p);  endfunction
//        function void write_chan2(channel_packet p);  check_chan(2, p);  endfunction
//
// Repo KHONG lam vay (chep-dan ba lan). Ban co the lam khac.
// Neu lam, nho rang README noi ban dang hoc, khong phai thi.
// Chep-dan truoc cho chay, roi gop lai -- cung duoc.
// -----------------------------------------------------------------------------
virtual function void write_chan1(channel_packet packet);
      bit pktcompare;
      yapp_packet sb_packet;
      packets_ch1++;
      if( sb_queue1.size() == 0 ) begin
        `uvm_warning(get_type_name(),
        $sformatf("Scoreboard Error [EMPTY]: Received Unexpected Channel_1 Packet!\n%s", packet.sprint()))
        dropped_ch1++;
        return;
      end

      if (compare_policy == UVM)
        // use custom comparer with UVM methods
        pktcompare =  comp_uvm(sb_queue1[0],packet);
      else
        // use custom comparer with equality operators
        pktcompare =  comp_equal(sb_queue1[0],packet);

      if( pktcompare ) begin
        void'(sb_queue1.pop_front());
        `uvm_info(get_type_name(), $sformatf("Scoreboard Compare Match: Channel_1 Packet\n%s", packet.sprint()), UVM_MEDIUM)
        compare_ch1++;
      end
      else begin
        sb_packet = sb_queue1[0];
        `uvm_warning(get_type_name(), $sformatf("Scoreboard Error [MISCOMPARE]: Received Channel_1 Packet:\n%s\nExpected Channel_1 Packet:\n%s", packet.sprint(), sb_packet.sprint()))
        miscompare_ch1++;
      end
   endfunction

virtual function void write_chan2(channel_packet packet);
      bit pktcompare;
      yapp_packet sb_packet;
      packets_ch2++;
      if( sb_queue2.size() == 0 ) begin
        `uvm_warning(get_type_name(),
        $sformatf("Scoreboard Error [EMPTY]: Received Unexpected Channel_2 Packet!\n%s", packet.sprint()))
        dropped_ch2++;
        return;
      end

      if (compare_policy == UVM)
        // use custom comparer with UVM methods
        pktcompare =  comp_uvm(sb_queue2[0],packet);
      else
        // use custom comparer with equality operators
        pktcompare =  comp_equal(sb_queue2[0],packet);

      if( pktcompare ) begin
        void'(sb_queue2.pop_front());
        `uvm_info(get_type_name(), $sformatf("Scoreboard Compare Match: Channel_2 Packet\n%s", packet.sprint()), UVM_MEDIUM)
        compare_ch2++;
      end
      else begin
        sb_packet = sb_queue2[0];
        `uvm_warning(get_type_name(), $sformatf("Scoreboard Error [MISCOMPARE]: Received Channel_2 Packet:\n%s\nExpected Channel_2 Packet:\n%s", packet.sprint(), sb_packet.sprint()))
        miscompare_ch2++;
      end
   endfunction




// ---- SB-13 ------------------------------------------------------------------
// check_phase  --  *** KIEM TRA GOI BI MAT ***
//
//   function void check_phase(uvm_phase phase);
//     `uvm_info(get_type_name(), "Checking Router Scoreboard", UVM_LOW)
//     if (sb_queue0.size() || sb_queue1.size() || sb_queue2.size())
//       `uvm_error(get_type_name(),
//         $sformatf("Check:\n\n   WARNING: Router Scoreboard Queue's NOT Empty:\n     Chan 0: %0d\n     Chan 1: %0d\n     Chan 2: %0d\n",
//                   sb_queue0.size(), sb_queue1.size(), sb_queue2.size()))
//     else
//       `uvm_info(get_type_name(), "Check:\n\n   Router Scoreboard Empty!\n", UVM_LOW)
//   endfunction : check_phase
//
// *** DAY LA PHEP KIEM TRA MA SO SANH TUNG GOI KHONG LAM DUOC ***
//
// So sanh tung goi tra loi: "goi nay co dung khong?"
// check_phase tra loi:      "co goi nao KHONG BAO GIO RA khong?"
//
// Hang doi con goi = co goi vao DUT ma khong ra. Router nuot goi.
// Khong co check nay thi loi do hoan toan im lang.
//
// *** CHU Y: check_phase chay SAU run_phase ***
// Nen no can drain time. base_test cua ban da co:
//     obj.set_drain_time(this, 200ns);
// Bo dong do di -> goi cuoi chua kip ra -> check_phase bao loi GIA.
//
// Thu nghiem: tam bo drain time, chay, xem check_phase bao gi.
// Day la cach tot nhat de hieu drain time dung de lam gi.
// -----------------------------------------------------------------------------

function void check_phase(uvm_phase phase);
  `uvm_info(get_type_name(), "Checking Router Scoreboard", UVM_LOW)
  if (sb_queue0.size() || sb_queue1.size() || sb_queue2.size())
  `uvm_error(get_type_name(), $sformatf("Check:\n\n   WARNING: Router Scoreboard Queue's NOT Empty:\n     Chan 0: %0d\n     Chan 1: %0d\n     Chan 2: %0d\n", sb_queue0.size(), sb_queue1.size(), sb_queue2.size()))
  else
  `uvm_info(get_type_name(), "Check:\n\n   Router Scoreboard Empty!\n", UVM_LOW)
endfunction : check_phase



// ---- SB-14 ------------------------------------------------------------------
// report_phase  --  PHAN QUYET CUOI CUNG
//
//   function void report_phase(uvm_phase phase);
//     `uvm_info(get_type_name(), $sformatf(
//       "Report:\n\n   Scoreboard: Packet Statistics \n     Packets In:   %0d     Packets Dropped: %0d\n     Channel 0 Total: %0d  Pass: %0d  Miscompare: %0d  Dropped: %0d\n     Channel 1 Total: %0d  Pass: %0d  Miscompare: %0d  Dropped: %0d\n     Channel 2 Total: %0d  Pass: %0d  Miscompare: %0d  Dropped: %0d\n\n",
//       packets_in, in_dropped,
//       packets_ch0, compare_ch0, miscompare_ch0, dropped_ch0,
//       packets_ch1, compare_ch1, miscompare_ch1, dropped_ch1,
//       packets_ch2, compare_ch2, miscompare_ch2, dropped_ch2), UVM_LOW)
//
//     if ((miscompare_ch0 + miscompare_ch1 + miscompare_ch2 +
//          dropped_ch0 + dropped_ch1 + dropped_ch2) > 0)
//       `uvm_error(get_type_name(),"Status:\n\nSimulation FAILED\n")
//     else
//       `uvm_info(get_type_name(),"Status:\n\nSimulation PASSED\n", UVM_NONE)
//   endfunction : report_phase
//
// *** HAI DIEU DANG CHU Y ***
//
//  (1) UVM_NONE o dong PASSED
//      UVM_NONE la muc verbosity THAP NHAT -- nghia la "luon in, du
//      dat verbosity the nao".
//      Thong diep quan trong nhat cua ca mo phong khong duoc phep bi
//      loc mat khi ai do chay voi +UVM_VERBOSITY=UVM_NONE.
//
//      So sanh: dong thong ke dung UVM_LOW -> co the bi loc.
//
//  (2) MISCOMPARE o [SB-11] la warning, nhung TONG o day la error
//      Thiet ke co chu y:
//        - moi lan sai -> warning -> mo phong CHAY TIEP, thu thap het loi
//        - cuoi cung   -> error   -> ket luan FAILED
//      Neu moi miscompare la error ngay thi mo phong co the dung som
//      (tuy nguong UVM_MAX_QUIT_COUNT) va ban chi thay loi dau tien.
//
// *** CAU HOI ***
// Dieu kien FAILED cong ca "dropped" vao. Vi sao goi bi drop o kenh
// (hang doi rong) cung tinh la FAIL? No khac gi miscompare?
// -----------------------------------------------------------------------------

function void report_phase(uvm_phase phase);
  `uvm_info(get_type_name(), $sformatf("Report:\n\n   Scoreboard: Packet Statistics \n     Packets In:   %0d     Packets Dropped: %0d\n     Channel 0 Total: %0d  Pass: %0d  Miscompare: %0d  Dropped: %0d\n     Channel 1 Total: %0d  Pass: %0d  Miscompare: %0d  Dropped: %0d\n     Channel 2 Total: %0d  Pass: %0d  Miscompare: %0d  Dropped: %0d\n\n", packets_in, in_dropped, packets_ch0, compare_ch0, miscompare_ch0, dropped_ch0, packets_ch1, compare_ch1, miscompare_ch1, dropped_ch1, packets_ch2, compare_ch2, miscompare_ch2, dropped_ch2), UVM_LOW)
  if ((miscompare_ch0 + miscompare_ch1 + miscompare_ch2 + dropped_ch0 + dropped_ch1 + dropped_ch2) > 0)
    `uvm_error(get_type_name(),"Status:\n\nSimulation FAILED\n")
  else
    `uvm_info(get_type_name(),"Status:\n\nSimulation PASSED\n", UVM_NONE)
endfunction : report_phase



// ---- SB-15 ------------------------------------------------------------------
//     endclass : router_scoreboard
// -----------------------------------------------------------------------------

endclass : router_scoreboard


//==============================================================================
// TU KIEM TRA SAU KHI VIET XONG
//==============================================================================
//
// 1. Dem so macro `uvm_analysis_imp_decl: phai la 4.
//    Dem so ham write_*: cung phai la 4.
//    Dem so dong "= new(" trong constructor: cung 4.
//    Ba so nay LUON phai bang nhau. Lech mot la thieu mot cho.
//
// 2. File nay co run_phase khong? Co task nao khong? Vi sao khong?
//
// 3. Lam HONG mot goi co chu y de thay scoreboard bao loi:
//    Trong yapp_tx_seqs.sv hoac trong test, ep mot goi co
//    parity_type = BAD_PARITY. Router se tinh lai parity hay giu nguyen?
//    Scoreboard se bao gi?
//    (Thu voi ca comp_equal va comp_uvm, so sanh thong bao)
//
// 4. Them tam mot `uvm_info sau moi push de in sb_queue0.size().
//    Chay voi UVM_HIGH. Ve do thi size theo thoi gian tren giay:
//    no co len roi xuong ve 0 khong? Dinh cao nhat la bao nhieu?
//    Con so do noi gi ve do tre cua router?
//
// 5. Dem trong log:
//        packets_in          = ___
//        packets_ch0+1+2     = ___
//        in_dropped          = ___
//    Quan he giua ba so nay phai la gi?
//
// 6. Bo dong $cast(...clone()) di, thay bang push_back(packet) thang.
//    Chay. Co hong khong? Neu khong hong thi vi sao?
//    (Doc lai BAY 1 trong README truoc khi ket luan)
//
//==============================================================================
