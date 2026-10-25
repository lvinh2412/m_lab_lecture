//------------------------------------------------------------------------------
// router_tb.sv   --   LAB 7  (SKELETON)
//
// Day la NHOM C cua quy trinh: khai + create UVC env.
//
// router_tb la "TESTBENCH ENVIRONMENT" -- lop chua TAT CA cac UVC.
// Lab 6 no chi chua mot (yapp). Lab 7 no chua NAM.
//
// Tham khao: Section 11 slide 6-9
//------------------------------------------------------------------------------

class router_tb extends uvm_env;

  `uvm_component_utils(router_tb)


  // ---- RTB-1 ----------------------------------------------------------------
  // KHAI BAO handle cho tung UVC env. Nam cai:
  //
  //     clock_and_reset_env  clock_and_reset;
  //     yapp_env             yapp;
  //     channel_env          chan0;
  //     channel_env          chan1;
  //     channel_env          chan2;
  //     hbus_env             hbus;
  //
  // (dem lai: sau handle, nhung channel dung chung mot KIEU -> bon kieu)
  //
  // *** TEN HANDLE = TEN TRONG DUONG DAN CONFIG ***
  // Ten ban dat o day phai khop voi:
  //     - chuoi truyen cho create()   (RTB-2..6)
  //     - duong dan vif trong tb_top  ("*.tb.chan0.*")
  //     - duong dan default_sequence trong test ("tb.chan?.rx_agent...")
  //
  // Bon cho, mot cai ten. Doi mot cho ma quen ba cho kia la loi im lang.
  // ---------------------------------------------------------------------------
	   clock_and_reset_env  clock_and_reset;
       yapp_env             yapp;
       channel_env          chan0;
       channel_env          chan1;
       channel_env          chan2;
       hbus_env             hbus;



  function new (string name, uvm_component parent = null);
    super.new(name, parent);
  endfunction : new


  function void build_phase(uvm_phase phase);
    super.build_phase(phase);

    // ---- RTB-2 --------------------------------------------------------------
    // CLOCK_AND_RESET env -- tao DAU TIEN.
    //
    //     clock_and_reset = clock_and_reset_env::type_id::create("clock_and_reset", this);
    //
    // Khong can config gi.
    //
    // *** VI SAO DAU TIEN? ***
    // [Suy luan] Thu tu create trong build_phase quyet dinh thu tu
    // build_phase CON chay (UVM build chay top-down, theo thu tu khai).
    // Clock phai san sang truoc cac UVC khac... nhung thuc ra build_phase
    // khong ton THOI GIAN MO PHONG nao (no chay het o t=0 truoc khi
    // run_phase bat dau).
    //
    // => Toi KHONG the khang dinh thu tu nay bat buoc. Repo viet vay,
    //    co the chi la quy uoc cho de doc.
    //    Ban co the thu dao lai va xem co hong khong -- mot thi nghiem tot.
    // -------------------------------------------------------------------------
	clock_and_reset = clock_and_reset_env::type_id::create("clock_and_reset", this);



    // ---- RTB-3 --------------------------------------------------------------
    // YAPP env -- GIU NGUYEN tu Lab 6:
    //
    //     yapp = yapp_env::type_id::create("yapp", this);
    // -------------------------------------------------------------------------
	yapp = yapp_env::type_id::create("yapp", this);



    // ---- RTB-4 --------------------------------------------------------------
    // BA CHANNEL env.   *** DAY LA PHAN CO NOI DUNG MOI ***
    //
    // Moi channel phai biet NO LA KENH SO MAY. Truyen qua config:
    //
    //     uvm_config_int::set(this, "chan0", "channel_id", 0);
    //     uvm_config_int::set(this, "chan1", "channel_id", 1);
    //     uvm_config_int::set(this, "chan2", "channel_id", 2);
    //
    //     chan0 = channel_env::type_id::create("chan0", this);
    //     chan1 = channel_env::type_id::create("chan1", this);
    //     chan2 = channel_env::type_id::create("chan2", this);
    //
    //=========================================================================
    // *** THU TU: BA LENH SET TRUOC, ROI BA LENH CREATE ***
    //=========================================================================
    //
    //   set(chan0) ... set(chan1) ... set(chan2) ...
    //   create(chan0) create(chan1) create(chan2)
    //
    // KHONG duoc viet xen ke kieu:
    //   create(chan0); set(chan0,...); create(chan1); set(chan1,...);
    //
    // Vi sao? create() goi new() -> new() goi build_phase cua con?
    //   KHONG. create() chi TAO DOI TUONG. build_phase cua chan0 chay
    //   SAU, khi UVM duyet cay.
    //
    //   Nhung set() phai nam truoc create() theo thu tu TEXT vi... that ra
    //   ca hai deu chay o build_phase cua router_tb, deu truoc build_phase
    //   cua chan0.
    //
    //   [Suy luan] => Ve ky thuat, dao thu tu set/create o day CO LE van
    //   chay dung, vi build_phase cua chan0 chi chay sau khi build_phase
    //   cua router_tb KET THUC HOAN TOAN.
    //
    //   Nhung repo viet set truoc. Va o LAB 4 ban da gap truong hop thu tu
    //   THAT SU quan trong (set trong base_test phai truoc super.build_phase).
    //
    //   *** BAI TAP: thu dao lai (create truoc, set sau) va chay. ***
    //   Neu van dung -> ban vua hoc duoc mot dieu ve khi nao thu tu quan
    //   trong va khi nao khong.
    //   Neu hong -> ghi lai thong bao loi, doc ky, hieu vi sao.
    //   Dang nao ban cung hoc duoc. Dung bo qua thi nghiem nay.
    //
    //=========================================================================
    // *** VI SAO CHANNEL_ID QUAN TRONG ***
    //=========================================================================
    //
    // [Da xac minh] channel/sv/channel_rx_monitor.sv co:
    //
    //     if (packet_collected.addr != channel_id)
    //       `uvm_error("CHANNEL_ID", ...)
    //
    // Doc ra: "goi den duoc kenh nay, nhung dia chi tren goi khong phai
    //          so hieu cua toi -> ROUTER DINH TUYEN SAI".
    //
    // *** DAY LA PHEP KIEM TRA CHUC NANG DAU TIEN CUA CA KHOA HOC. ***
    // Tu Lab 1 den Lab 6, ban chi KICH THICH DUT va QUAN SAT. Chua lan
    // nao testbench noi "DUT sai". Dong nay la lan dau.
    //
    // Hau qua neu set sai (vd ca ba deu la 0):
    //     - goi addr=0 di kenh 0 -> dung -> im lang
    //     - goi addr=1 di kenh 1 -> kenh 1 nghi minh la 0 -> UVM_ERROR
    //     - goi addr=2 di kenh 2 -> kenh 2 nghi minh la 0 -> UVM_ERROR
    // => loi bao o CHANNEL UVC nhung nguyen nhan o ROUTER_TB.
    //    Debug kieu nay la viec thuong ngay. Lam quen di.
    //
    // *** uvm_config_int LA GI (nhac lai Section 7) ***
    //     typedef uvm_config_db#(uvm_bitstream_t) uvm_config_int;
    // Dung cho so nguyen. Khac uvm_config_wrapper (cho sequence type)
    // va uvm_config_object (cho config object).
    // -------------------------------------------------------------------------

