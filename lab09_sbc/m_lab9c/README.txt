===============================================================================
LAB 9C  --  USING TLM EXPORT CONNECTORS   (Section 14, slide 27)
===============================================================================

Section 14 ghi nguyen van:

    "Lab 9C  Using TLM Export Connectors (Optional)
       - Modifying the scoreboard to use TLM export connectors"

Day la lab NHO NHAT cua ca khoa. Nhung no day mot thu khong lab nao khac day:
*** DONG GOI (encapsulation) -- va cai gia phai tra cho no ***


===============================================================================
NEU BAN DA LAM "GIAI DOAN 2" CUA SKELETON LAB 9B
===============================================================================

Thi ban DA LAM XONG phan chinh cua Lab 9C roi. [ENV-5], [ENV-6], [RTB-3 ban 2]
trong skeleton Lab 9B chinh la noi dung Lab 9C.

Skeleton nay van dang doc, vi no them BON thu ma Lab 9B chua co:

  (1) Mot BAY run.f co that trong repo, da xac minh -- muc [RUN-1]
  (2) Chuyen HAI PHIEN BAN router_module_env.sv ten khac nhau -- Bay 4
  (3) Phep dem print_topology() truoc/sau -- Buoc 5
  (4) Bai tap "doi ten" voi con so that tu repo -- muc TU KIEM TRA cau 3

Neu ban CHUA lam giai doan 2: lam tu Buoc 1.


===============================================================================
LAB 9C DOI NHUNG GI
===============================================================================

[Da xac minh -- chay `diff -rq lab09_sbb lab09_sbc` tren repo cua ban]

Ket qua: CHI 4 FILE KHAC NHAU (khong tinh xrun.log)

  +----------------------------+----------------------------------------+
  | file                       | thay doi                               |
  +----------------------------+----------------------------------------+
  | sv/router_module_env.sv    | +5 export, +5 new(), +5 connect()      |
  | tb/router_tb.sv            | 5 dong connect doi DUONG DAN           |
  | tb/run.f                   | doi duong dan router_module_pkg.sv     |
  |                            | (XEM [RUN-1] -- day la BAY)            |
  | sv/router_reference.sv     | *** CHI DI CHUYEN report_phase ***     |
  |                            | tu cuoi file len sau constructor.      |
  |                            | KHONG doi mot ky tu logic nao.         |
  +----------------------------+----------------------------------------+

*** NHUNG FILE KHONG DOI MOT DONG ***

    sv/router_scoreboard.sv      <- da xac minh: diff -q bao giong het
    sv/router_module_pkg.sv      <- giong het (chi khac comment)
    tb/router_test_lib.sv        <- khong doi
    tb/tb_top.sv                 <- khong doi
    tb/router_mcsequencer.sv     <- khong doi
    tb/router_mcseqs_lib.sv      <- khong doi
    tb/clkgen.sv  hw_top.sv      <- khong doi

Doc ky danh sach tren. Ban sap thay doi CACH TESTBENCH NOI VAO MODULE UVC
ma khong cham vao bat ky thanh phan nao BEN TRONG no. Do chinh la dinh nghia
cua dong goi.


===============================================================================
*** CAU HOI TRUNG TAM CUA LAB 9C ***
===============================================================================

Lab 9B, router_tb.connect_phase viet:

    yapp.tx_agent.monitor.item_collected_port.connect(router_mod.reference.yapp_in);
                                                                 ^^^^^^^^^^^^^^^^^
                                                                 THO VAO RUOT

router_tb dang voi tay QUA router_mod de cham vao mot thanh phan ben trong no.

Dieu gi sai?  KHONG CO GI SAI VE MAT KY THUAT. No chay dung.

Cai sai la ve mat PHU THUOC:

  router_tb gio BIET rang:
    - router_env co mot con ten la "reference"
    - con do co mot cong ten la "yapp_in"
    - va goi YAPP phai di vao reference TRUOC, khong phai scoreboard

  Ba thong tin do la CHI TIET CAI DAT BEN TRONG cua Module UVC.
  Nguoi viet Module UVC khong duoc phep doi chung nua.

