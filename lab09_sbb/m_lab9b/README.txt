===============================================================================
LAB 9B -- ROUTER MODULE UVC
Section 13 slide 22:
  "Lab 9B Router Module UVC
   Modify the scoreboard to cater for the router dropping oversized or
   disabled packets"
===============================================================================

*** DIEU BAT NGO NHAT CUA LAB 9B ***

De bai noi "Modify the scoreboard", nhung:

        router_scoreboard.sv  KHONG DOI MOT DONG NAO.

[Da xac minh] lab09_sba/sv/router_scoreboard.sv va lab09_sbb/sv/
router_scoreboard.sv khac nhau DUNG MOT CHO: nhanh EMPTY dung
`uvm_error hay `uvm_warning. Logic loc goi khong nam trong scoreboard
o ca hai ban.

Thay vao do, Lab 9B them MOT COMPONENT MOI dung TRUOC scoreboard:
router_reference. No LOC bot goi truoc khi scoreboard nhin thay.

Day la bai hoc thiet ke quan trong nhat cua ca Section 13.


===============================================================================
PHAN 1 -- VI SAO LAB 9A HONG
===============================================================================

Thi nghiem cuoi Lab 9A: bo type override short_yapp_packet di.

   router_simple_mcseq:
     1. HBUS: MAXPKTSIZE = 20
     2-5. YAPP: 6 goi   <- co goi dai hon 20 byte
     6. HBUS: MAXPKTSIZE = 63
     7-9. YAPP: 6 goi nua

   Router DROP goi dai hon 20 byte -> dung theo thiet ke.
   Scoreboard KHONG BIET dieu do -> van push vao hang doi.
   -> hang doi khong bao gio voi het
   -> check_phase: "Queue's NOT Empty"
   -> Simulation FAILED

*** DUT HOAN TOAN DUNG. SCOREBOARD SAI. ***

Chinh xac hon: scoreboard THIEU THONG TIN. No khong biet router dang
duoc cau hinh the nao.

Cach sua: cho mot component theo doi HBUS, roi dung thong tin do de loc
goi truoc khi dua vao scoreboard.


===============================================================================
PHAN 2 -- BA CHUC NANG THANH HAI CLASS
===============================================================================

Section 13 slide 5:
  "There are three distinct functions in the scoreboard:
     1. Transfer function (reference model)
     2. Expected data storage mechanism
     3. Checking logic"

Lab 9A gop ca ba vao mot class. Lab 9B tach chuc nang (1) ra:

   +----------------------------+----------------------+------------------+
   | chuc nang                  | class                | imp nao          |
   +----------------------------+----------------------+------------------+
   | (1) Transfer / ref model   | router_reference     | _yapp, _hbus     |
   | (2) Expected data store    | router_scoreboard    | (3 queue)        |
   | (3) Checking logic         | router_scoreboard    | _chan0/1/2       |
   +----------------------------+----------------------+------------------+

Va MOT class vo boc ca hai:  router_env  (Module UVC env)

*** DAY LA CAU TRA LOI CHO CAU HOI BAN DA HOI ***
"tai sao router_scoreboard chi co imp cho yapp va chan012, con hbus
 thi sao" -> _hbus nam trong router_reference.

Dem lai toan he: 2 imp (reference) + 4 imp (scoreboard) = 6.


===============================================================================
PHAN 3 -- LUONG DU LIEU MOI
===============================================================================

   LAB 9A:
     yapp monitor  ----------------------> scoreboard.sb_yapp_in  (O)
     chan0 monitor ----------------------> scoreboard.sb_chan0    (O)
     (hbus khong noi)

   LAB 9B:
     yapp monitor --> reference.yapp_in (O) --+
                                              |  [LOC 4 nhanh]
     hbus monitor --> reference.hbus_in (O) --+   addr != 3
                                              |   router_enable_reg != 0
                                              |   length <= max_pktsize_reg
                                              v
                             reference.sb_add_out [ ]
                                              |
                                              |  CHI goi "dang le phai ra"
                                              v
                             scoreboard.sb_yapp_in (O)
                                              |
                                        push Q0/Q1/Q2
                                              |
     chan0 monitor -----------------------> scoreboard.sb_chan0 (O) --> pop + so sanh
     chan1 monitor -----------------------> scoreboard.sb_chan1 (O) --> pop + so sanh
     chan2 monitor -----------------------> scoreboard.sb_chan2 (O) --> pop + so sanh

   [ ] = port     (O) = imp

