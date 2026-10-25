//------------------------------------------------------------------------------
// router_module_env.sv   --   LAB 9C  (SKELETON)
//
// Bat dau tu BAN LAB 9B CUA BAN. File nay chi THEM, khong xoa gi.
//
//   Lab 9B:  ~20 dong
//   Lab 9C:  ~35 dong   (+5 khai bao, +5 new, +5 connect)
//
// Section 13 slide 20 / Section 14 slide 12, 27
//------------------------------------------------------------------------------


//==============================================================================
// PHAN GIU NGUYEN TU LAB 9B  (khong co TODO -- doi chieu cho chac)
//==============================================================================
//
//   class router_env extends uvm_env;
//
//     router_reference  reference;
//     router_scoreboard scoreboard;
//
//     `uvm_component_utils_begin(router_env)
//     `uvm_component_utils_end
//
//     function new(input string name, input uvm_component parent=null);
//       super.new(name, parent);
//     endfunction : new
//
//     function void build_phase(uvm_phase phase);
//       super.build_phase(phase);
//       scoreboard = router_scoreboard::type_id::create("scoreboard", this);
//       reference  = router_reference::type_id::create("reference", this);
//     endfunction : build_phase
//
//     function void connect_phase(uvm_phase phase);
//       reference.sb_add_out.connect(scoreboard.sb_yapp_in);
//     endfunction : connect_phase
//
//   endclass : router_env
//
// *** KIEM TRA TRUOC KHI BAT DAU ***
// File Lab 9B cua ban co dung 1 dong trong connect_phase khong?
// Neu co nhieu hon, ban dang o dau do khac -- doc lai skeleton Lab 9B.
//==============================================================================
class router_env extends uvm_env;



// ---- ENV-1 ------------------------------------------------------------------
// THEM NAM HANDLE EXPORT, dat NGAY DAU class, TRUOC hai handle component.
//
// Nam export chia lam HAI NHOM, va su chia nhom nay co y nghia:
//
//     // reference model connectors
//     uvm_analysis_export  #(hbus_transaction) hbus_in;
//     uvm_analysis_export  #(yapp_packet)      yapp_in;
//
//     // scoreboard connectors
//     uvm_analysis_export  #(channel_packet)   sb_chan0;
//     uvm_analysis_export  #(channel_packet)   sb_chan1;
//     uvm_analysis_export  #(channel_packet)   sb_chan2;
//
//=============================================================================
// *** TAI SAO CHIA HAI NHOM ***
//=============================================================================
//
//   nhom 1 (hbus_in, yapp_in)  -> di vao REFERENCE  -> DAU VAO cua DUT
//   nhom 2 (sb_chan0/1/2)      -> di vao SCOREBOARD -> DAU RA cua DUT
//
// Day la lan thu hai ban gap su phan chia nay (lan dau o skeleton Lab 9B,
// muc RTB-3). Nhac lai ly do:
//
//   Reference mo hinh hoa "DUT LAM GI voi dau vao".
//   Channel la dau RA -- khong co gi de mo hinh, chi co gi de SO SANH.
//
// Comment trong repo ghi dung hai cum do. Giu lai.
//
//=============================================================================
// *** MOT THAM SO TYPE, KHONG PHAI HAI ***
//=============================================================================
//
//   uvm_analysis_export #(yapp_packet)                      <- 1 tham so
//   uvm_analysis_imp_yapp #(yapp_packet, router_reference)  <- 2 tham so
//
// Luat tu Section 14:
//     #(T)         -> port hoac export  -> KHONG chua code cua ban
//     #(T, CLASS)  -> imp               -> CHUA code, trong CLASS do
//
// Export chi CHUYEN TIEP. No khong co write() cua rieng no, nen khong
// can biet class nao chua ham. Do la ly do no chi can mot tham so.
//
// *** NEU GO NHAM THANH uvm_analysis_imp ***
// -> loi bien dich, vi thieu tham so thu hai.
// -> Day la bay CO BAO LOI. De sua.
//
// *** NEU GO NHAM KIEU DU LIEU (vd channel_packet cho yapp_in) ***
// -> loi "Interface mismatch" tai dong connect, KHONG phai tai dong
//    khai bao. Thong bao loi tro sai cho. Doc ky kieu.
// -----------------------------------------------------------------------------

// reference model connectors
  uvm_analysis_export  #(hbus_transaction) hbus_in;
  uvm_analysis_export  #(yapp_packet) yapp_in;

  // scoreboard connectors
  uvm_analysis_export #(channel_packet) sb_chan0;
  uvm_analysis_export #(channel_packet) sb_chan1;
  uvm_analysis_export #(channel_packet) sb_chan2;

// Router Reference 
  router_reference reference;

  // Router Scoreboard
  router_scoreboard scoreboard;



