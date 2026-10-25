===============================================================================
 LAB 6 -- Connecting to the DUT Using Virtual Interfaces   (SKELETON)
 Section 10 (Connecting to a DUT)
===============================================================================

MUC TIEU (slide 16)
-------------------
  - Sua DRIVER de dung virtual interface
        + them code giao thuc de bom du lieu
  - Sua MONITOR de thu goi tu tin hieu, dung virtual interface
  - Instantiate INTERFACE trong hardware top module
  - Noi virtual interface toi interface vat ly
  - Instantiate DUT trong top testbench

*** DAY LA LAB DAU TIEN CO RTL THAT. ***
Tu Lab 1 den Lab 5, driver chi in ra man hinh roi #10ns.
Tu Lab 6, no lai day that vao router.


===============================================================================
 CHUAN BI
===============================================================================

   mkdir -p lab06_my
   cp -r lab05_my/* lab06_my/
   cd lab06_my

Can them RTL cua router. Trong repo no o:
   router_rtl/yapp_router.sv
Dung duong dan tuong doi trong run.f, khong chep file.


===============================================================================
 BAN DO FILE
===============================================================================

   lab06_my/
   |-- sv/
   |   |-- yapp_packet.sv        giu nguyen
   |   |-- yapp_tx_seqs.sv       giu nguyen  (Lab 5)
   |   |-- yapp_tx_sequencer.sv  giu nguyen
   |   |-- yapp_tx_agent.sv      giu nguyen
   |   |-- yapp_env.sv           giu nguyen
   |   |-- yapp_if.sv            <- *** FILE MOI ***       [IF-1..9]
   |   |-- yapp_tx_driver.sv     <- SUA NHIEU               [DRV-1..5]
   |   |-- yapp_tx_monitor.sv    <- SUA NHIEU               [MON-1..5]
   |   +-- yapp_pkg.sv           <- them 1 dong             [PKG-1]
   +-- tb/
       |-- router_tb.sv          giu nguyen
       |-- router_test_lib.sv    giu nguyen
       |-- clkgen.sv             <- FILE MOI (CHO SAN)
       |-- hw_top.sv             <- *** FILE MOI ***        [HW-1..4]
       |-- tb_top.sv             <- *** FILE MOI ***        [TB-1..3]
       |-- top.sv                <- XOA (thay bang 2 file tren)
       +-- run.f                 <- SUA NHIEU               [RUN-1..3]

   TONG: 29 TODO


===============================================================================
 VI SAO TACH top.sv THANH tb_top.sv + hw_top.sv
===============================================================================

 Section 10 slide 10:

    tb_top  = PHAN MEM  : class UVM, khong tong hop duoc
    hw_top  = PHAN CUNG : interface + DUT + clkgen, tong hop duoc

 Tach ra de sau nay chay duoc tren EMULATOR: nap hw_top xuong phan cung,
 giu tb_top tren may tram. Ngay ca khi khong dung emulator, tach ra van
 sach hon.

 [Suy luan] Toi dung cau truc nay theo lab07_integ trong repo. Thu muc
 lab06_vif trong repo co run.f GIONG HET lab05_seq (khong co yapp_if.sv,
 khong co RTL) -- co ve do la trang thai XUAT PHAT cua Lab 6, khong phai
 loi giai. Neu ban thay lab06_vif co to chuc khac, tin file trong repo.


===============================================================================
 THU TU LAM  -- RAT QUAN TRONG
===============================================================================

   1. sv/yapp_if.sv         [IF-1..9]    *** kho nhat -- lam truoc ***
   2. sv/yapp_pkg.sv        [PKG-1]      1 dong typedef
   3. tb/hw_top.sv          [HW-1..4]    noi interface vao DUT
   4. tb/tb_top.sv          [TB-1..3]    set virtual interface
   5. tb/run.f              [RUN-1..3]   them file vao danh sach bien dich
   6. sv/yapp_tx_driver.sv  [DRV-1..5]   dung vif
   7. sv/yapp_tx_monitor.sv [MON-1..5]   dung vif

   Lam 1->5 truoc roi BIEN DICH THU (chua chay). Compile sach roi moi lam 6,7.
   Lam nguoc lai se chet vi driver tham chieu toi thu chua ton tai.


===============================================================================
 CHAY
===============================================================================

   cd lab06_my/tb
   xrun -f run.f +UVM_TESTNAME=exhaustive_seq_test -l log6.log


===============================================================================
 KET QUA MONG DOI
===============================================================================

 Lan dau tien log se co CA HAI chieu:

   UVM_INFO ... [yapp_tx_driver]  Sending Packet :        <- driver GUI
   ...
   UVM_INFO ... [yapp_tx_monitor] Packet Collected :      <- monitor THU
   ...
   UVM_INFO ... [yapp_tx_driver]  Report: YAPP TX driver sent 10 packets
   UVM_INFO ... [yapp_tx_monitor] Report: YAPP Monitor Collected 10 Packets

 KIEM TRA CHINH:  so GUI phai bang so THU.

   grep -c "Sending Packet"   log6.log
   grep -c "Packet Collected" log6.log

 Hai so bang nhau  =>  interface cua ban dung ca hai chieu.
 Lech nhau         =>  xem muc BAY ben duoi.

 Va:
   UVM_ERROR : 0
   UVM_FATAL : 0
   KHONG co [NOVIF]
   KHONG co [CFGNRD]


===============================================================================
 BAY CUA LAB 6
===============================================================================

 BAY 1 -- QUEN THEM yapp_if.sv VAO run.f
 ----------------------------------------
   Trieu chung: loi BIEN DICH, khong tim thay kieu 'yapp_if'
   Ly do: Section 10 slide 5 -- interface PHAI bien dich rieng,
          KHONG duoc `include vao package.

 BAY 2 -- [NOVIF] ERROR
 -----------------------
   Trieu chung: UVM_ERROR ... [NOVIF] virtual interface must be set for: ...
   Ba nguyen nhan:
     a) set() dat SAU run_test()           -> xem TB-3
     b) duong dan trong set() sai          -> so voi print_topology()
     c) ten field khong khop ("vif")       -> set va get phai giong het

 BAY 3 -- MO PHONG TREO, KHONG RA GOI NAO
 -----------------------------------------
   Trieu chung: chay mai khong dung, hoac dung o t=0 voi 0 goi
   Ba nguyen nhan:
     a) clkgen khong chay -> khong co clock -> moi @(negedge clock) treo
     b) reset khong bao gio len roi xuong -> driver ket o @(posedge vif.reset)
     c) in_suspend ket o 1 -> @(... iff !in_suspend) treo mai
        (interface that co assertion YAPP_SUSPENDED bat ca nay)

 BAY 4 -- DRIVER GUI 10, MONITOR THU 0
 --------------------------------------
   Driver chay duoc, monitor khong thay gi.
   Kiem tra: monitor co lay duoc vif khong? (co [NOVIF] khong?)
             monitor dung posedge hay negedge? (phai NGUOC voi driver)

 BAY 5 -- SO GOI THU IT HON SO GOI GUI
 --------------------------------------
   Thuong la loi dem trong vong lap payload, hoac monitor bo lo goi cuoi
   vi mo phong dung truoc khi no thu xong -> xem lai drain time.


===============================================================================
 BI THI TRA O DAU
===============================================================================

   interface bien dich rieng        Section 10 slide 5
   vi sao can virtual interface     Section 10 slide 7
   driver dung vif + task trong if  Section 10 slide 8
   tach tb_top / hw_top             Section 10 slide 10
   uvm_config_db::set cho vif       Section 10 slide 11
   get trong connect_phase          Section 10 slide 12
   typedef cho gon                  Section 10 slide 13
   set/get la gi                    (phan giai thich rieng da gui)
   dinh dang goi YAPP               Section 2
   begin_tr / end_tr                Section 10 slide 9

===============================================================================
