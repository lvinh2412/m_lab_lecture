===============================================================================
LAB 9A -- CREATING A SCOREBOARD USING TLM
Section 13 slide 22:
  "Build scoreboard with expected data store and checking logic"
  "Scoreboard has Analysis ports for:
      - Adding packets that are sent to DUT
      - Checking packets coming out of the DUT"
  "Tip: Use decl macros for each connection"
===============================================================================

*** LAB 9A LA LAB DAU TIEN TESTBENCH NOI "DUT SAI" VE DU LIEU ***

  Section 11 da co CHANNEL_ID  -> kiem tra DINH TUYEN (goi di dung cua chua)
  Lab 9A co scoreboard         -> kiem tra NOI DUNG   (goi ra co dung goi vao)

Tu Lab 1 den Lab 8, ban KICH THICH va QUAN SAT. Lab 9A la lan dau
testbench co the tuyen bo PASS hay FAIL mot cach co can cu.


===============================================================================
PHAN 1 -- BA CHUC NANG (Section 13 slide 5)
===============================================================================

  "There are three distinct functions in the scoreboard:
     1. Transfer function (reference model)
     2. Expected data storage mechanism
     3. Checking logic"

Ap dung cho YAPP router:

   +---------------------+------------------------+---------------------+
   | chuc nang           | tra loi cau hoi        | Lab 9A lam gi       |
   +---------------------+------------------------+---------------------+
   | Ref model f()       | "dau ra DUNG la gi?"   | gan nhu KHONG LAM   |
   |                     |                        | (chi tach theo addr)|
   | Expected data store | "giu ket qua o dau?"   | 3 hang doi [$]      |
   | Checking logic      | "co khop khong?"       | comp_equal/comp_uvm |
   +---------------------+------------------------+---------------------+

*** VI SAO REF MODEL GAN NHU KHONG LAM GI ***
Router khong BIEN DOI du lieu -- no chi DINH TUYEN. Goi vao kenh 0 thi
ra kenh 0, nguyen ven tung byte. Nen "ham bien doi" chi la mot cau case
tren addr.

(So voi mot khoi DSP hay crypto: ref model o do la ca mot chuong trinh C.
 Section 13 slide 6 nhac toi dieu nay.)

*** LAB 9A CHUA LAM GI VOI HBUS ***
Slide 4: "Scoreboard must account for a disabled router or oversized
packets". Do la LAB 9B. Lab 9A gia dinh moi goi deu di qua duoc.
PHAN 6 duoi day co thi nghiem cho ban thay gia dinh do sai o dau.


