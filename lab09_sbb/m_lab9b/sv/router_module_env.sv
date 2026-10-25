//------------------------------------------------------------------------------
// router_module_env.sv   --   LAB 9B  (SKELETON)   *** FILE MOI ***
//
// VO BOC cua Module UVC. No chua reference + scoreboard va noi chung
// lai voi nhau.
//
// *** CHU Y TEN CLASS ***
// File ten router_module_env.sv nhung CLASS ten router_env.
// [Da xac minh] Repo lam vay o ca lab09_sbb lan lab09_sbc.
// Khong nhat quan, nhung cu theo repo cho khoi lech.
//
// Viet file nay theo HAI GIAI DOAN:
//   Buoc 2:  ban DON GIAN  [ENV-1..4]   -- khong co export
//   Buoc 7:  them EXPORT   [ENV-5, ENV-6] -- bai hoc slide 20
//
// Tham khao: Section 13 slide 20
//------------------------------------------------------------------------------


//==============================================================================
// GIAI DOAN 1 (Buoc 2) -- BAN DON GIAN, KHONG CO EXPORT
//==============================================================================

// ---- ENV-1 ------------------------------------------------------------------
//     class router_env extends uvm_env;
//
// uvm_env, giong yapp_env / channel_env / hbus_env. Day la mot UVC env
// binh thuong -- chi khac la no la MODULE UVC, khong phai INTERFACE UVC.
//
// Phan biet (Section 11 slide 4):
//     Interface UVC : bam GIAO THUC  -> dung lai duoc
//     Module UVC    : bam DUT        -> KHONG dung lai duoc
// -----------------------------------------------------------------------------
class router_env extends uvm_env;



// ---- ENV-2 ------------------------------------------------------------------
// HAI handle component con.
//
//     // Router Reference
//     router_reference reference;
//
//     // Router Scoreboard
//     router_scoreboard scoreboard;
//
// *** TEN "reference" VA "scoreboard" SE XUAT HIEN O ***
//   - dong khai bao tren
//   - chuoi trong create()                     [ENV-4]
//   - connect_phase cua chinh file nay         [ENV-4]
//   - connect_phase cua router_tb              [RTB-3]
//       router_mod.reference.yapp_in
//       router_mod.scoreboard.sb_chan0
//
// Bon cho. Doi mot cho phai doi het.
// (Giai doan 2 se giam con hai cho -- do la loi ich cua export)
// -----------------------------------------------------------------------------
	router_reference reference;
	router_scoreboard scoreboard;



// ---- ENV-3 ------------------------------------------------------------------
// Macro + constructor.
//
//     `uvm_component_utils_begin(router_env)
//     `uvm_component_utils_end
//
//     //UVM Constructor
//     function new(input string name, input uvm_component parent=null);
//       super.new(name, parent);
//     endfunction : new
//
// *** VI SAO uvm_component_utils_BEGIN/END MA KHONG CO FIELD NAO ***
// [Suy luan] Repo viet dang begin/end nhung khong khai field nao giua
// hai dong. Tuong duong voi `uvm_component_utils(router_env) mot dong.
// Co le de san cho sau nay them field. Khong co khac biet chuc nang.
//
// *** TU KHOA "input" THUA ***
// input la chieu mac dinh cua doi so ham. Viet hay khong deu nhu nhau.
// Lai mot dau vet phong cach khong thong nhat cua repo.
// -----------------------------------------------------------------------------
`uvm_component_utils_begin(router_env)
  `uvm_component_utils_end

  //UVM Constructor
  function new(input string name, input uvm_component parent=null);
    super.new(name, parent);
  endfunction : new 