*** HAI THAY DOI VE DAY NOI ***
  (1) YAPP doi DICH: tu scoreboard sang reference
  (2) HBUS duoc noi LAN DAU TIEN

Channel giu nguyen -> van vao thang scoreboard.


===============================================================================
PHAN 4 -- BAN DO FILE
===============================================================================

   lab09b_my/
     sv/
       router_scoreboard.sv    <- CHEP TU LAB 9A, KHONG SUA
       router_reference.sv     <- [REF-1..11]  FILE MOI
       router_module_env.sv    <- [ENV-1..6]   FILE MOI
       router_module_pkg.sv    <- [PKG-1..3]   FILE MOI
     tb/
       run.f                   <- [RUN-1..2]
       clkgen.sv               <- giu nguyen
       hw_top.sv               <- giu nguyen
       tb_top.sv               <- [TB-1..2]
       router_mcsequencer.sv   <- giu nguyen
       router_mcseqs_lib.sv    <- giu nguyen
       router_tb.sv            <- [RTB-1..3]
       router_test_lib.sv      <- [TEST-1..2]

*** BA FILE MOI, MOT FILE CHEP NGUYEN ***


=============================================================================
*** THAY DOI CAU TRUC LON: MODULE UVC THANH MOT PACKAGE ***
=============================================================================

