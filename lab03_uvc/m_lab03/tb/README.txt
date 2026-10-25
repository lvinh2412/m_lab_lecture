===============================================================================
 LAB 3 -- Creating a Simple UVC   (SKELETON)
===============================================================================

CACH DAT FILE
-------------
   lab03_my/
   |-- sv/
   |   |-- yapp_packet.sv        <- COPY tu Lab 1 (da xong, khong sua)
   |   |-- yapp_tx_sequencer.sv  <- SKELETON   [SEQR-1..2]
   |   |-- yapp_tx_monitor.sv    <- SKELETON   [MON-1..3]
   |   |-- yapp_tx_driver.sv     <- SKELETON   [DRV-1..4]
   |   |-- yapp_tx_seqs.sv       <- SKELETON   [SEQS-1..4]  (cho san 1 nua)
   |   |-- yapp_tx_agent.sv      <- SKELETON   [AGT-1..7]
   |   |-- yapp_env.sv           <- SKELETON   [ENV-1..5]
   |   +-- yapp_pkg.sv           <- SKELETON   [PKG-1..2]
   +-- tb/
       |-- router_tb.sv          <- SKELETON   [TB-1..2]
       |-- router_test_lib.sv    <- SKELETON   [TEST-1..2]
       |-- top.sv                <- CHO SAN, khong sua
       +-- run.f                 <- SKELETON   [RUN-1..2]

Lenh chuan bi:
   mkdir -p lab03_my/sv lab03_my/tb
   cp lab01_data/sv/yapp_packet.sv lab03_my/sv/
   # roi chep cac file skeleton vao


THU TU LAM  (tu de den kho, va ton trong phu thuoc)
---------------------------------------------------
   1. yapp_tx_sequencer.sv   ~5 dong,  lay da
   2. yapp_tx_monitor.sv     ~15 dong
   3. yapp_tx_driver.sv      *** khai niem MOI: bat tay TLM ***
   4. yapp_tx_seqs.sv        mot nua da cho san
   5. yapp_tx_agent.sv       *** kho nhat: build + connect ***
   6. yapp_env.sv            giong router_tb cua Lab 2
   7. yapp_pkg.sv            *** thu tu include quan trong ***
   8. router_tb.sv           sua tu Lab 2, them 2 thu
   9. router_test_lib.sv     sua tu Lab 2, them 1 dong
  10. run.f


CHAY
----
   cd lab03_my/tb
   echo $UVMHOME
   xrun -f run.f +UVM_TESTNAME=base_test
   xrun -f run.f +UVM_TESTNAME=base_test +UVM_VERBOSITY=UVM_HIGH


===============================================================================
 TONG: 30 TODO
===============================================================================
Bi cho nao thi tra section/slide ghi ngay trong comment cua TODO do.
===============================================================================