// ---- ENV-4 ------------------------------------------------------------------
// build_phase va connect_phase.
//
//     // UVM build_phase
//     function void build_phase(uvm_phase phase);
//       super.build_phase(phase);
//       scoreboard = router_scoreboard::type_id::create("scoreboard", this);
//       reference  = router_reference::type_id::create("reference", this);
//     endfunction : build_phase
//
//     // UVM connect_phase
//     function void connect_phase(uvm_phase phase);
//       reference.sb_add_out.connect(scoreboard.sb_yapp_in);
//     endfunction : connect_phase
//
//=============================================================================
// *** DONG connect_phase LA TRAI TIM CUA LAB 9B ***
//=============================================================================
//
//     reference.sb_add_out.connect(scoreboard.sb_yapp_in);
//     `--------+---------'          `--------+---------'
//           PORT (phat)                   IMP (nhan)
//
// Day la cho goi "da duoc loc" di tu reference sang scoreboard.
//
// *** NEU QUEN DONG NAY ***
//   - reference loc dung, in log dung, dem dung
//   - nhung KHONG GUI GI sang scoreboard
//   - scoreboard.packets_in = 0
//   - moi goi channel toi deu gap hang doi RONG
//   - "[EMPTY]: Received Unexpected Channel_0 Packet!" x12
//
// Trieu chung trong giong het "router drop HET moi goi".
// Phan biet: xem reference.packets_forwarded. Neu no > 0 ma
// scoreboard.packets_in == 0 -> loi o DAY NOI, khong o DUT.
//
// Day la Bay 2 trong README.
//
// *** THU TU create() CO QUAN TRONG KHONG? ***
// Repo tao scoreboard TRUOC reference. [Suy luan] Khong quan trong --
// connect_phase chay sau, va ca hai da ton tai luc do. Thu dao lai xem.
// -----------------------------------------------------------------------------
// UVM build_phase
  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    scoreboard = router_scoreboard::type_id::create("scoreboard", this);
    reference = router_reference::type_id::create("reference", this);
  endfunction : build_phase

  // UVM connect_phase
  function void connect_phase(uvm_phase phase);
    reference.sb_add_out.connect(scoreboard.sb_yapp_in);
  endfunction : connect_phase

endclass : router_env


//==============================================================================
// GIAI DOAN 2 (Buoc 7, TUY CHON) -- THEM EXPORT
//
// Lam SAU KHI giai doan 1 chay sach va Buoc 6 da PASSED.
// Day la bai hoc slide 20, khong bat buoc de lab chay.
//==============================================================================

// ---- ENV-5 ------------------------------------------------------------------
// NAM uvm_analysis_export -- "cong" cua Module UVC.
//
//     // reference model connectors
//     uvm_analysis_export #(hbus_transaction) hbus_in;
//     uvm_analysis_export #(yapp_packet)      yapp_in;
//
//     // scoreboard connectors
//     uvm_analysis_export #(channel_packet) sb_chan0;
//     uvm_analysis_export #(channel_packet) sb_chan1;
//     uvm_analysis_export #(channel_packet) sb_chan2;
//
// Va tao chung trong CONSTRUCTOR:
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
// *** EXPORT LA GI -- slide 20 ***
//=============================================================================
//
// Ba ky hieu, ba vai tro:
//
//   +--------+----------+---------------------+-------------------------+
//   | ky hieu| ten      | ai co               | lam gi                  |
//   +--------+----------+---------------------+-------------------------+
//   |  [ ]   | port     | ben PHAT, moi cap   | chuyen tiep LEN TREN    |
//   |  (O)   | imp      | ben NHAN, DUNG 1 cap| CHUA ham write()        |
//   |  |>    | export   | ben NHAN, cap tren  | chuyen tiep XUONG DUOI  |
//   +--------+----------+---------------------+-------------------------+
//
// Slide 20 nguyen van:
//   "export is required to route imp connectors to higher hierarchical levels"
//   "ONLY the component providing the implementation has an imp connector"
//   "All other connections on target side are export"
//
// *** CHU Y: export CHI co MOT tham so kieu ***
//     uvm_analysis_export #(yapp_packet)                      yapp_in;
//     uvm_analysis_imp_yapp #(yapp_packet, router_reference)  yapp_in;
//                                          ^^^^^^^^^^^^^^^^
//                                          imp can, export KHONG can
//
// Vi sao? export khong CHUA ham write() -- no chi chuyen tiep. Nen no
// khong can biet class nao co ham do.
//
// *** TEN TRUNG NHAU -- khong sao ***
// router_env.yapp_in (export) va router_reference.yapp_in (imp) cung
// ten. Chung o hai class khac nhau nen khong xung dot. Dat trung ten
// co chu y: de nguoi doc thay chung la MOT DUONG DI.
// -----------------------------------------------------------------------------