Lab 9C xoa ba thong tin do khoi router_tb:

    yapp.tx_agent.monitor.item_collected_port.connect(router_mod.yapp_in);
                                                                 ^^^^^^^
                                                      CHI BIET "co mot cong
                                                      ten yapp_in". Het.


===============================================================================
SO SANH HAI CACH -- VE BANG KY HIEU SLIDE 12
===============================================================================

  LAB 9B -- router_tb tho vao ruot:

   +- router_tb -------------------------------------------------+
   |                                                              |
   |  monitor [] ====pkt=====================\                    |
   |                                          \                   |
   |      +- router_mod (router_env) ----------\---------------+  |
   |      |                                     v              |  |
   |      |   reference  (O) yapp_in                           |  |
   |      |        |  write_yapp() loc                         |  |
   |      |        v                                           |  |
   |      |   [] sb_add_out ====> (O) sb_yapp_in  scoreboard   |  |
   |      +--------------------------------------------------- +  |
   +--------------------------------------------------------------+
        Mui ten di XUYEN QUA tuong cua router_mod.


  LAB 9C -- noi vao mat tien:

   +- router_tb -------------------------------------------------+
   |                                                              |
   |  monitor [] ====pkt====\                                     |
   |                         v                                    |
   |      +- router_env -----|-------------------------------+    |
   |      |         yapp_in |>                               |    |
   |      |                  \                               |    |
   |      |                   v                              |    |
   |      |   reference  (O) yapp_in                         |    |
   |      |        |  write_yapp() loc                       |    |
   |      |        v                                         |    |
   |      |   [] sb_add_out ====> (O) sb_yapp_in  scoreboard |    |
   |      +------------------------------------------------- +    |
   +--------------------------------------------------------------+
        Mui ten DUNG LAI o tuong. Ben trong tu lo.

  *** Chuoi TLM dai ra mot chang:  port -> export -> imp  ***
  Khong co gi mat di. Chi them mot nguoi gac cong.


===============================================================================
QUY TRINH 7 BUOC
===============================================================================

Buoc 0 -- Chuan bi
   cp -r lab09b_my lab09c_my    (hoac lab09_sbb neu ban muon ban chuan)
   cd lab09c_my

   *** QUAN TRONG: Lab 9C bat dau tu LAB 9B DA CHAY DUOC. ***
   Neu Lab 9B cua ban chua PASSED, dung lam 9C -- sua 9B truoc.
   Ly do: 9C khong them chuc nang nao. Neu hong, ban se khong biet
   hong do 9C hay do 9B.

Buoc 1 -- Ghi lai so lieu goc (DUNG BO QUA)
   cd tb
   xrun -f run.f +UVM_TESTNAME=test_mc -l log9b_base.log
   grep -E "packets_forwarded|Packets In|Simulation" log9b_base.log
   grep -c "uvm_analysis" log9b_base.log

   Ghi ra giay:  packets_forwarded = ____   packets_in = ____
                 so dong TLM trong print_topology = ____

   Sau Lab 9C, HAI SO DAU phai GIONG HET. So thu ba phai TANG 5.
   Do la toan bo tieu chi dung/sai cua lab nay.

Buoc 2 -- Sua sv/router_module_env.sv
   Theo sv/router_module_env.sv trong skeleton nay.  [ENV-1] .. [ENV-5]

Buoc 3 -- Bien dich THU, chua sua router_tb
   xrun -f run.f +UVM_TESTNAME=test_mc -l log_step3.log

   *** DU DOAN TRUOC KHI CHAY ***
   [Suy luan] Toi cho rang no VAN CHAY BINH THUONG va PASSED.
   Vi sao? Vi router_tb van dang noi thang vao ruot (cach Lab 9B),
   va nam export moi chi nam do khong ai dung.

   Kiem chung:  grep -c "yapp_in" log_step3.log
   Ban se thay print_topology co THEM nam dong export, nhung ket qua
   khong doi. Nam export dang "treo" -- noi vao imp nhung khong ai
   noi vao chung.

   *** DAY LA BANG CHUNG SONG cua slide 21 Section 14: ***
       "Any number of targets (including zero)"
   Mot analysis export chua ai noi vao KHONG BAO LOI.
   Neu la uvm_put_export, ban da an Fatal roi.

