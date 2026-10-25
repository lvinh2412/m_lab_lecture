===============================================================================
LAB 8 -- WRITING MULTICHANNEL SEQUENCES AND SYSTEM-LEVEL TESTS
Section 12 slide 16:
  "Modify Lab 7 to add a multichannel sequencer and execute HBUS and YAPP
   sequences"
===============================================================================

*** LAB 8 KHAC LAB 7 O DIEM GI ***

  Lab 7:  khong viet class nao. Chi tich hop UVC co san.
  Lab 8:  viet HAI class moi.   Lan dau tro lai viet code tu Lab 6.

Nhung hai class do RAT NGAN:
  - router_mcsequencer  : 10 dong, khong co logic
  - router_simple_mcseq : than ham la 8 lenh `uvm_do_on

Cai kho cua Lab 8 khong phai go code. Cai kho la hieu DUNG ba thu:
  (1) vi sao sequencer ao khong co #(T) va khong co driver
  (2) khi nao dung `uvm_do_on, khi nao dung `uvm_do
  (3) vi sao phai XOA default_sequence cu di


===============================================================================
PHAN 1 -- QUY TRINH 4 BUOC (Section 12 slide 8, nguyen van)
===============================================================================

  1. Declare a multichannel sequencer component
       - Derive from uvm_sequencer like a normal sequencer
       - Contain one or more references to UVC sequencer instances

  2. Declare multichannel sequences
       - Contain references for UVC interface sequences (that will be invoked)
       - Sequences are activated using `uvm_do_on(), selecting a UVC
         sequencer reference

  3. In the testbench
       - Create the multichannel sequencer instance
       - Connect the sequencer references to actual UVC sequencer instances

  4. In the test class
       - Set the sequence of the multichannel sequencer to the required choice
       - Remove any default_sequence setting for the UVC
           * Control is no longer local


Bon buoc = bon file:

   +-------+-------------------------------+------------------+
   | buoc  | file                          | trang thai       |
   +-------+-------------------------------+------------------+
   |   1   | tb/router_mcsequencer.sv      | *** FILE MOI *** |
   |   2   | tb/router_mcseqs_lib.sv       | *** FILE MOI *** |
   |   3   | tb/router_tb.sv               | sua              |
   |   4   | tb/router_test_lib.sv         | sua              |
   |  (+)  | tb/tb_top.sv                  | sua, 2 dong      |
   |  (+)  | tb/run.f                      | sua, 1 dong      |
   +-------+-------------------------------+------------------+

*** run.f KHONG THEM FILE NAO ***
Hai file moi di vao compiler qua `include cua tb_top.sv, giong het
router_tb.sv va router_test_lib.sv. Chi dong +UVM_TESTNAME doi.


===============================================================================
PHAN 2 -- BAN DO FILE
===============================================================================

   lab08_my/
     tb/
       run.f                   <- [RUN-1]    doi mot dong
       clkgen.sv               <- giu nguyen tu Lab 7
       hw_top.sv               <- giu nguyen
       tb_top.sv               <- [TB-1]     them 2 dong `include
       router_mcsequencer.sv   <- [MCS-1..3]   FILE MOI
       router_mcseqs_lib.sv    <- [SEQ-1..12]  FILE MOI
       router_tb.sv            <- [RTB-1..3]
       router_test_lib.sv      <- [TEST-1..5]

Khong co thu muc sv/. Bon UVC van nam ngoai, dung chung, khong dong toi.

*** DOI CHIEU VOI LOI GIAI ***
Repo co lab08_mcseq/. [Suy luan] Dua vao viec no co du ca hai file moi,
co connect_phase day du, va co test_mc hoan chinh, toi cho rang day LA
LOI GIAI cua Lab 8.
=> Tu viet truoc. Chi mo khi ket.


