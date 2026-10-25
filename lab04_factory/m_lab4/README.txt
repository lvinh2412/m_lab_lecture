===============================================================================
 LAB 4 -- Using Factories   (SKELETON)
 Section 7 (Configuration) + Section 8 (Type Overrides and the Factory)
===============================================================================

MUC TIEU (slide 18)
-------------------
  - Cap nhat file lab de BAT factory  (moi new() -> type_id::create())
  - Tao NHIEU TEST: mot base_test, cac test khac dan xuat tu no
  - Dung TYPE OVERRIDE de doi kieu packet mot cach dong
  - Dung CONFIGURATION de doi topology cua UVC


===============================================================================
 CHUAN BI
===============================================================================

   mkdir -p lab04_my
   cp -r lab03_my/* lab04_my/        # LAY NGUYEN Lab 3 cua ban lam goc
   cd lab04_my

Lab 4 KHONG tao file moi. No sua 6 file co san.


===============================================================================
 BAN DO FILE
===============================================================================

   lab04_my/
   |-- sv/
   |   |-- yapp_packet.sv        <- SUA : THEM class short_yapp_packet  [PKT-1..3]
   |   |-- yapp_tx_sequencer.sv  <- giu nguyen
   |   |-- yapp_tx_monitor.sv    <- KIEM TRA  (xem PATCHES.txt)         [MON-1]
   |   |-- yapp_tx_driver.sv     <- KIEM TRA  (xem PATCHES.txt)
   |   |-- yapp_tx_seqs.sv       <- giu nguyen
   |   |-- yapp_tx_agent.sv      <- SUA : new() -> create()             [AGT-1..3]
   |   |-- yapp_env.sv           <- SUA : new() -> create()             [ENV-1]
   |   +-- yapp_pkg.sv           <- giu nguyen
   +-- tb/
       |-- router_tb.sv          <- SUA : new() -> create()             [TB-1]
       |-- router_test_lib.sv    <- VIET LAI PHAN LON                   [TEST-1..11]
       |-- top.sv                <- giu nguyen
       +-- run.f                 <- SUA                                 [RUN-1..2]

   File skeleton toi dua cho ban:
       README.txt                 <- file nay
       PATCHES.txt                <- 5 doan sua nho  [PKT, MON, AGT, ENV, TB]
       tb/router_test_lib.sv      <- skeleton day du [TEST-1..11]
       tb/run.f                   <- skeleton        [RUN-1..2]


===============================================================================
 THU TU LAM
===============================================================================

   1. yapp_packet.sv       them short_yapp_packet       [PKT-1..3]   de
   2. yapp_tx_agent.sv     3 cho new() -> create()      [AGT-1..3]   de
   3. yapp_env.sv          1 cho                        [ENV-1]      de
   4. router_tb.sv         1 cho                        [TB-1]       de
   5. quet TOAN BO file tim new() con sot              [MON-1]      *** quan trong ***
   6. router_test_lib.sv   4 class                      [TEST-1..11] kho nhat
   7. run.f                                             [RUN-1..2]

   TONG: 18 TODO


===============================================================================
 CHAY
===============================================================================

   cd lab04_my/tb
   echo $UVMHOME

   xrun -f run.f +UVM_TESTNAME=test2
   xrun -f run.f +UVM_TESTNAME=short_packet_test
   xrun -f run.f +UVM_TESTNAME=set_config_test

   (+UVM_TESTNAME tren dong lenh GHI DE dong trong run.f)


===============================================================================
 KET QUA MONG DOI
===============================================================================

 Bang doi chieu -- chay xong ba test thi dien vao:

 +--------------------+-------------------+--------------+-------------------+
 | Test               | cot Type cua      | is_active    | Driver in goi?    |
 |                    | packet            | trong topo   |                   |
 +--------------------+-------------------+--------------+-------------------+
 | test2              | yapp_packet       | UVM_ACTIVE   | CO                |
 | short_packet_test  | short_yapp_packet | UVM_ACTIVE   | CO, length <= 14  |
 |                    |                   |              |     addr in {0,1} |
 | set_config_test    | (khong co goi)    | UVM_PASSIVE  | KHONG             |
 +--------------------+-------------------+--------------+-------------------+

 Cho ba test deu phai co:
   UVM_ERROR :    0
   UVM_FATAL :    0
   KHONG co dong [CFGNRD]


 Cach doc ket qua:

 (a) Cot "Type" -- trong topology report VA trong ban in packet cua driver:
        req   short_yapp_packet   -   @3031
              ^^^^^^^^^^^^^^^^^
        Day la bang chung type override DA chay.
        Neu van thay "yapp_packet" => override chua co tac dung.

 (b) is_active -- dong cuoi trong khoi tx_agent cua topology report:
        is_active    uvm_active_passive_enum    1    UVM_PASSIVE

 (c) Voi set_config_test: topology SE KHONG co dong "driver" va "sequencer"
     duoi tx_agent (chi con "monitor"). Do la cach kiem tra chac chan nhat.


===============================================================================
 BON THI NGHIEM PHA HOAI  (lam sau khi ba test da chay dung)
===============================================================================

 Moi thi nghiem: pha -> chay -> quan sat -> sua lai.

 TN1 -- SAI THU TU OVERRIDE                       (Section 8 slide 11, 16)
    Trong short_packet_test, chuyen dong set_type_override xuong
    SAU dong super.build_phase(phase).
    Du doan: packet quay ve yapp_packet, UVM_ERROR = 0, khong canh bao gi.
    Bai hoc: "Overrides apply for all SUBSEQUENT calls to the factory"

 TN2 -- SOT MOT new()                             (Section 8 slide 8)
    Trong yapp_env.sv, doi create() ve lai new("tx_agent", this).
    Du doan: cay van dung duoc, nhung agent khong the bi override nua.
    Bai hoc: quy tac "all or nothing".

 TN3 -- SAI DUONG DAN CONFIG                      (Section 7 slide 11)
    Trong set_config_test, doi "tb.yapp.tx_agent" thanh "tb.yapp.agent".
    Du doan: agent tro lai ACTIVE, UVM_ERROR = 0, VA xuat hien [CFGNRD].
    Lam du 4 buoc so sanh voi print_topology() de tu tim ra chu "tx_" thieu.

 TN4 -- BO check_config_usage()                   (Section 7 slide 11)
    Lap lai TN3 nhung xoa check_phase di.
    Du doan: khong con [CFGNRD] -- bug hoan toan im lang.
    Bai hoc: vi sao check_config_usage() phai co san tu dau.


===============================================================================
 BI THI TRA O DAU
===============================================================================

   type_id::create                Section 8 slide 9
   set_type_override_by_type      Section 8 slide 10
   dang 2: X::type_id::set_...    Section 8 slide 14
   thu tu override truoc create   Section 8 slide 11, 16
   uvm_config_int::set            Section 7 slide 6, 7, 8
   duong dan phan cap             Section 7 slide 9
   check_config_usage             Section 7 slide 11
   is_active trong agent          Section 6 slide 10, Section 7 slide 5

===============================================================================