// ---- ENV-6 ------------------------------------------------------------------
// connect_phase MO RONG -- noi export xuong imp cua con.
//
//     function void connect_phase(uvm_phase phase);
//       hbus_in.connect(reference.hbus_in);
//       yapp_in.connect(reference.yapp_in);
//       sb_chan0.connect(scoreboard.sb_chan0);
//       sb_chan1.connect(scoreboard.sb_chan1);
//       sb_chan2.connect(scoreboard.sb_chan2);
//       reference.sb_add_out.connect(scoreboard.sb_yapp_in);
//     endfunction : connect_phase
//
//=============================================================================
// *** SAU DONG, BA KIEU NOI KHAC NHAU ***
//=============================================================================
//
//   hbus_in.connect(reference.hbus_in)        export ---> imp   (DI XUONG)
//   yapp_in.connect(reference.yapp_in)        export ---> imp   (DI XUONG)
//   sb_chan0.connect(scoreboard.sb_chan0)     export ---> imp   (DI XUONG)
//   sb_chan1.connect(...)                     export ---> imp
//   sb_chan2.connect(...)                     export ---> imp
//   reference.sb_add_out.connect(...)         port   ---> imp   (NGANG)
//
// Nam dong dau: tu VO BOC xuong RUOT.
// Dong cuoi: giua HAI CON cua cung mot cha.
//
// Day la doan code day du nhat ve TLM trong ca khoa hoc. Doc ky.
//
//=============================================================================
// *** LOI ICH: router_tb KHONG CAN BIET RUOT ***
//=============================================================================
//
//   KHONG co export (giai doan 1) -- router_tb phai viet:
//       chan0...connect(router_mod.scoreboard.sb_chan0);
//                                  ^^^^^^^^^^^^^^^^^^^^
//                       phai biet ben trong co "scoreboard"
//
//   CO export (giai doan 2) -- router_tb chi viet:
//       chan0...connect(router_mod.sb_chan0);
//                                  ^^^^^^^^
//                       chi can biet "cong" cua UVC
//
// Mai ban doi ten "scoreboard" thanh "sb", hoac tach no lam hai
// component -> router_tb KHONG PHAI SUA GI.
//
// Do la dong goi. Dung tinh than UVC cua Section 11.
//
// *** [Da xac minh] HAI BIEN THE TRONG REPO ***
//     lab09_sbb : router_env KHONG co export -> router_tb noi sau vao ruot
//     lab09_sbc : router_env CO export        -> router_tb noi vao cong
// Hai cach, cung ket qua mo phong. Khac nhau o kha nang bao tri.
// -----------------------------------------------------------------------------




//==============================================================================
// endclass : router_env
//==============================================================================


//==============================================================================
// TU KIEM TRA
//==============================================================================
//
// 1. Giai doan 1: dem so lenh connect trong connect_phase -> 1
//    Giai doan 2: dem lai -> 6
//    Nhung so DUONG DI du lieu that su co doi khong? Vi sao?
//
// 2. export khai 1 tham so kieu, imp khai 2. Giai thich bang chuc nang
//    cua moi loai.
//
// 3. Neu ban them export nhung QUEN noi chung o connect_phase, chuyen
//    gi xay ra? Loi bien dich hay im lang?
//    (Goi y: UVM co kiem tra "port/export chua noi" khong? Thu di)
//
// 4. router_env.yapp_in (export) va router_reference.yapp_in (imp) trung
//    ten. Trong print_topology() hai cai nay hien ra the nao? Phan biet
//    bang gi?
//
// 5. Ve lai so do ba muc cua slide 20 cho truong hop CU THE cua ban:
//        chan0 monitor [ ] --> |> router_env --> (O) scoreboard
//    Danh dau dung ky hieu cho tung chang. Co bao nhieu chang?
//
//==============================================================================