===============================================================================
PHAN 3 -- THU TU LAM (SAU buoc, dung nhay coc)
===============================================================================

   Buoc 0.  Chep lab07_my/tb/* sang lab08_my/tb/
            Chay lai simple_test. Phai ra ket qua y het Lab 7.
            Co diem xuat phat SACH.

   Buoc 1.  Viet router_mcsequencer.sv  [MCS-1..3]
            Them 1 dong `include vao tb_top.sv  (nua dau cua [TB-1])
            Them handle + create vao router_tb.sv  [RTB-1, RTB-2]
            *** CHUA viet connect_phase ***
            Chay simple_test.
            -> print_topology() phai hien them mot dong "mcsequencer".
            -> Ket qua goi van y het Lab 7 (mcsequencer chua lam gi).

   Buoc 2.  Them connect_phase vao router_tb.sv  [RTB-3]
            Chay lai. Van y het buoc 1 -- chua ai dung hai con tro do.
            Buoc nay khong doi gi ve hanh vi. Dung bo qua: no la buoc
            DE SAI nhat, va sai o day thi buoc 4 moi no.

   Buoc 3.  Viet router_mcseqs_lib.sv voi than ham TOI THIEU:
            chi MOT lenh `uvm_do_on(hbus_small_pkt, ...)   [SEQ-1..8]
            Them dong `include thu hai vao tb_top.sv  (nua sau [TB-1])
            Chay simple_test. Van chua co gi doi -- chua ai goi mcseq.

   Buoc 4.  *** THI NGHIEM CO CHU Y -- dung bo qua ***
            Viet test_mc  [TEST-1..4] nhung CO TINH GIU NGUYEN dong
            default_sequence cu cua YAPP.
            Chay. Doc ky log. Ghi lai so goi.
            (Xem PHAN 5 -- du doan truoc khi chay)

   Buoc 5.  XOA dong default_sequence cua YAPP  [TEST-5]
            Chay lai. So sanh voi buoc 4.
            Bay gio ban hieu vi sao slide 8 buoc 4 noi "Remove any
            default_sequence setting for the UVC".

   Buoc 6.  Viet day du than ham 8 lenh  [SEQ-9..12]
            Chay. Doi chieu voi PHAN 6.


===============================================================================
PHAN 4 -- KICH BAN TEST THAT SU LA GI
===============================================================================

Than ham day du cua router_simple_mcseq, dich ra tieng Viet:

   1. HBUS : ghi thanh ghi -- goi toi da 20 byte, bat router
   2. HBUS : doc lai MAXPKTSIZE de xac nhan
   3. IN   : gia tri vua doc duoc
   4. YAPP : gui 3 goi toi kenh 0, 1, 2
   5. YAPP : gui 3 goi nua toi kenh 0, 1, 2
   6. HBUS : doi cau hinh -- goi toi da 63 byte
   7. HBUS : doc lai xac nhan
   8. IN   : gia tri vua doc
   9. YAPP : gui 6 goi ngau nhien

*** BUOC 2-3 LA DIEU LAB 7 KHONG LAM DUOC ***

   `uvm_do_on(hbus_rd_maxpkt, p_sequencer.hbus_seqr)
   `uvm_info(..., $sformatf("...: %0h", hbus_rd_maxpkt.max_pkt_reg), UVM_LOW)
                             ^^^^^^^^^^^^^^^^^^^^^^^^^^^^
                             DOC NGUOC tu DUT len kich ban test

Tu Lab 1 den Lab 7, du lieu chi chay MOT CHIEU: test -> DUT.
Dong tren la lan dau du lieu chay NGUOC: DUT -> sequence -> test.

Va no chung minh `uvm_do_on la BLOCKING -- neu khong, dong uvm_info
se in ra gia tri cu hoac rac.


===============================================================================
PHAN 5 -- THI NGHIEM BUOC 4  (du doan TRUOC khi chay)
===============================================================================

O buoc 4 ban co:

   test_mc:
     uvm_config_wrapper::set(this, "tb.yapp.tx_agent.sequencer.run_phase",
                             "default_sequence", yapp_012_seq::get_type());  <- CU
     uvm_config_wrapper::set(this, "tb.mcsequencer.run_phase",
                             "default_sequence", router_simple_mcseq::get_type());

   va router_simple_mcseq lai goi `uvm_do_on(..., p_sequencer.yapp_seqr)

=> YAPP sequencer nhan sequence tu HAI nguon cung luc.

*** TRA LOI RA GIAY TRUOC KHI CHAY ***

  (a) Co UVM_ERROR nao khong? Vi sao co / vi sao khong?

  (b) So goi YAPP gui di la bao nhieu?
      yapp_012_seq       = ___ goi
      router_simple_mcseq = ___ goi (dem tu PHAN 4)
      tong               = ___ goi

  (c) Thu tu goi the nao? Hai sequence chay xen ke, hay cai nay xong
      cai kia? (Goi y: sequencer co co che arbitration, moi item duoc
      cap phat rieng)

  (d) Co bao nhieu cap raise/drop objection?

  (e) check_config_usage() co bao gi khong?

Chay, roi doi chieu:

   grep -c "Sending Packet"   log8_step4.log
   grep -c "raise objection"  log8_step4.log
   grep -c "UVM_ERROR"        log8_step4.log
   grep    "yapp_012_seq\|router_simple_mcseq" log8_step4.log | head -20

[Suy luan] Toi cho rang se KHONG co UVM_ERROR nao, vi gui nhieu sequence
toi mot sequencer la hop le trong UVM. Toi chua chay thu nghiem nay nen
khong khang dinh chi tiet thu tu. Ban ghi lai ket qua that.

Sau do xoa dong CU di (buoc 5) va chay lai -> so sanh hai log.


===============================================================================
PHAN 6 -- DAU HIEU TRONG LOG KHI LAM XONG
===============================================================================

Chay:  xrun -f run.f +UVM_TESTNAME=test_mc -l log8.log

   grep "mcsequencer"           log8.log
   -> phai co dong trong print_topology:
      mcsequencer    router_mcsequencer    -    @xxxx

   grep "raise objection"       log8.log
   -> mong doi: 1   (chi router_simple_mcseq, vi no la root duy nhat)

   grep "Executing router_simple_mcseq"  log8.log
   -> 1 dong

   grep -c "Sending Packet"     log8.log
   -> dem tu PHAN 4: 3 + 3 + 6 = 12 goi

   grep "MAXPKTSIZE register read"  log8.log
   -> 2 dong, hai gia tri KHAC NHAU (20 roi 63 -- xem o dang hex)

   grep "CHANNEL_ID"            log8.log
   -> mong doi: 0

   grep "UVM_ERROR"             log8.log
   -> mong doi: 0

*** DAU HIEU QUAN TRONG NHAT -- ky hieu @@ ***

   grep "@@router_simple_mcseq"  log8.log

Ban se thay nhung dong kieu:

   uvm_test_top.tb.hbus.masters[0].sequencer@@router_simple_mcseq.hbus_small_pkt
   `--------- CHAY TREN sequencer nay --------'  `--- THUOC chuoi seq nay ---'

Dau @@ ngan CHO CHAY voi CHUOI SO HUU. Day chinh la hinh slide 7 hien
ra trong log: mui ten dut net = dau @@.


===============================================================================
PHAN 7 -- BAY
===============================================================================

   BAY 1 -- create() con tro sequencer trong build_phase
   --------------------------------------------------------------------
   SAI:  yapp_seqr = yapp_tx_sequencer::type_id::create("yapp_seqr", this);
   DUNG: mcsequencer.yapp_seqr = yapp.tx_agent.sequencer;   (connect_phase)

   Slide 9 ghi ro: "Do NOT create these in build".

   Hau qua neu lam sai: tao ra mot sequencer THU HAI, mo coi, khong co
   driver nao ngoi dau kia. `uvm_do_on chay tren no -> start_item() goi
   wait_for_grant() -> cho mai mai -> TREO, 0 goi, khong loi.

   Cach tu bat: print_topology(). Neu thay mot "sequencer" nam DUOI
   mcsequencer thi ban dinh bay nay.


   BAY 2 -- `uvm_do thay vi `uvm_do_on
   --------------------------------------------------------------------
   SAI:  `uvm_do(hbus_small_pkt)
   DUNG: `uvm_do_on(hbus_small_pkt, p_sequencer.hbus_seqr)

   `uvm_do chay tren m_sequencer = mcsequencer, ma mcsequencer khong co
   driver -> treo, giong het bay 1.

   QUY TAC NHO:
      _on     = DI XUONG UVC
      khong _on = O LAI mcsequencer (chi dung cho mcseq long nhau)


   BAY 3 -- Quen connect_phase
   --------------------------------------------------------------------
   hbus_seqr va yapp_seqr van la null.
   `uvm_do_on(seq, null) -> null pointer dereference luc chay.
   Cai nay CO bao loi, nhung thong bao kho doc. Doc ky ten file va
   so dong trong stack trace.


   BAY 4 -- Quen `uvm_declare_p_sequencer
   --------------------------------------------------------------------
   Khong co bien ten p_sequencer -> LOI BIEN DICH.
   Day la bay DE NHAT trong bon, vi compiler bat duoc ngay.


   BAY 5 -- Ten khong khop giua router_tb va test
   --------------------------------------------------------------------
   Slide 13 dat ten handle la "mcseqr".
   Repo dat ten la "mcsequencer".

   Doi chieu PHAI khop ba cho:
      router_tb:  router_mcsequencer mcsequencer;
      router_tb:  ...::create("mcsequencer", this);
      test_mc:    "tb.mcsequencer.run_phase"

   Lech mot cho -> config khong khop component nao -> mcseq KHONG CHAY
   -> mo phong ket thuc gan nhu ngay lap tuc, 0 goi, KHONG LOI NAO.

   Cach tu bat: check_config_usage() se in ra resource "default_sequence"
   co ghi ma khong ai doc.


   BAY 6 -- Thu tu `include trong tb_top.sv
   --------------------------------------------------------------------
   Phai theo dung thu tu:

      `include "router_mcsequencer.sv"    <- TRUOC
      `include "router_mcseqs_lib.sv"     <- SAU  (co uvm_declare_p_sequencer
                                                   (router_mcsequencer))
      `include "router_tb.sv"             <- SAU NUA (khai router_mcsequencer
                                                      mcsequencer;)
      `include "router_test_lib.sv"       <- CUOI (khai router_tb tb;)

   Dao bat ky cap nao -> loi "... is not declared".
   Day la luat cu tu Lab 6: sau khi `include dan chu, moi thu thanh MOT
   file tuyen tinh, class phai khai truoc khi dung.


===============================================================================
PHAN 8 -- CAU HOI TU KIEM TRA (tra loi truoc khi mo lab08_mcseq)
===============================================================================

 1. router_mcsequencer extends uvm_sequencer, KHONG co #(T).
    Neu viet extends uvm_sequencer #(yapp_packet) thi:
       - co bien dich duoc khong?
       - co chay duoc khong?
       - sai o dau ve mat khai niem?

 2. router_simple_mcseq goi `uvm_do_on(yapp_012, ...) HAI LAN voi cung
    mot handle yapp_012. Buoc 1 trong 7 buoc cua `uvm_do la gi?
    Vay hai lan do dung CHUNG mot doi tuong hay HAI doi tuong khac nhau?

 3. test_mc dat default_sequence cho ba cho:
       tb.clock_and_reset.agent.sequencer
       tb.mcsequencer
       tb.chan?.rx_agent.sequencer
    Nhung KHONG dat cho tb.yapp va tb.hbus. Vi sao?
    Ba cho duoc dat co diem gi chung?

 4. Trong log co dung MOT cap raise/drop objection, du than ham co 8 lenh
    `uvm_do_on. Luat nao tu Section 9 giai thich dieu nay?

 5. base_test da co san:
       task run_phase(uvm_phase phase);
         uvm_objection obj = phase.get_objection();
         obj.set_drain_time(this, 200ns);
       endtask
    Slide 12 noi "Check you have a drain time specified in the testbench".
    Neu BO dong do di, goi nao bi mat? O phia nao -- YAPP monitor hay
    channel monitor? Vi sao?

 6. mcsequencer nam NGANG HANG voi cac UVC env trong router_tb, khong
    nam tren chung. Neu dat no THANH CON cua yapp_env thi sao -- con
    chay duoc khong? Co gi sai ve mat kien truc?

 7. Ba Channel UVC va Clock/Reset UVC khong co con tro trong
    router_mcsequencer. Comment trong file goc giai thich vi sao.
    Doc comment do, roi tu tra loi: khi nao thi PHAI them con tro cho
    mot UVC vao sequencer ao?


===============================================================================
PHAN 9 -- TONG KET: LAB 7 -> LAB 8
===============================================================================

   +------------------------+---------------------+---------------------+
   |                        | Lab 7               | Lab 8               |
   +------------------------+---------------------+---------------------+
   | File moi               | khong co            | 2                   |
   | File sua               | 4                   | 3                   |
   | Dong them vao run.f    | 8                   | 0                   |
   | Component              | 31                  | 32 (+mcsequencer)   |
   | connect_phase o router_tb | khong co         | CO                  |
   | So sequence chay       | 5 doc lap           | 1 root + 8 con      |
   | Thu tu giua cac UVC    | KHONG co            | CO                  |
   | Doc du lieu tu DUT     | khong               | CO (max_pkt_reg)    |
   | Ky nang chinh          | tich hop UVC        | dieu phoi UVC       |
   +------------------------+---------------------+---------------------+

   Lab 7 day ban LAP cac UVC vao cung mot testbench.
   Lab 8 day ban BAT chung lam viec theo mot kich ban co thu tu.

   Do la khac biet giua "testbench chay duoc" va "testbench kiem tra
   duoc mot dieu gi do".

===============================================================================
