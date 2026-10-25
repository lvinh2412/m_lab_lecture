===============================================================================
 LAB 5 -- Generating UVM Sequences   (SKELETON)
 Section 9 (Sequences)
===============================================================================

MUC TIEU (slide 28)
-------------------
  - Khai bao sequence YAPP cho vai muc tieu stimulus:
        simple, nested, property-controlled, directed
  - Chay sequence da chon tren YAPP sequencer
  - Tao mot EXHAUSTIVE sequence chay tat ca sequence da khai
  - TIM, DEBUG va SUA cac randomization failure     *** muc tieu kho nhat ***


===============================================================================
 CHUAN BI
===============================================================================

   mkdir -p lab05_my
   cp -r lab04_my/* lab05_my/        # lay Lab 4 cua ban lam goc
   cd lab05_my

Lab 5 SUA 3 file:
   sv/yapp_tx_seqs.sv      <- THEM 6 sequence moi   [SEQ-1..19]
   tb/router_test_lib.sv   <- THEM 3 test           [TEST-1..5]
   tb/run.f                <- them dong chon test   [RUN-1]

Cac file khac GIU NGUYEN. Lab 5 khong dong gi vao UVC.


===============================================================================
 BAN DO SEQUENCE
===============================================================================

 +---------------------------+----------------------+----------+------------+
 | Sequence                  | Kieu stimulus        | TODO     | Do kho     |
 +---------------------------+----------------------+----------+------------+
 | yapp_base_seq             | (CHO SAN - Lab 3)    | --       | --         |
 | yapp_5_packets            | (CHO SAN - Lab 3)    | --       | --         |
 | yapp_012_seq              | directed (addr)      | 1..3     | de         |
 | yapp_1_seq                | directed (addr)      | 4..5     | de         |
 | yapp_111_seq              | NESTED               | 6..8     | trung binh |
 | yapp_repeat_addr_seq      | PROPERTY-controlled  | 9..12    | *** kho ***|
 | yapp_incr_payload_seq     | DIRECTED (payload)   | 13..16   | *** kho ***|
 | yapp_exhaustive_seq       | NESTED nhieu tang    | 17..19   | trung binh |
 +---------------------------+----------------------+----------+------------+

 TONG: 19 TODO trong yapp_tx_seqs.sv  +  5 TODO trong router_test_lib.sv
     +  1 TODO trong run.f   =   25 TODO


===============================================================================
 THU TU LAM
===============================================================================

   1. SEQ-1..5     yapp_012_seq, yapp_1_seq          (lam quen `uvm_do_with)
   2. SEQ-6..8     yapp_111_seq                      (long sequence lan dau)
   3. SEQ-9..12    yapp_repeat_addr_seq              (CO Y DE LOI -- xem duoi)
   4. SEQ-13..16   yapp_incr_payload_seq             (create/send pattern)
   5. SEQ-17..19   yapp_exhaustive_seq               (long tat ca)
   6. TEST-1..5    3 test moi
   7. RUN-1

 *** SEQ-9..12 duoc thiet ke de BAN GAP LOI, roi tu sua. Lam dung thu tu. ***


===============================================================================
 CHAY
===============================================================================

   cd lab05_my/tb

   xrun -f run.f +UVM_TESTNAME=incr_payload_test
   xrun -f run.f +UVM_TESTNAME=exhaustive_seq_test
   xrun -f run.f +UVM_TESTNAME=seq_from_test

   # soi co che objection (thi nghiem Section 9 slide 23-24)
   xrun -f run.f +UVM_TESTNAME=exhaustive_seq_test +UVM_VERBOSITY=UVM_MEDIUM \
        -l log_exh.log
   grep -i objection log_exh.log


===============================================================================
 KET QUA MONG DOI
===============================================================================

 +---------------------+------------------+---------------------------------+
 | Test                | So goi gui di    | Dac diem                        |
 +---------------------+------------------+---------------------------------+
 | incr_payload_test   | 1                | payload = 0,1,2,3,...           |
 | exhaustive_seq_test | 10               | xem phan tich duoi              |
 | seq_from_test       | 5                | objection do TEST giu           |
 +---------------------+------------------+---------------------------------+

 Dem goi cua exhaustive_seq_test:
     yapp_012_seq           3 goi  (addr 0, 1, 2)
     yapp_1_seq             1 goi  (addr 1)
     yapp_111_seq           3 goi  (addr 1, ba lan)
     yapp_repeat_addr_seq   2 goi  (cung addr, hai lan)
     yapp_incr_payload_seq  1 goi
     ----------------------------
     TONG                  10 goi

 Ca ba test deu phai co:
     UVM_ERROR  : 0
     UVM_FATAL  : 0
     UVM_WARNING: 0        <- *** chu y cai nay, xem muc "BAY" ***
     KHONG co [CFGNRD]


===============================================================================
 BAY CUA LAB 5
===============================================================================

 BAY 1 -- QUEN KE THUA yapp_base_seq
 ------------------------------------
    class my_seq extends uvm_sequence #(yapp_packet);   <- SAI
    class my_seq extends yapp_base_seq;                 <- DUNG

    Sai thi: khong raise objection  ->  mo phong dung o t=0
             -> 0 goi, 0 error, khong canh bao gi.
    (Section 9 slide 19, 24)


 BAY 2 -- RANDOMIZATION FAILURE  *** muc tieu cua lab ***
 ---------------------------------------------------------
    Dau hieu:  UVM_WARNING > 0,  hoac goi co length = 0.
    Tim bang:  grep -i "randomization\|RNDFLD\|WARNING" log.txt

    Hai nguon:
      (a) constraint cua SEQUENCE mau thuan constraint cua PACKET
          -> SEQ-11 se cho ban gap truc tiep
      (b) viet tay randomize() ma khong kiem tra ket qua
          -> SEQ-14

    Nho: randomize() that bai CHI phat WARNING, goi VAN duoc gui
         voi gia tri cu (= 0 neu vua `uvm_create).


 BAY 3 -- DUNG `uvm_rand_send THAY VI `uvm_send
 -----------------------------------------------
    Sau khi gan tay cac field, `uvm_rand_send se RANDOMIZE LAI
    va xoa sach gia tri ban vua gan.
    (Section 9 slide 11, 12)


 BAY 4 -- QUEN set_parity() SAU KHI SUA FIELD
 ---------------------------------------------
    parity tinh tren {length, addr} XOR payload.
    Sua bat ky field nao trong do ma khong goi lai set_parity()
    -> goi vua sai noi dung VUA sai parity (hai loi cung luc).


===============================================================================
 BI THI TRA O DAU
===============================================================================

   `uvm_do / `uvm_do_with          Section 9 slide 7, 11
   7 buoc cua `uvm_do              Section 9 slide 9
   `uvm_create / `uvm_send         Section 9 slide 11, 12
   directed stimulus pattern       Section 9 slide 12
   rand property cua sequence      Section 9 slide 13
   long sequence                   Section 9 slide 14, 15
   default_sequence                Section 9 slide 17
   chay bang .start() tu test      Section 9 slide 18
   objection                       Section 9 slide 19-24
   root vs subsequence             Section 9 slide 23

===============================================================================
