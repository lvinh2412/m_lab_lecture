===============================================================================
 LAB 2 -- Creating Test and Testbench Components   (SKELETON)
===============================================================================

CACH DAT FILE
-------------
Tao thu muc lab02_my/ ngang hang voi lab01_data/:

   lab02_my/
   |-- sv/
   |   |-- yapp_packet.sv    <- COPY tu lab01_data/sv/  (da xong o Lab 1)
   |   +-- yapp_pkg.sv       <- COPY tu lab01_data/sv/  (da xong o Lab 1)
   +-- tb/
       |-- router_tb.sv          <- SKELETON, ban dien
       |-- router_test_lib.sv    <- SKELETON, ban dien
       |-- top.sv                <- SKELETON, ban dien
       +-- run.f                 <- SKELETON, ban dien

Lenh copy:
   mkdir -p lab02_my/sv lab02_my/tb
   cp lab01_data/sv/*.sv lab02_my/sv/
   # roi chep 4 file skeleton vao lab02_my/tb/

CHAY
----
   cd lab02_my/tb
   echo $UVMHOME                 # phai tro toi .../CDNS-1.2/sv
   xrun -f run.f +UVM_TESTNAME=base_test
   xrun -f run.f +UVM_TESTNAME=test2
   xrun -f run.f +UVM_TESTNAME=base_test +UVM_VERBOSITY=UVM_HIGH

===============================================================================
 18 TODO, chia theo file
===============================================================================
 router_tb.sv        : TODO-1  .. TODO-4
 router_test_lib.sv  : TODO-5  .. TODO-12
 top.sv              : TODO-13 .. TODO-16
 run.f               : TODO-17 .. TODO-18

Bi cho nao thi tra lai dung section/slide ghi trong comment cua chinh TODO do.
===============================================================================
