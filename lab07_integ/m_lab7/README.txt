===============================================================================
LAB 7 -- INTEGRATING MULTIPLE UVCs
Section 11 slide 19: "Connect, configure and test HBUS, Channel and
                      Clock/Reset UVC"
Slide ghi them: "None of these UVCs use configuration objects"
===============================================================================

*** DIEU KHAC BIET LON NHAT CUA LAB 7 ***

Ban KHONG viet mot class nao ca.

Khong packet moi. Khong driver moi. Khong monitor moi. Khong sequence moi.
Ba UVC (channel, hbus, clock_and_reset) DA DUOC VIET SAN trong repo.

Lab 7 la bai tap ve QUY TRINH TICH HOP. Ban lam dung MOT viec, lap lai
ba lan:  "lay mot thu muc UVC co san, noi no vao testbench cua minh".

Day la ky nang that su cua mot verification engineer trong du an lon.
Nguoi ta it khi viet UVC moi -- nguoi ta TICH HOP UVC co san.


===============================================================================
PHAN 1 -- QUY TRINH 3+3  (hoc thuoc bang nay)
===============================================================================

Moi UVC moi can dung 6 thay doi, chia ba nhom, o ba file:

   NHOM A -- run.f  (3 dong, bien dich)
     A1.  -incdir  <uvc>/sv              <- de `include tim duoc file
     A2.  <uvc>/sv/<uvc>_pkg.sv          <- package
     A3.  <uvc>/sv/<uvc>_if.sv           <- interface (RIENG, sau package)

   NHOM B -- hai module top  (3 dong, noi day)
     B1.  hw_top.sv  : instantiate interface, noi vao port DUT
     B2.  tb_top.sv  : import <uvc>_pkg::*;
     B3.  tb_top.sv  : <uvc>_vif_config::set(null, "<path>", "vif", hw_top.<inst>);

   (va mot dong thu 7 o router_tb.sv: khai + create UVC env)


*** BANG LAM VIEC -- in ra, tick tung o khi lam xong ***

   +------------------+---------+--------+--------+---------+----------+
   | buoc             | yapp    | channel| hbus   | clk_rst | ghi chu  |
   |                  | (da co) | (moi)  | (moi)  | (moi)   |          |
   +------------------+---------+--------+--------+---------+----------+
   | A1 -incdir       |   [x]   |  [ ]   |  [ ]   |   [ ]   | RUN-1    |
   | A2 _pkg.sv       |   [x]   |  [ ]   |  [ ]   |   [ ]   | RUN-2    |
   | A3 _if.sv        |   [x]   |  [ ]   |  [ ]   |   [ ]   | RUN-2    |
   | B1 hw_top inst   |   [x]   |  [ ]x3 |  [ ]   |   [ ]   | HW-2..4  |
   | B2 tb_top import |   [x]   |  [ ]   |  [ ]   |   [ ]   | TB-1     |
   | B3 tb_top vif set|   [x]   |  [ ]x3 |  [ ]   |   [ ]   | TB-2     |
   | C  router_tb env |   [x]   |  [ ]x3 |  [ ]   |   [ ]   | RTB-2..4 |
   +------------------+---------+--------+--------+---------+----------+

   Channel co COT x3 vi co BA kenh ra (chan0, chan1, chan2) -- ba instance
   cua CUNG MOT UVC. Day chinh la y nghia cua chu "reusable".


===============================================================================
PHAN 2 -- BAN DO FILE
===============================================================================

Tao thu muc lab07_my/ canh lab06_my/ cua ban:

   lab07_my/
     tb/
       run.f                <- RUN-1..4     (sua tu Lab 6)
       hw_top.sv            <- HW-1..6      (sua NHIEU tu Lab 6)
       tb_top.sv            <- TB-1..3      (sua tu Lab 6)
       router_tb.sv         <- RTB-1..6     (sua tu Lab 6)
       router_test_lib.sv   <- xem file PATCH
       clkgen.sv            <- CHO SAN, CHEP DE  *** DOI SO VOI LAB 6 ***

   KHONG co thu muc sv/ nua.

*** CHU Y CAU TRUC THU MUC ***
Tu Lab 7, testbench dung YAPP UVC tu thu muc DUNG CHUNG:

   <repo>/
     yapp/sv/                 <- UVC YAPP        (da hoan chinh sau Lab 6)
     channel/sv/              <- UVC Channel     (co san)
     hbus/sv/                 <- UVC HBUS        (co san)
     clock_and_reset/sv/      <- UVC Clock/Reset (co san)
     router_rtl/              <- DUT
     lab07_my/tb/             <- cho ban lam viec

Khong con chep yapp/sv/ vao tung lab nua. Mot ban YAPP, bon testbench dung.
Do la UVC. (Section 11 slide 4)

*** DOI CHIEU VOI LOI GIAI ***
Repo co san lab07_integ/. [Suy luan] Dua vao viec no co du ca bon UVC,
ca sau lenh vif set, va router_tb.sv day du nam UVC env, toi cho rang
lab07_integ LA LOI GIAI cua Lab 7, khong phai diem xuat phat.
(Khac voi lab06_vif -- cai do la diem xuat phat cua Lab 6, ta da xac minh
 bang log hom truoc.)

=> Tu viet truoc. Chi mo lab07_integ khi ket, hoac de doi chieu sau cung.


===============================================================================
PHAN 3 -- BA UVC MOI LA GI
===============================================================================

   CHANNEL UVC   -- ba kenh RA cua router
   -----------------------------------------------------------------
   DUT day goi ra tren mot trong ba kenh. Ai nhan? Channel UVC.
   No vua la NGUOI NHAN (rx_monitor thu goi ra) vua la NGUOI PHAN HOI
   (rx_driver keo tin hieu suspend len xuong, gia lam mot thiet bi
   luc ban luc ranh).

   Ba instance: chan0, chan1, chan2.
   Moi instance phai biet NO LA KENH SO MAY -> config "channel_id".

   [Da xac minh] channel/sv/channel_rx_monitor.sv co dong:
       if (packet_collected.addr != channel_id)
         `uvm_error("CHANNEL_ID", ...)
   => Day la cai kiem tra DAU TIEN cua testbench: router co dinh tuyen
      dung khong. Dat sai channel_id -> bao loi ngay.


   HBUS UVC      -- bus cau hinh thanh ghi cua router
   -----------------------------------------------------------------
   Router co thanh ghi ben trong (vd: bat/tat kenh, dat che do).
   HBUS la bus de GHI/DOC cac thanh ghi do. Khong lien quan luong goi.

   Khac hai UVC kia o mot diem: no la UVC co NHIEU AGENT.
   Config "num_masters" va "num_slaves" quyet dinh tao bao nhieu.
   Lab 7: 1 master, 0 slave (testbench lam master, router lam slave).

   Hau qua cu phap: sequencer cua no khong phai "hbus.sequencer" ma la
       hbus.masters[0].sequencer
                ^^^^^^^^^^  mang


   CLOCK_AND_RESET UVC  -- thay the clkgen thu cong
   -----------------------------------------------------------------
   *** DAY LA UVC LAM BAN BAT NGO NHAT ***

   O Lab 6, clock va reset do clkgen.sv tu sinh, cung nhac trong code.
   Muon doi chu ky clock -> sua file Verilog, bien dich lai.

   Tu Lab 7: clock va reset tro thanh MOT TRANSACTION.
   Mot sequence gui mot transaction noi "clock_period = 10, reset_delay = 5,
   run_clock = 1", driver cua UVC nay lai hai tin hieu run_clock va
   clock_period, clkgen chi lam theo.

   [Da xac minh] clock_and_reset/sv/clock_and_reset_seq.sv:
       class clk10_rst5_seq extends uvm_sequence #(clock_and_reset_sequence_item);
         ...
         cr.clock_period = 10;
         cr.reset_delay  = 5;
         cr.run_clock    = 1;
         `uvm_send(cr)
         #300ns;
       endtask

   => Doi chu ky clock gio la doi MOT SO trong sequence, hoac tham chi
      randomize no. Khong bien dich lai phan cung.

   Day la ly do clkgen.sv PHAI DOI (xem file clkgen.sv cho san).


===============================================================================
PHAN 4 -- THU TU LAM  (dung nhay coc)
===============================================================================

   Buoc 0.  Chep lab06_my/tb/* sang lab07_my/tb/
            Xac nhan Lab 6 van chay dung tu thu muc moi (sua duong dan
            tuong doi trong run.f neu can). Co diem xuat phat SACH.

   Buoc 1.  THAY clkgen.sv bang ban moi (cho san trong skeleton nay).
            Chay lai. *** SE HONG ***  -- vi chua ai lai run_clock.
            Du doan truoc: hong the nao? Treo hay bao loi?
            Ghi du doan ra giay, roi chay, roi doi chieu.

   Buoc 2.  Them CLOCK_AND_RESET UVC (6 buoc A1..B3 + C).
            Them clk10_rst5_seq vao test.
            Chay lai. Phai tro lai nhu Lab 6: 10 goi gui, 10 goi thu.
            *** Dung sang buoc 3 khi chua qua buoc nay. ***

   Buoc 3.  Them CHANNEL UVC x3 (A1..A3 mot lan, B1 ba lan, B3 ba lan,
            C ba lan + config channel_id).
            Chay lai. Gio moi co "Packet Collected" o PHIA RA.

   Buoc 4.  Them HBUS UVC.
            Chay lai.

   Buoc 5.  Viet simple_test (xem router_test_lib_PATCH.txt).

   *** VI SAO PHAI CHIA NAM BUOC? ***
   Them ca ba UVC mot luc roi chay -> 40 loi bien dich cung luc, khong
   biet loi nao gay loi nao. Them tung cai -> moi lan hong chi co mot
   nguyen nhan.
   Day la ky luat lam viec, khong phai loi khuyen cho vui.


===============================================================================
PHAN 5 -- DAU HIEU TRONG LOG  (dung de biet minh dang o dau)
===============================================================================

   Sau buoc 2 (clock_and_reset):
     UVM_INFO ... [clk10_rst5_seq] Starting test_sequence sequence body
     ... driver sent 10 packets
     ... Monitor Collected 10 Packets
     (giong het Lab 6 -- clock gio do UVC lai, nhung ket qua khong doi)

   Sau buoc 3 (channel):
     Xuat hien dong thu goi o PHIA RA, tu channel_rx_monitor.
     [Chua xac minh] Toi chua doc het channel_rx_monitor.sv nen khong
     biet chinh xac chuoi ID no in ra. Ban tu grep:
         grep -n "uvm_info\|uvm_error" ../../channel/sv/channel_rx_monitor.sv

     Neu channel_id dat sai -> UVM_ERROR [CHANNEL_ID].

   Sau buoc 4 (hbus):
     [Chua xac minh] Toi chua doc hbus/sv/. Ban tu kiem:
         ls ../../hbus/sv/
         grep -rn "class.*extends uvm_sequence" ../../hbus/sv/

   *** MOT DIEU PHAI TU TRA LOI TRUOC KHI CHAY ***
   Co bao nhieu sequence chay song song o simple_test? Cai nao ket thuc,
   cai nao chay mai? Cai nao raise objection?
   (Goi y: channel_rx_resp_seq phai phan hoi MAI -- no khong the dung
    truoc khi goi cuoi cung di qua. Vay no co duoc phep raise objection
    khong?)


===============================================================================
PHAN 6 -- BAY
===============================================================================

   BAY 1 -- Quen -incdir
   ------------------------------------------------------------------
   Loi bien dich: "cannot find include file channel_packet.sv".
   De sua. Nhung chu y: loi bao ten FILE BI INCLUDE, khong bao ten
   package dang bien dich. Doc ky xem no dang o trong package nao.


   BAY 2 -- Interface truoc package
   ------------------------------------------------------------------
   channel_if.sv co "import channel_pkg::*;" -> package phai di TRUOC.
   Dao thu tu -> loi "channel_pkg not found".
   Luat nay giong het Lab 6 (RUN-1), chi la lap lai ba lan.


   BAY 3 -- Duong dan vif sai mot ky tu
   ------------------------------------------------------------------
   Day la bay HAY GAP NHAT cua Lab 7, vi gio co SAU duong dan.

       "*.tb.chan0.*"     <- dung neu handle ten chan0
       "*.tb.chan_0.*"    <- sai, nhung KHONG CO LOI BIEN DICH

   Hau qua: mot UVC khong lay duoc vif -> UVM_ERROR [NOVIF] hoac treo.

   Cach bat nhanh nhat:
       (a) print_topology() -- xem ten THAT cua cac component
       (b) check_config_usage() -- bao resource co 1 write, 0 read
   Hai cai nay la cap doi. Section 7 slide 11.


   BAY 4 -- Thu tu set/create trong router_tb
   ------------------------------------------------------------------
       uvm_config_int::set(this, "chan0", "channel_id", 0);   <- TRUOC
       chan0 = channel_env::type_id::create("chan0", this);   <- SAU

   Dao lai -> chan0 build_phase chay truoc khi config co trong kho
            -> channel_id giu gia tri mac dinh (co the la 0 cho ca ba)
            -> ca ba kenh deu nghi minh la kenh 0
            -> UVM_ERROR [CHANNEL_ID] tren hai trong ba kenh.

   Luat nay ban da gap o Lab 4 (TEST-*). Gio no quay lai, kho bat hon,
   vi loi khong o cho ban go sai ma o THU TU hai dong.


   BAY 5 -- suspend_0/1/2 van con buoc ve 1'b0
   ------------------------------------------------------------------
   O Lab 6 ban buoc chung ve 0 vi chua co Channel UVC.
   Gio co roi -> phai noi vao ch0.suspend / ch1.suspend / ch2.suspend.
   Quen -> Channel UVC lai suspend nhung DUT khong thay
        -> kenh khong bao gio ban -> test van "chay dung" nhung ban
           chua he kiem tra flow control.
   Day la loi KHONG BAO GI CA. Nguy hiem nhat trong nam bay.


   BAY 6 -- .hdata(hif.hdata_w)   <- chu y hau to _w
   ------------------------------------------------------------------
   [Da xac minh tu lab08_mcseq/tb/hw_top.sv] DUT noi vao hif.hdata_w,
   KHONG phai hif.hdata.

   Vi sao? Section 10 slide 14: hdata la bus HAI CHIEU. Mot bien logic
   trong interface khong lam duoc hai chieu -- can mot wire rieng.
   Mo channel_if.sv / hbus_if.sv ra doc phan khai bao, tu tim xem
   hbus_if dinh nghia hdata_w nhu the nao.
       grep -n "hdata" ../../hbus/sv/hbus_if.sv

   Go thanh .hdata(hif.hdata) -> co the bien dich duoc, nhung du lieu
   doc ve se sai hoac 'z.


===============================================================================
PHAN 7 -- CAU HOI TU KIEM TRA  (tra loi truoc khi mo lab07_integ)
===============================================================================

 1. Lab 7 them BA UVC. Tong cong them bao nhieu dong vao run.f?
    (Dem theo quy tac 3 dong/UVC -- nhung co cho nao khong phai 3 khong?)

 2. Co BA instance channel_env (chan0/1/2) nhung chi THEM BA dong vao
    run.f cho channel, khong phai chin. Vi sao?

 3. Co BA instance channel_env nhung co BAO NHIEU lenh
    channel_vif_config::set trong tb_top? Vi sao con so nay khac cau 2?

 4. Trong tb_top, lenh set cho clock_and_reset la:
        clock_and_reset_vif_config::set(null, "*.tb.clock_and_reset*", "vif", ...)
    Chu y KHONG co dau cham truoc dau sao cuoi: "clock_and_reset*"
    chu khong phai "clock_and_reset.*".
    Hai cai nay khac nhau the nao? Cai nao khop duoc component ten
    "clock_and_reset" (chinh no)? Cai nao chi khop con cua no?

 5. hbus duoc cau hinh num_masters=1, num_slaves=0.
    Neu DUT la slave that, vi sao testbench khong can slave agent?
    Neu doi thanh num_slaves=1 thi chuyen gi xay ra?

 6. simple_test dat default_sequence cho BA sequencer:
        tb.yapp.tx_agent.sequencer
        tb.clock_and_reset.agent.sequencer
        tb.chan?.rx_agent.sequencer
    Nhung KHONG dat cho hbus. Vi sao? Lab 7 co can gui giao dich HBUS
    nao khong?

 7. Dau "?" trong "tb.chan?.rx_agent.sequencer.run_phase" khop duoc may
    component? Neu doi thanh "*" thi co gi khac? Neu doi thanh
    "tb.chan0.rx_agent.sequencer.run_phase" thi phai viet may dong?

 8. clkgen moi co port run_clock. Neu clock_and_reset UVC khong chay
    sequence nao (quen dong uvm_config_wrapper::set cho no), run_clock
    bang gi? clock co dao khong? Mo phong se the nao?
    *** Du doan truoc, roi thu that bang cach comment dong do lai. ***


===============================================================================
PHAN 8 -- TONG KET: SO SANH LAB 6 VA LAB 7
===============================================================================

   +----------------------+---------------------+---------------------------+
   |                      | Lab 6               | Lab 7                     |
   +----------------------+---------------------+---------------------------+
   | So UVC               | 1 (yapp)            | 4                         |
   | So interface         | 1                   | 6 (yapp,ch0,ch1,ch2,      |
   |                      |                     |    hbus, clk_rst)         |
   | So lenh vif set      | 1                   | 6                         |
   | So env trong router_tb| 1                  | 5                         |
   | Clock tu dau         | clkgen cung nhac    | clock_and_reset UVC       |
   | Class moi phai viet  | driver, monitor, if | KHONG CO                  |
   | Ky nang chinh        | noi phan mem-phan   | tich hop UVC co san       |
   |                      | cung                |                           |
   +----------------------+---------------------+---------------------------+

   Lab 6 day ban LAM RA mot UVC.
   Lab 7 day ban DUNG LAI UVC nguoi khac lam.
   Trong nghe, viec thu hai nhieu hon viec thu nhat rat nhieu.

===============================================================================