uvm_config_int::set(this, "chan0", "channel_id", 0); 	
uvm_config_int::set(this, "chan1", "channel_id", 1);
uvm_config_int::set(this, "chan2", "channel_id", 2);
                                                     
chan0 = channel_env::type_id::create("chan0", this);
chan1 = channel_env::type_id::create("chan1", this);
chan2 = channel_env::type_id::create("chan2", this);



    // ---- RTB-5 --------------------------------------------------------------
    // HBUS env -- co HAI config truoc khi create:
    //
    //     uvm_config_int::set(this, "hbus", "num_masters", 1);
    //     uvm_config_int::set(this, "hbus", "num_slaves",  0);
    //
    //     hbus = hbus_env::type_id::create("hbus", this);
    //
    // *** HBUS LA UVC CO SO AGENT THAY DOI DUOC ***
    //
    // Bon UVC kia: mot agent, co dinh.
    // HBUS: so agent do config quyet dinh. build_phase cua hbus_env
    // doc hai so nay roi chay vong lap tao tung ay agent.
    //
    // Hau qua ve CU PHAP: sequencer cua no nam trong MANG.
    //     yapp:  tb.yapp.tx_agent.sequencer
    //     hbus:  tb.hbus.masters[0].sequencer
    //                       ^^^^^^^^^^
    //
    // Ban se gap cu phap nay o Section 12 (virtual sequence) khi noi
    // mcsequencer.hbus_seqr = hbus.masters[0].sequencer;
    //
    // *** VI SAO num_slaves = 0? ***
    // Trong he thong nay, AI la master va ai la slave?
    //     testbench ghi thanh ghi cua router  -> testbench la MASTER
    //     router bi ghi                       -> router la SLAVE
    // Router la DUT, no la slave THAT, khong can UVC gia lam slave.
    // => 1 master (testbench), 0 slave (DUT da dong vai do).
    //
    // Neu dat num_slaves = 1: tao mot slave agent nua, no cung ngoi tren
    // bus, cung tra loi -> [Suy luan] co the tranh chap voi DUT tren bus.
    // Chua xac minh -- mot thi nghiem tot neu ban muon thu.
    //
    // *** TU KIEM TRA TEN TRUONG ***
    // "num_masters" / "num_slaves" la ten toi chep tu lab07_integ.
    // Doi chieu voi ben get:
    //     grep -n "num_masters\|num_slaves" ../../hbus/sv/hbus_env.sv
    // Go sai mot ky tu -> hbus_env dung gia tri mac dinh -> co the la
    // 0 master -> khong co sequencer nao -> test khong gui duoc gi.
    // -------------------------------------------------------------------------
	  uvm_config_int::set(this, "hbus", "num_masters", 1);
	  uvm_config_int::set(this, "hbus", "num_slaves", 0);
                                                    
    hbus = hbus_env::type_id::create("hbus", this);



  endfunction : build_phase