// ---- ENV-2 ------------------------------------------------------------------
// GOI new() CHO CA NAM, trong FUNCTION NEW (constructor), KHONG phai build_phase.
//
//     function new(input string name, input uvm_component parent=null);
//       super.new(name, parent);
//       hbus_in  = new("hbus_in",  this);
//       yapp_in  = new("yapp_in",  this);
//       sb_chan0 = new("sb_chan0", this);
//       sb_chan1 = new("sb_chan1", this);
//       sb_chan2 = new("sb_chan2", this);
//     endfunction : new
//
//=============================================================================
// *** new(), KHONG PHAI type_id::create() ***
//=============================================================================
//
// Ba ly do doc lap, ly do nao cung du:
//
//  (1) uvm_analysis_export KHONG dang ky voi factory.
//      Khong co `uvm_component_utils -> khong co type_id -> create()
//      LOI BIEN DICH, khong phai loi runtime.
//
//  (2) Override mot export la vo nghia. No khong chua logic nao cua ban.
//
//  (3) Khong co tham so lap nao can truyen.
//
// Doi chieu: hai dong ngay duoi trong build_phase van dung create():
//      scoreboard = router_scoreboard::type_id::create(...)
//      reference  = router_reference::type_id::create(...)
// Vi CHUNG la component co logic, co the thay the duoc.
//
//=============================================================================
// *** VI SAO CONSTRUCTOR CHU KHONG BUILD_PHASE ***
//=============================================================================
//
// [Da xac minh] Repo dat trong constructor. Moi port/imp/export trong
// toan bo repo cua ban deu dat trong constructor:
//     yapp_tx_monitor  : item_collected_port = new(...)  trong new()
//     router_scoreboard: 4 imp                trong new()
//     router_reference : 2 imp + 1 port       trong new()
//     router_fifo_sb   : 5 FIFO               trong new()
//
// [Suy luan] Dat trong build_phase CO THE VAN CHAY, vi build_phase
// (top-down) chay xong het truoc moi connect_phase (bottom-up).
// Toi CHUA THU. Day la mot thi nghiem 3 phut dang lam:
//
//     Chuyen 5 dong new() tu constructor sang build_phase.
//     Chay. Co loi khong? Neu khong, vi sao repo van dung constructor?
//
// [Suy luan] Du doan cua toi: van chay. Ly do giu constructor la
// NHAT QUAN va an toan -- constructor luon chay truoc moi phase,
// nen khong bao gio phai nghi ve thu tu.
// -----------------------------------------------------------------------------

`uvm_component_utils_begin(router_env)
  `uvm_component_utils_end

  //UVM Constructor
  function new(input string name, input uvm_component parent=null);
    super.new(name, parent);
    hbus_in  = new("hbus_in",  this);
    yapp_in  = new("yapp_in",  this);
    sb_chan0 = new("sb_chan0", this);
    sb_chan1 = new("sb_chan1", this);
    sb_chan2 = new("sb_chan2", this);
  endfunction : new 

// UVM build_phase
  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    scoreboard = router_scoreboard::type_id::create("scoreboard", this);
    reference = router_reference::type_id::create("reference", this);
  endfunction : build_phase

// ---- ENV-3 ------------------------------------------------------------------
// THEM NAM DONG connect() vao connect_phase, TRUOC dong cu.
//
//     function void connect_phase(uvm_phase phase);
//       hbus_in.connect(reference.hbus_in);
//       yapp_in.connect(reference.yapp_in);
//       sb_chan0.connect(scoreboard.sb_chan0);
//       sb_chan1.connect(scoreboard.sb_chan1);
//       sb_chan2.connect(scoreboard.sb_chan2);
//       reference.sb_add_out.connect(scoreboard.sb_yapp_in);   <- [ENV-4] DONG CU
//     endfunction : connect_phase
//
//=============================================================================
// *** DOC KY HAI VE CUA DAU CHAM ***
//=============================================================================
//
//       hbus_in  .connect(  reference.hbus_in  );
//       ^^^^^^^                      ^^^^^^^^
//       EXPORT cua chinh                IMP cua con
//       router_env                      (reference)
//       (khong co tien to -> la "this")
//
// Ve TRAI khong co tien to vi no la thanh vien cua chinh class nay.
// Ve PHAI co tien to "reference." vi do la cua con.
//
// *** TRUNG TEN LA CO CHU Y ***
// Ca hai ve deu ten "hbus_in". Duoc phep vi o hai class khac nhau.
// Va NEN trung: export la mat tien cua dung cai imp do.
//
//=============================================================================
// *** LUAT connect() -- kiem lai ba lan ***
//=============================================================================
//
//     <ai_goi>.<port_hoac_export>.connect( <ai_cai_dat>.<export_hoac_imp> );
//
// Export co the dung CA HAI ve:
//     - ve trai: khi no chuyen tiep XUONG  (ENV-3, truong hop nay)
//     - ve phai: khi no NHAN tu tren       (RTB-1, trong router_tb)
//
// Do la ly do export ton tai. Port khong lam duoc ve phai.
// Imp khong lam duoc ve trai.
//
//     port   []  -> chi ve TRAI
//     export |>  -> CA HAI ve
//     imp    ()  -> chi ve PHAI
// -----------------------------------------------------------------------------