Buoc 4 -- Sua tb/router_tb.sv
   Theo tb/ROUTER_TB_PATCH.txt.  [RTB-1] .. [RTB-2]

Buoc 5 -- Chay va DEM
   xrun -f run.f +UVM_TESTNAME=test_mc -l log9c.log

   So sanh ba con so voi Buoc 1:
     diff <(grep -E "packets_forwarded|Packets In" log9b_base.log) \
          <(grep -E "packets_forwarded|Packets In" log9c.log)
     -> phai KHONG RA GI

     grep -c "uvm_analysis" log9b_base.log
     grep -c "uvm_analysis" log9c.log
     -> cai sau phai LON HON cai truoc dung 5

Buoc 6 -- Doc ky [RUN-1] trong tb/RUN_F_NOTES.txt
   Buoc nay khong sua gi, nhung no la thu dang gia nhat cua Lab 9C.

Buoc 7 -- Thi nghiem doi ten (tuy chon, 10 phut)
   Xem muc TU KIEM TRA cau 3.


===============================================================================
NAM CAI BAY
===============================================================================

BAY 1 -- Quen new() nam export trong constructor
   Trieu chung: Fatal "null object access" tai dong connect dau tien
                trong router_env.connect_phase
   Vi sao kho: thong bao loi tro vao router_module_env.sv, nhung nguyen
               nhan la mot dong THIEU trong function new(), khong phai
               dong bao loi.

BAY 2 -- Sua router_tb nhung QUEN sua router_module_env (hoac nguoc lai)
   Neu sua router_tb truoc  -> loi "yapp_in is not a member of router_env"
   Neu sua env truoc        -> KHONG LOI GI CA (xem Buoc 3)
   => Lam dung thu tu Buoc 2 roi Buoc 4. Mot ben bao loi, mot ben im lang.

BAY 3 -- Quen dong reference.sb_add_out.connect(scoreboard.sb_yapp_in)
   Dong nay la dong CU tu Lab 9B. No KHONG DOI, nhung de bi xoa nham
   khi ban go lai ca connect_phase.
   Trieu chung: scoreboard.packets_in = 0, hang doi rong, "PASSED" gia.
   => Doi chieu packets_forwarded vs packets_in. Day la thoi quen
      toi da yeu cau ban tu Lab 9B.

BAY 4 -- *** HAI PHIEN BAN router_module_env.sv TEN EXPORT KHAC NHAU ***

   [Da xac minh -- grep repo]

   +--------------------------------+--------------------------------------+
   | file                           | ten 5 export                         |
   +--------------------------------+--------------------------------------+
   | lab09_sbc/sv/                  | hbus_in, yapp_in,                    |
   | router_module_env.sv           | sb_chan0, sb_chan1, sb_chan2         |
   +--------------------------------+--------------------------------------+
   | router/sv/                     | router_hbus, router_yapp,            |
   | router_module_env.sv           | router_chan0, router_chan1,          |
   | (ban UVC dung chung)           | router_chan2                         |
   +--------------------------------+--------------------------------------+

   HAI BO TEN HOAN TOAN KHAC NHAU cho cung mot class router_env.

   lab09_sbc/tb/router_tb.sv noi toi router_mod.yapp_in
   -> chi khop BAN CUC BO.

   Skeleton nay dung BO TEN CUC BO (hbus_in / yapp_in / sb_chan0/1/2),
   nhat quan voi skeleton Lab 9B toi da dua ban.

   *** DAY CHINH LA BAI HOC CUA LAB 9C, HIEN RA TRONG CHINH REPO ***
   Ten export la HOP DONG CONG KHAI cua UVC. Doi ten = pha hop dong.
   Tac gia repo doi ten o ban dung chung, va gio hai ban KHONG THAY
   THE NHAU DUOC nua.