===============================================================================
PHAN 2 -- BAN DO FILE
===============================================================================

   lab09a_my/
     sv/                      <- *** THU MUC NAY QUAY TRO LAI ***
       router_scoreboard.sv   <- [SB-1..16]   FILE MOI, file chinh cua lab
     tb/
       run.f                  <- [RUN-1..2]
       clkgen.sv              <- giu nguyen
       hw_top.sv              <- giu nguyen
       tb_top.sv              <- [TB-1]    them 1 dong `include
       router_mcsequencer.sv  <- giu nguyen tu Lab 8
       router_mcseqs_lib.sv   <- giu nguyen
       router_tb.sv           <- [RTB-1..3]
       router_test_lib.sv     <- [TEST-1]  (gan nhu khong doi)

*** VI SAO sv/ QUAY TRO LAI ***

   Lab 6:  lab06_my/sv/   <- chua UVC YAPP cua rieng ban
   Lab 7:  (khong co sv/) <- UVC da ra ngoai, dung chung
   Lab 8:  (khong co sv/) <- hai file moi la class cua testbench, de o tb/
   Lab 9:  lab09a_my/sv/  <- chua MODULE UVC code

Scoreboard la MODULE UVC (Section 11): no biet router co 3 kenh, biet
addr quyet dinh kenh nao. No KHONG dung lai duoc cho DUT khac.

[Suy luan] Repo tach no ra sv/ de phan biet voi code testbench thuan
(router_tb.sv, router_test_lib.sv) o tb/. Toi suy ra tu cau truc
lab09_sba; khong co tai lieu noi ro.


===============================================================================
PHAN 3 -- LUONG DU LIEU
===============================================================================

   yapp monitor                          scoreboard
   +-------------+                       +------------------------------+
   | item_       |  yapp_packet          |  write_yapp()                |
   | collected_  |--------------------->(O)  |                          |
   | port      [ ]                       |  v  CLONE                    |
   +-------------+                       |  v                           |
                                         |  case (addr)                 |
   chan0 monitor                         |   0 -> sb_queue0.push_back() |
   +-------------+                       |   1 -> sb_queue1.push_back() |
   | item_       |  channel_packet       |   2 -> sb_queue2.push_back() |
   | collected_  |--------------------->(O)  3 -> DROP (dia chi sai)    |
   | port      [ ]      write_chan0()    |                              |
   +-------------+                       |  write_chan0()               |
                                         |   yp = sb_queue0.pop_front() |
   chan1 monitor --------------------->(O)   so sanh yp voi cp          |
                       write_chan1()    |                              |
   chan2 monitor --------------------->(O)  write_chan2()               |
                       write_chan2()    |                              |
                                         +------------------------------+

   [ ] = port (uvm_analysis_port)   -- monitor DA CO tu Lab 3
   (O) = imp  (uvm_analysis_imp_*)  -- ban viet o Lab 9A

*** DIEU QUAN TRONG NHAT VE LUONG NAY ***

Monitor KHONG SUA MOT DONG NAO. `item_collected_port.write(pkt)` da co
trong yapp_tx_monitor.sv tu Lab 3 va trong channel_rx_monitor.sv tu khi
ban nhan UVC do. Suot 6 lab no ghi vao hu khong.

Section 13 slide 9: "Producer does not know how many consumers are
connected" va dap an quiz cau 2: "Any number, INCLUDING ZERO."

=> Lab 9A chi noi dau kia vao. Khong dong toi yapp/sv/ hay channel/sv/.


===============================================================================
PHAN 4 -- THU TU LAM (BAY buoc)
===============================================================================

   Buoc 0.  Chep lab08_my/tb/* sang lab09a_my/tb/
            Tao thu muc lab09a_my/sv/ (rong)
            Chay test_mc. Phai ra ket qua y het Lab 8.

   Buoc 1.  Viet KHUNG router_scoreboard.sv:  [SB-1..8]
            - typedef, class, 4 imp_decl, 4 imp object, 3 queue,
              thong ke, constructor
            - BON ham write_* de RONG (chi co `uvm_info bao da vao)
            Them [TB-1] va [RUN-1].
            Them [RTB-1], [RTB-2] (handle + create) -- CHUA connect.
            Chay. print_topology() phai hien them "router_sb".
            Ket qua goi van y het Lab 8 (scoreboard chua nhan gi).

   Buoc 2.  Them [RTB-3] -- bon dong connect.
            Chay. Gio bon ham write_* phai in ra.
            Dem: so lan write_yapp = so goi gui?
                 so lan write_chan* = so goi thu?

   Buoc 3.  Viet write_yapp day du  [SB-10]
            - CLONE, roi push vao queue theo addr
            Chay. Them `uvm_info in sb_queue0.size() sau moi lan push
            de thay hang doi lon dan.

   Buoc 4.  Viet write_chan0 day du  [SB-11] voi comp_equal (da cho san)
            Chay. Gio moi co so sanh that.
            *** DAT compare_policy = EQUALITY o buoc nay ***

   Buoc 5.  Chep sang write_chan1, write_chan2  [SB-12]
            Chay. Ba kenh deu so sanh.

   Buoc 6.  Viet check_phase va report_phase  [SB-13, SB-14]
            Chay. Phai thay dong "Simulation PASSED".

   Buoc 7.  Viet comp_uvm  [SB-9] va doi compare_policy = UVM
            Chay lai. So sanh thong bao loi cua hai cach.


===============================================================================
PHAN 5 -- DAU HIEU TRONG LOG KHI LAM XONG
===============================================================================

Chay:  xrun -f run.f +UVM_TESTNAME=test_mc -l log9a.log

   grep "router_sb"              log9a.log
   -> trong print_topology phai co:
        router_sb    router_scoreboard    -    @xxxx
        sb_yapp_in   uvm_analysis_imp_yapp  ...
        sb_chan0     uvm_analysis_imp_chan0 ...

   grep -c "Added packet to Scoreboard Queue"  log9a.log
   -> can UVM_HIGH moi thay. So nay = so goi YAPP hop le.

   grep -c "Scoreboard Compare Match"   log9a.log
   -> can UVM_MEDIUM. Bang so goi thu duoc o ba kenh.

   grep "Router Scoreboard Empty"       log9a.log
   -> PHAI CO. Neu thay "Queue's NOT Empty" thi co goi bi mat.

   grep "Simulation PASSED\|Simulation FAILED"  log9a.log
   -> dong quan trong nhat cua ca mo phong.

   grep -c "MISCOMPARE"          log9a.log   -> mong doi 0
   grep -c "PKT_COMPARE"         log9a.log   -> mong doi 0
   grep -c "UVM_ERROR"           log9a.log   -> mong doi 0

*** DEM TRUOC KHI CHAY ***
router_simple_mcseq gui: yapp_012 x2 (6 goi) + six_yapp (6 goi) = 12 goi
   write_yapp duoc goi ___ lan
   tong write_chan0 + write_chan1 + write_chan2 = ___ lan
   hai so nay co bang nhau khong? Vi sao?


===============================================================================
PHAN 6 -- *** THI NGHIEM: VI SAO CAN LAB 9B ***
===============================================================================

Sau khi Lab 9A chay sach, lam thi nghiem nay.

Trong test_mc, COMMENT dong type override di:

    //yapp_packet::type_id::set_type_override(short_yapp_packet::get_type());

[Da xac minh] Repo lab09_sba co dung dong nay bi comment, trong khi
lab08_mcseq thi dong nay dang ACTIVE. Day la thay doi CO CHU Y giua
hai lab.

*** DU DOAN TRUOC KHI CHAY ***

Nho lai kich ban router_simple_mcseq:
   1. HBUS ghi MAXPKTSIZE = 20
   2-5. YAPP gui 6 goi
   6. HBUS ghi MAXPKTSIZE = 63
   7-9. YAPP gui 6 goi nua

Khong co short_yapp_packet thi length co the toi 63.

   (a) Buoc 2-5: goi dai hon 20 byte -> router lam gi?  ______
   (b) Scoreboard co biet dieu do khong?               ______
   (c) sb_queue co rong luc check_phase khong?         ______
   (d) Log se bao gi?                                  ______

Chay va doi chieu:
   grep "Queue's NOT Empty"      log9a_nolimit.log
   grep "Simulation FAILED"      log9a_nolimit.log

[Suy luan] Toi cho rang scoreboard se bao "Queue's NOT Empty" va
"Simulation FAILED", VI scoreboard day moi goi vao hang doi ma khong
biet router da drop mot so. Toi chua chay thi nghiem nay nen khong
khang dinh con so cu the.

*** DAY CHINH LA DE BAI CUA LAB 9B ***
Slide 22: "Lab 9B Router Module UVC -- Modify the scoreboard to cater
for the router dropping oversized or disabled packets"

Loi bao o SCOREBOARD nhung nguyen nhan la SCOREBOARD THIEU THONG TIN.
Cach sua: noi them HBUS vao scoreboard de no biet MAXPKTSIZE va
ROUTER_EN hien tai. Do la Lab 9B.


===============================================================================
PHAN 7 -- BAY
===============================================================================

   BAY 1 -- Quen clone  *** NGUY HIEM NHAT ***
   --------------------------------------------------------------------
   SAI:   sb_queue0.push_back(packet);
   DUNG:  $cast(sb_packet, packet.clone());
          sb_queue0.push_back(sb_packet);

   Section 13 slide 17: "write only sends a reference".

   Hau qua: hang doi chua N con tro GIONG NHAU. Goi moi ghi de len
   moi goi da luu. So sanh sai o nhung cho vo ly.

   *** O REPO NAY BAY CO THE KHONG NO ***
   [Da xac minh] channel_rx_monitor.sv co dong:
       // Create separate collected packet instance for every collected packet
       packet_collected = channel_packet::type_id::create("packet_collected", this);
   -> monitor TAO MOI moi vong, nen khong clone van co the chay dung.

   NHUNG VAN PHAI CLONE. Vi sao? Vi scoreboard khong duoc phep gia dinh
   monitor nao cung tu te. Do la hop dong phong thu.

   Thu nghiem: bo clone di, chay, xem co hong khong. Neu khong hong,
   ban vua chung minh duoc rang monitor cua repo cap phat moi -- va
   dong thoi hieu vi sao khong duoc dua vao dieu do.


   BAY 2 -- Quen $cast
   --------------------------------------------------------------------
   SAI:   yapp_packet ypkt = packet.clone();
   DUNG:  $cast(ypkt, packet.clone());

   clone() khai bao tra ve uvm_object (lop co so). Gan thang vao bien
   yapp_packet -> loi bien dich.
   [Da xac minh] Repo co comment: "// Clone returns uvm_object type"


   BAY 3 -- Dau gach duoi trong imp_decl
   --------------------------------------------------------------------
   SAI:   `uvm_analysis_imp_decl(yapp)    -> uvm_analysis_impyapp, writeyapp()
   DUNG:  `uvm_analysis_imp_decl(_yapp)   -> uvm_analysis_imp_yapp, write_yapp()

   Doi so cua macro la HAU TO, phai co gach duoi o dau.


   BAY 4 -- Quen new() cho imp object
   --------------------------------------------------------------------
   Khai bao thoi chua du:
       uvm_analysis_imp_yapp #(yapp_packet, router_scoreboard) sb_yapp_in;
   Phai them trong CONSTRUCTOR:
       sb_yapp_in = new("sb_yapp_in", this);

   Quen -> null pointer khi connect_phase goi connect().

   *** CHU Y: new(), KHONG PHAI type_id::create() ***
   Port va imp khong di qua factory.
   Va dat trong CONSTRUCTOR, khong phai build_phase.


   BAY 5 -- Chieu cua connect()
   --------------------------------------------------------------------
   DUNG:  port.connect(imp)
   SAI:   imp.connect(port)

   Luon goi tu phia PHAT. Nho bang chieu du lieu.


   BAY 6 -- pop_front khi hang doi rong
   --------------------------------------------------------------------
   Neu channel thu duoc goi ma hang doi tuong ung rong -> pop_front()
   tren queue rong la hanh vi khong xac dinh.

   PHAI kiem tra truoc:
       if (sb_queue0.size() == 0) begin
         `uvm_error(...)  // hoac uvm_warning
         dropped_ch0++;
         return;
       end

   [Da xac minh] lab09_sba dung `uvm_error cho truong hop nay;
   lab09_sbb va router/sv dung `uvm_warning. Hai lua chon khac nhau.
   Ban chon cai nao? Vi sao? (Goi y: "goi ra ma khong co goi vao" la
   loi cua DUT hay cua testbench?)


   BAY 7 -- Dung sb_queue0[0] hay pop_front() truoc?
   --------------------------------------------------------------------
   [Da xac minh] Repo dung kieu NHIN TRUOC, POP SAU:

       pktcompare = comp_uvm(sb_queue0[0], packet);   // NHIN, chua lay
       if (pktcompare) begin
         void'(sb_queue0.pop_front());                // khop thi moi LAY
         ...
       end
       else begin
         sb_packet = sb_queue0[0];                    // khong khop -> GIU LAI
         `uvm_warning(... "Expected Channel_0 Packet: %s" ...)
       end

   Vi sao khong pop truoc? Vi khi MISCOMPARE, ban can goi mong doi do
   DE IN RA thong bao loi. Pop truoc roi thi mat.

   Nhung chu y: khong pop khi miscompare -> hang doi KHONG VOI DI ->
   goi tiep theo lai so voi cung mot goi cu. Mot loi se gay ra mot
   chuoi loi. Do la lua chon co y thuc cua tac gia.


===============================================================================
PHAN 8 -- CAU HOI TU KIEM TRA
===============================================================================

 1. Scoreboard KHONG co run_phase, khong co forever, khong co fork.
    No chay bang cach nao? Ai "danh thuc" no?

 2. Slide 14: "Only one uvm_analysis_imp object can be declared in a
    component." Vi sao? (Goi y: imp goi ham ten gi?)

 3. Lab 9A can BON imp. Neu DUT co 8 kenh thi can bao nhieu macro
    imp_decl? Co cach nao gon hon khong?
    (Goi y: xem lab09_sbd dung uvm_tlm_analysis_fifo -- co can
     imp_decl khong?)

 4. write_yapp nhan yapp_packet, write_chan0 nhan channel_packet.
    Hai kieu khac nhau. Vi sao khong dung duoc uvm_object::compare()
    co san cua UVM?

 5. comp_equal dung "return(0)" ngay khi gap loi dau tien.
    comp_uvm dung "&=" va chay het.
    Neu mot goi sai CA addr LAN parity, moi ham bao may loi?
    Khi debug ban muon ham nao?

 6. check_phase bao loi neu hang doi con goi. Dieu do kiem tra cai gi
    ma so sanh tung goi KHONG kiem tra duoc?

 7. report_phase in dong PASSED voi muc UVM_NONE, khong phai UVM_LOW.
    UVM_NONE nghia la gi? Vi sao dong do can muc do?

 8. base_test da co set_drain_time(this, 200ns). Neu bo di, check_phase
    se bao gi? Day la loi cua DUT hay cua testbench?


===============================================================================
PHAN 9 -- TONG KET: LAB 8 -> LAB 9A
===============================================================================

   +-------------------------+-------------------+-------------------+
   |                         | Lab 8             | Lab 9A            |
   +-------------------------+-------------------+-------------------+
   | File moi                | 2 (tb/)           | 1 (sv/)           |
   | Thu muc moi             | khong             | sv/               |
   | Dong them vao run.f     | 0                 | 1 (-incdir ../sv) |
   | Component               | 32                | 33 (+router_sb)   |
   | Sua yapp/ hay channel/  | khong             | KHONG             |
   | Testbench phat hien loi | khong             | CO                |
   | Ket qua cuoi cung       | log day goi       | PASSED / FAILED   |
   +-------------------------+-------------------+-------------------+

   Lab 8 day ban DIEU PHOI nhieu UVC theo mot kich ban.
   Lab 9A day ban KIEM TRA ket qua cua kich ban do.

   Mot testbench chay duoc ma khong kiem tra gi thi khong phai
   testbench -- no la mot cai may phat tin hieu.

===============================================================================