// UVM connect_phase
  function void connect_phase(uvm_phase phase);
    hbus_in.connect(reference.hbus_in);
    yapp_in.connect(reference.yapp_in);
    sb_chan0.connect(scoreboard.sb_chan0);
    sb_chan1.connect(scoreboard.sb_chan1);
    sb_chan2.connect(scoreboard.sb_chan2);
    reference.sb_add_out.connect(scoreboard.sb_yapp_in);
  endfunction : connect_phase

endclass : router_env

// ---- ENV-4 ------------------------------------------------------------------
// *** DONG CU TU LAB 9B -- KHONG XOA ***
//
//     reference.sb_add_out.connect(scoreboard.sb_yapp_in);
//
// Dong nay KHONG doi mot ky tu. No la lien ket NOI BO giua hai con,
// khong lien quan gi toi the gioi ben ngoai.
//
// *** VI SAO DE BI XOA NHAM ***
// Khi ban go lai ca connect_phase de them 5 dong moi, rat de quen
// go lai dong nay.
//
// *** TRIEU CHUNG NEU MAT ***
//     scoreboard.packets_in = 0
//     hang doi rong -> check_phase bao "Scoreboard Empty!"
//     report_phase bao "Simulation PASSED"
//     => PASSED GIA. Scoreboard chua bao gio nhan mot goi nao.
//
// *** CACH BAT ***
// Doi chieu hai so trong log:
//     reference.packets_forwarded   vs   scoreboard.packets_in
// Bang nhau -> dung.  packets_in = 0 -> mat dong nay.
//
// Day la thoi quen toi yeu cau ban tu Lab 9B. Lab 9C khong thay doi
// no -- nguoc lai, Lab 9C lam no QUAN TRONG HON, vi gio co nhieu
// dong connect hon de go nham.
// -----------------------------------------------------------------------------




// ---- ENV-5 ------------------------------------------------------------------
// *** KHONG LAM GI CA -- day la TODO "dung lai va nghi" ***
//
// Truoc khi bien dich, tra loi ba cau nay tren giay:
//
//  (a) router_env gio co bao nhieu doi tuong TLM?
//      5 export + (4 imp trong scoreboard) + (2 imp + 1 port trong
//      reference) = ____
//      So nay phai khop voi so dong "uvm_analysis" trong print_topology().
//
//  (b) Mot goi YAPP di tu monitor toi scoreboard phai qua MAY ham
//      ten write (ke ca ham UVM viet san)? Cai nao do BAN viet?
//
//      Goi y chuoi:
//        monitor.item_collected_port.write(pkt)      <- (1) ban goi
//          -> uvm_analysis_port::write()             <- (2) UVM
//          -> uvm_analysis_export::write()           <- (3) UVM  [MOI o 9C]
//          -> uvm_analysis_imp_yapp::write()         <- (4) macro
//          -> reference.write_yapp(pkt)              <- (5) BAN VIET
//          -> reference.sb_add_out.write(pkt)        <- (6) ban goi
//          -> uvm_analysis_port::write()             <- (7) UVM
//          -> uvm_analysis_imp_yapp::write()         <- (8) macro
//          -> scoreboard.write_yapp(pkt)             <- (9) BAN VIET
//
//      Lab 9B co 8 chang. Lab 9C co 9. Chang them vao la chang nao?
//
//  (c) Neu ban KHONG noi export nao vao (bo ca [ENV-3]), co loi gi khong?
//      Tra loi TRUOC khi chay Buoc 3 trong README, roi doi chieu.
// -----------------------------------------------------------------------------




//==============================================================================
// TU KIEM TRA
//==============================================================================
//
// 1. Dem so dong THAT (bo comment) cua file sau khi xong: khoang 35.
//    Lab 9B la khoang 20. Tang 75% so dong de khong them mot chuc nang
//    kiem tra nao. Dang hay khong dang? Tra loi bang cau 3 cua README.
//
// 2. uvm_analysis_export co mot tham so type, uvm_analysis_imp co hai.
//    Neu ban gan NHAM: khai export voi hai tham so. Loi bao o dau,
//    va thong bao loi noi gi? (Thu di -- 30 giay.)
//
// 3. Thu DAO NGUOC mot dong [ENV-3]:
//        reference.hbus_in.connect(hbus_in);     // sai chieu
//    Loi gi? Bien dich hay runtime? Thong bao noi gi?
//    (Goi y: imp co duoc phep goi connect() khong?)
//
// 4. Thu noi mot export vao HAI imp:
//        yapp_in.connect(reference.yapp_in);
//        yapp_in.connect(scoreboard.sb_yapp_in);    // them
//    Co loi khong? Neu khong, scoreboard.packets_in doi the nao?
//    Giai thich bang max_size cua uvm_analysis_export.
//
// 5. File nay co 5 export nhung router_env KHONG co export nao di RA
//    (vd de day ket qua len router_tb). Neu sau nay ban muon router_tb
//    nghe duoc cac goi da loc cua reference, ban them PORT hay EXPORT
//    vao router_env? Vi sao?
//
//==============================================================================