BAY 5 -- run.f tro sai cho
   Xem [RUN-1]. Bay nay co THAT trong repo va dang am tham hoat dong.


===============================================================================
SAU KHI XONG: CAY COMPONENT MOI
===============================================================================

  router_tb
   |-- yapp (yapp_env)
   |-- chan0/1/2 (channel_env)
   |-- hbus (hbus_env)
   |-- clock_and_reset
   |-- mcsequencer (router_mcsequencer)
   `-- router_mod (router_env)
        |-- hbus_in      uvm_analysis_export      <- MOI
        |-- yapp_in      uvm_analysis_export      <- MOI
        |-- sb_chan0     uvm_analysis_export      <- MOI
        |-- sb_chan1     uvm_analysis_export      <- MOI
        |-- sb_chan2     uvm_analysis_export      <- MOI
        |-- scoreboard (router_scoreboard)
        |    |-- sb_yapp_in   uvm_analysis_imp_yapp
        |    |-- sb_chan0     uvm_analysis_imp_chan0
        |    |-- sb_chan1     uvm_analysis_imp_chan1
        |    `-- sb_chan2     uvm_analysis_imp_chan2
        `-- reference (router_reference)
             |-- hbus_in      uvm_analysis_imp_hbus
             |-- yapp_in      uvm_analysis_imp_yapp
             `-- sb_add_out   uvm_analysis_port

  *** CHU Y SU TRUNG TEN CO CHU Y ***
     router_env.yapp_in   (export)  <-- ten GIONG
     reference.yapp_in    (imp)     <-- ten GIONG

     router_env.sb_chan0  (export)  <-- ten GIONG
     scoreboard.sb_chan0  (imp)     <-- ten GIONG

  Duoc phep vi chung o HAI CLASS khac nhau. Va co y nghia: export
  la "mat tien" cua dung cai imp do. Dat ten khac se gay nham.


===============================================================================
TU KIEM TRA
===============================================================================

 1. O Buoc 3, ban them 5 export nhung CHUA ai noi vao chung, va mo phong
    van PASSED khong mot warning. Neu chung la uvm_put_export thay vi
    uvm_analysis_export, dieu gi se xay ra? Tra loi bang hai con so
    min_size/max_size.

 2. router_env.connect_phase co 6 dong. Nam dong moi (export->imp) va
    mot dong cu (port->imp). Thu tu giua chung co quan trong khong?
    Vi sao? (Goi y: connect() chi GHI VAO BANG, khong truyen du lieu.)

 3. *** BAI TAP DOI TEN -- dem bang tay, khong chay tool ***
    Gia su ban doi handle "reference" trong router_module_env.sv
    thanh "ref_model".

      (a) Ban LAB 9B phai sua may cho? Liet ke tung file.
      (b) Ban LAB 9C phai sua may cho? Liet ke tung file.

    Hai con so nay chenh nhau bao nhieu? Do chinh la gia tri bang so
    cua Lab 9C.

    Lam xong roi kiem bang:
      grep -rn "reference\." lab09_sbb/ --include=*.sv
      grep -rn "reference\." lab09_sbc/ --include=*.sv

 4. Lab 9C khong them mot chuc nang kiem tra nao. packets_forwarded,
    packets_in, so goi [OVERSIZED] deu khong doi. Vay no co ich gi?
    Tra loi trong mot cau, khong dung tu "dep" hay "sach".

 5. Section 14 slide 27 ghi Lab 9C la "(Optional)". Neu ban la truong
    nhom verification va mot ky su moi hoi "em co can lam 9C khong?",
    ban tra loi the nao? Dua ra MOT tinh huong cu the trong du an that
    ma khong co 9C se gay ra chi phi.

===============================================================================