endclass : router_tb


//------------------------------------------------------------------------------
// TU KIEM TRA
//------------------------------------------------------------------------------
//
// 1. Lab 7 KHONG co connect_phase trong router_tb. Vi sao chua can?
//    (Goi y: cac UVC hien chay doc lap, chua ai noi chuyen voi ai.
//     Section 13 them scoreboard, Section 12 them virtual sequencer --
//     LUC DO moi can connect_phase. Doc truoc lab09_sb/tb/router_tb.sv
//     neu to mo.)
//
// 2. Dem lenh uvm_config_int::set trong file nay: 5 dong (3 channel_id
//    + 2 hbus). TAT CA deu dung context = "this".
//    Trong tb_top, 6 lenh vif set deu dung context = null.
//    Vi sao khac nhau?  (Section 10 slide 11)
//
// 3. Neu base_test cua ban co dong:
//        uvm_config_int::set(this, "tb.yapp.tx_agent", "is_active", UVM_ACTIVE);
//    thi no co anh huong gi den chan0/1/2 khong? Vi sao?
//    Muon chan0 thanh PASSIVE thi viet dong gi, o dau?
//
// 4. *** CAU HOI KIEN TRUC ***
//    router_tb chua nam UVC. Neu mai ban lam mot du an khac, dung lai
//    DUNG yapp UVC va channel UVC nhung khac DUT -- ban phai sua file nao?
//    router_tb? yapp/sv/? channel/sv/?
//    Cau tra loi cho thay tai sao Section 11 slide 4 phan biet
//    "Interface UVC (reusable)" va "Module UVC (khong reusable)".
//    router_tb thuoc loai nao?
//------------------------------------------------------------------------------