Lab 9A: router_scoreboard.sv vao tb_top bang `include
Lab 9B: ba file sv/ gop thanh MOT PACKAGE, tb_top dung `import

   Lab 9A tb_top:   `include "router_scoreboard.sv"
   Lab 9B tb_top:   import router_module_pkg::*;

[Da xac minh] lab09_sbb/tb/tb_top.sv co dong:
   // import the router module package
   import router_module_pkg::*;

*** VI SAO DOI ***
Section 11 dinh nghia UVC = THU MUC + PACKAGE. Lab 9A moi co thu muc.
Lab 9B dong goi no thanh package -> gio no that su la mot UVC.

Va no duoc liet ke trong run.f nhu bon UVC kia:
   ../sv/router_module_pkg.sv

=> Lan dau mot file CUA BAN duoc liet ke trong run.f ke tu Lab 6.


===============================================================================
PHAN 5 -- THU TU LAM (BAY buoc)
===============================================================================

   Buoc 0.  Chep lab09a_my/ sang lab09b_my/ (ca sv/ lan tb/).
            Chay test_mc. Phai ra PASSED y het Lab 9A.

   Buoc 1.  Viet router_reference.sv  [REF-1..8]
            - hai imp, mot port ra, hai thanh ghi, bon bo dem
            - write_hbus day du
            - write_yapp CHI CO nhanh forward (chua loc)
            Chua noi vao dau ca. Chay. Khong doi gi.

   Buoc 2.  Viet router_module_env.sv ban DON GIAN  [ENV-1..4]
            (chi co reference + scoreboard + mot dong connect,
             CHUA co export)

   Buoc 3.  Viet router_module_pkg.sv  [PKG-1..3]
            Sua tb_top  [TB-1, TB-2]
            Sua run.f   [RUN-1, RUN-2]
            Sua router_tb [RTB-1, RTB-2] -- khai + create router_mod
            CHUA sua connect.
            Chay. print_topology phai hien router_mod + hai con.
            Scoreboard van nhan goi truc tiep tu yapp (day cu).

   Buoc 4.  Sua day noi  [RTB-3]
            - YAPP doi dich: reference.yapp_in
            - HBUS noi moi: reference.hbus_in
            Chay. Phai van PASSED (reference chua loc gi).
            So sanh hai bang thong ke moi xuat hien trong log.

   Buoc 5.  Them BON NHANH LOC vao write_yapp  [REF-9..11]
            Chay. Van PASSED voi short_yapp_packet.

   Buoc 6.  *** PHEP THU QUYET DINH ***
            Bo type override short_yapp_packet trong test  [TEST-2]
            Chay.
            Lab 9A: FAILED.  Lab 9B: phai PASSED.
            Day la bang chung Lab 9B da giai quyet dung van de.

   Buoc 7.  (TUY CHON) Them export vao router_module_env  [ENV-5, ENV-6]
            Doi router_tb noi vao export thay vi noi sau vao ruot.
            Chay. Ket qua y het -- nhung kien truc sach hon.
            Day la bai hoc slide 20.


===============================================================================
PHAN 6 -- DAU HIEU TRONG LOG
===============================================================================

Chay:  xrun -f run.f +UVM_TESTNAME=test_mc -l log9b.log

*** HAI BANG THONG KE, KHONG PHAI MOT ***

   grep -A6 "Router Reference: Packet Statistics"  log9b.log
   -> Packets Dropped / Packets Forwarded / Oversized Packets

   grep -A6 "Scoreboard: Packet Statistics"        log9b.log
   -> Packets In / Channel N Total / Pass / Miscompare / Dropped

*** PHEP KIEM TRA CHEO QUAN TRONG NHAT ***

        reference.packets_forwarded  ==  scoreboard.packets_in

Hai so nay PHAI bang nhau. Neu lech -> day TLM giua hai component
co van de (quen connect, hoac noi nham dich).

Day la loi KHONG BAO GI CA neu ban khong tu doi chieu. Lam thanh thoi
quen: moi lan chay Lab 9B, doi chieu hai so nay truoc tien.

*** CAC NHAN LOC ***

   grep -c "YAPP Packet Dropped \[BAD ADDRESS\]"  log9b.log
   grep -c "YAPP Packet Dropped \[OVERSIZED\]"    log9b.log
   grep -c "YAPP Packet Dropped \[DISABLED\]"     log9b.log
   grep -c "Sent YAPP Packet to Scoreboard"       log9b.log

Bon so nay cong lai phai bang so lan write_yapp duoc goi
= so goi YAPP monitor thu duoc.

*** KET QUA CUOI ***

   grep "Router Scoreboard Empty"  log9b.log      -> PHAI CO
   grep "Simulation PASSED"       log9b.log      -> PHAI CO
   grep -c "UVM_ERROR"            log9b.log      -> mong doi 0


===============================================================================
PHAN 7 -- BAY
===============================================================================

   BAY 1 -- Quen doi DICH cua YAPP
   --------------------------------------------------------------------
   Lab 9A:  yapp...item_collected_port.connect(router_sb.sb_yapp_in);
   Lab 9B:  yapp...item_collected_port.connect(router_mod.reference.yapp_in);

   De NGUYEN dong cu -> scoreboard nhan goi THO (chua loc) -> Lab 9B
   hong y het Lab 9A, va ban se tuong reference khong hoat dong.

   De CA HAI dong -> scoreboard nhan goi HAI LAN (mot tho, mot da loc)
   -> hang doi gap doi -> moi so sanh lech.

   Cach bat: doi chieu reference.packets_forwarded voi
   scoreboard.packets_in. Neu packets_in GAP DOI thi ban de ca hai dong.


   BAY 2 -- Quen noi reference.sb_add_out
   --------------------------------------------------------------------
   Trong router_module_env.connect_phase:
       reference.sb_add_out.connect(scoreboard.sb_yapp_in);

   Quen -> reference loc dung, in log dung, nhung KHONG GUI GI di.
   -> scoreboard.packets_in = 0
   -> moi goi channel toi deu gap hang doi rong
   -> "[EMPTY]: Received Unexpected Channel_0 Packet!" x12

   Trieu chung de nham: trong giong nhu router drop HET moi goi.
   Phan biet: xem reference.packets_forwarded -- neu no > 0 ma
   scoreboard.packets_in == 0 thi loi o day noi, khong o DUT.


   BAY 3 -- Thu tu `include trong router_module_pkg.sv
   --------------------------------------------------------------------
   PHAI theo dung thu tu:
       `include "router_scoreboard.sv"    <- TRUOC
       `include "router_reference.sv"
       `include "router_module_env.sv"    <- CUOI (khai ca hai class tren)

   [Da xac minh] Repo dat dung thu tu do.
   Dao -> loi "... is not declared".
   Luat cu tu Lab 6: `include la dan chu.


   BAY 4 -- Quen import trong router_module_pkg.sv
   --------------------------------------------------------------------
   Package nay can THAY ba kieu transaction:
       import yapp_pkg::*;      // yapp_packet
       import channel_pkg::*;   // channel_packet
       import hbus_pkg::*;      // hbus_transaction

   Thieu dong nao -> loi "yapp_packet is not declared" o file con.

   Chu y: thu tu trong run.f cung phai dung -- ba package kia phai
   bien dich TRUOC router_module_pkg.sv.


   BAY 5 -- Van `include router_scoreboard.sv trong tb_top
   --------------------------------------------------------------------
   Lab 9A co dong do. Lab 9B PHAI XOA no.

   De lai -> class router_scoreboard duoc khai HAI LAN (mot trong
   package, mot trong tb_top) -> loi "duplicate declaration".

   Day la bay CO BAO LOI -- de sua. Nhung thong bao loi co the kho hieu
   vi no bao o file bi include, khong bao o tb_top.


   BAY 6 -- write_hbus phan ung ca voi lenh DOC
   --------------------------------------------------------------------
   [Da xac minh] Repo co dieu kien:
       if (hbus_cmd.hwr_rd == HBUS_WRITE)
         case (hbus_cmd.haddr) ...

   Bo dieu kien do di -> moi giao dich DOC cung ghi de thanh ghi.

   Ma router_simple_mcseq co HAI lenh doc MAXPKTSIZE. Luc doc, truong
   hdata cua transaction chua gia tri DOC VE -- tinh co van dung.
   Nhung neu doc mot dia chi khac thi sao?

   => Luon kiem tra hwr_rd. Doc khong lam doi thanh ghi.


===============================================================================
PHAN 8 -- CAU HOI TU KIEM TRA
===============================================================================

 1. De bai noi "Modify the scoreboard" nhung router_scoreboard.sv khong
    doi dong nao. Giai thich bang khai niem "tach moi quan tam".
    Neu mai router them mot luat drop moi, ban sua file nao?

 2. reference.sb_add_out la PORT (uvm_analysis_port), khong phai imp.
    Vi sao? Doi chieu voi slide 11: ai co port, ai co imp?

 3. router_reference KHONG clone goi truoc khi sb_add_out.write(packet).
    Scoreboard thi CO clone. Dung chua? Neu dao lai (reference clone,
    scoreboard khong) thi hong o dau?
    (Goi y: slide 17 noi clone "before STORAGE" -- ai luu, ai chi
     chuyen tiep?)

 4. router_reference khoi tao max_pktsize_reg = 8'h3F va
    router_enable_reg = 1'b1. Neu test khong gui giao dich HBUS nao,
    reference co loc goi nao khong? Dieu do co khop voi hanh vi router
    sau reset khong? Lam sao kiem chung?

 5. write_yapp cua reference co BON nhanh. Viet lai bon dieu kien do
    thanh mot bang chan ly (addr==3? / enable? / length?) va kiem xem
    co truong hop nao bi bo sot khong.

 6. Lab 9A dung `include cho scoreboard; Lab 9B dung import package.
    Liet ke BA dieu thay doi khi chuyen tu include sang package.
    (Goi y: run.f, tb_top, va... pham vi ten?)

 7. Trong lab09_sbb, router_tb noi thang vao router_mod.reference.yapp_in.
    Trong lab09_sbc, no noi vao router_mod.yapp_in (export).
    Hai cach cho cung ket qua. Cach nao tot hon khi mai ban doi ten
    "reference" thanh "ref_model"? Vi sao?

 8. reference.packets_forwarded phai bang scoreboard.packets_in.
    Neu scoreboard.packets_in = 0 ma packets_forwarded = 10, nguyen
    nhan la gi? Neu packets_in GAP DOI packets_forwarded thi sao?


===============================================================================
PHAN 9 -- TONG KET: LAB 9A -> LAB 9B
===============================================================================

   +----------------------------+------------------+------------------+
   |                            | Lab 9A           | Lab 9B           |
   +----------------------------+------------------+------------------+
   | File moi                   | 1                | 3                |
   | router_scoreboard.sv       | viet moi         | KHONG DOI        |
   | imp tong cong              | 4                | 6                |
   | HBUS noi vao scoreboard?   | khong            | gian tiep (ref)  |
   | Module UVC la package?     | khong            | CO               |
   | Dong trong run.f           | 12               | 13               |
   | Bang thong ke trong log    | 1                | 2                |
   | Component                  | 33               | 36               |
   | Bo short_yapp_packet       | FAILED           | PASSED           |
   +----------------------------+------------------+------------------+

   Lab 9A day ban XAY mot scoreboard.
   Lab 9B day ban rang scoreboard bao FAILED khong co nghia DUT sai.

   Trong du an that, phan lon loi scoreboard ban gap trong tuan dau la
   loi cua MO HINH, khong phai cua DUT. Cau hoi dau tien luon phai la:
   "mo hinh cua toi co dung khong?"

===============================================================================
