//------------------------------------------------------------------------------
// router_test_lib.sv   --   LAB 4  (SKELETON)
//
// Day la file thay doi nhieu nhat cua Lab 4.
// Lab 3 co 2 class (base_test, test2). Lab 4 co 4 class.
//
// Y tuong: base_test chua MOI THU DUNG CHUNG.
//          Ba test con chi khac nhau o DUNG MOT build_phase.
//          => Section 5 slide 9: "hierarchy-independent tests"
//
// Tham khao:  Section 7 slide 6-11  (configuration)
//             Section 8 slide 9-11  (factory)
//             Section 8 slide 14    (cu phap thay the)
//------------------------------------------------------------------------------


//==============================================================================
// base_test -- lop nen. Moi test khac deu dan xuat tu day.
//==============================================================================

class base_test extends uvm_test;

  `uvm_component_utils(base_test)

  router_tb tb;

  function new(string name, uvm_component parent);
    super.new(name, parent);
  endfunction : new


  function void build_phase(uvm_phase phase);
    super.build_phase(phase);

    // ---- TEST-1 ------------------------------------------------------------
    // Bat transaction recording cho MOI component trong cay.
    //
    // Section 7 slide 10 cho san dong nay. Dien vao:
    //
    //     uvm_config_int::set( this, "____", "________________", _ );
    //                                 (a)         (b)           (c)
    //
    //   (a) instance -- muon ap cho MOI component thi dien gi?
    //       (Section 7 slide 10 -- wildcard duoc phep o instance)
    //   (b) field    -- ten property. Sau khi chay, tim ten nay trong
    //                   topology report de kiem tra.
    //   (c) value    -- bat = ?
    //
    // Sau khi chay thanh cong, topology report se co dong nay lap lai
    // o MOI component. Do la cach ban biet no da an.
    // ------------------------------------------------------------------------
	uvm_config_int::set(this, "*", "recording_detail", 1);


    // ---- TEST-2 ------------------------------------------------------------
    // Lab 3 ban viet:   tb = new("tb", this);
    // Lab 4 doi sang factory create.
    //
    // Cau hoi: vi sao PHAI doi dong nay? base_test co bao gio bi override dau?
    // (Goi y: neu sau nay ban muon viet mot test dung router_tb_v2 thay cho
    //  router_tb ma khong sua base_test thi sao?)
    // ------------------------------------------------------------------------
	tb = router_tb::type_id::create("tb", this);


  endfunction : build_phase


  function void end_of_elaboration_phase(uvm_phase phase);
    uvm_top.print_topology();
  endfunction : end_of_elaboration_phase


  function void start_of_simulation_phase(uvm_phase phase);
    `uvm_info(get_type_name(), {"start of simulation for ", get_full_name()}, UVM_HIGH)
  endfunction : start_of_simulation_phase


  // ---- TEST-3 --------------------------------------------------------------
  // THEM check_phase, goi check_config_usage().
  //
  // Section 7 slide 11. Day la luoi an toan: no in ra nhung config setting
  // da duoc set nhung KHONG AI DOC -- tuc la sai duong dan hoac sai ten field.
  //
  // Cau hoi: vi sao dat o check_phase ma khong phai build_phase?
  //          (Goi y: thu tu phase -- khi nao thi "khong ai doc" moi la ket luan
  //           cuoi cung?)
  //
  // Chu y: check_phase la FUNCTION void, khong phai task.
  // --------------------------------------------------------------------------
	function void check_phase(uvm_phase phase);
		check_config_usage();
	endfunction : check_phase



endclass : base_test



//==============================================================================
// test2 -- khong them gi. Giong het Lab 3.
//==============================================================================

class test2 extends base_test;

  // ---- TEST-4 ----------------------------------------------------------
  // Hai thu bat buoc cho moi uvm_component:
  //   (a) macro dang ky factory
  //   (b) constructor -- goi super.new voi du 2 doi so
  //
  // Class nay KHONG co build_phase. No dung nguyen cua base_test.
  // Muc dich: chung minh base_test tu no da chay duoc.
  // ----------------------------------------------------------------------
	`uvm_component_utils(test2)

	function new(string name, uvm_component parent);
		super.new(name, parent);
	endfunction : new



endclass : test2



//==============================================================================
// short_packet_test -- TYPE OVERRIDE  (Section 8)
//
// Muc tieu: moi yapp_packet sinh ra trong test nay phai la short_yapp_packet.
//           KHONG duoc sua mot dong nao trong thu muc sv/.
//==============================================================================

class short_packet_test extends base_test;

  // ---- TEST-5 ----------------------------------------------------------
  // macro + constructor  (giong TEST-4)
  // ----------------------------------------------------------------------
	`uvm_component_utils(short_packet_test)

	function new(string name, uvm_component parent);
		super.new(name, parent); 
	endfunction : new



  function void build_phase(uvm_phase phase);

    // ---- TEST-6 --------------------------------------------------------
    // Ra lenh cho factory: tu gio, ai xin yapp_packet thi dua
    // short_yapp_packet.
    //
    // Co HAI cach viet, chon mot:
    //
    //   Dang 1 (Section 8 slide 10):
    //       set_type_override_by_type( ____::get_type(), ____::get_type() );
    //                                   (goc)             (thay the)
    //
    //   Dang 2 (Section 8 slide 14):
    //       ____::type_id::set_type_override( ____::get_type() );
    //        (goc)                             (thay the)
    //
    // *** VI TRI DONG NAY LA DIEM CHAM CUA CA BAI LAB ***
    // Doc Section 8 slide 11 va 16 truoc khi dat.
    // Goi y: "Overrides apply for all SUBSEQUENT calls to the factory"
    //        -- cay component duoc dung o dau?
    // --------------------------------------------------------------------
	yapp_packet::type_id::set_type_override(short_yapp_packet::get_type());


    // ---- TEST-7 --------------------------------------------------------
    // Goi build_phase cua lop cha.
    //
    // Day la cho base_test tao ra tb -> yapp -> tx_agent -> driver...
    // Tuc la TOAN BO cay duoc dung tai dong nay.
    //
    // Dat no TRUOC hay SAU TEST-6?  Tu tra loi roi moi viet.
    // --------------------------------------------------------------------
	super.build_phase(phase);


    // ---- TEST-8 --------------------------------------------------------
    // Chon sequence chay tren sequencer -- giong Lab 3 [TEST-1] cua ban.
    //
    //     uvm_config_wrapper::set( this,
    //                              "<duong dan sequencer>.run_phase",
    //                              "default_sequence",
    //                              <ten sequence>::get_type() );
    //
    // Duong dan: doc tu topology report, bo "uvm_test_top." o dau.
    //            Dang: tb . ??? . ??? . ???
    // Sequence : dung yapp_5_packets (ban da viet o Lab 3).
    //
    // Cau hoi: dong NAY co can dat truoc super.build_phase khong?
    //          Vi sao no khac TEST-6?
    //          (Goi y: config duoc doc luc nao -- Section 7 slide 8;
    //           con run_phase thi chay luc nao -- Section 4)
    // --------------------------------------------------------------------
	uvm_config_wrapper::set(this,
   							"tb.yapp.tx_agent.sequencer.run_phase",
							"default_sequence",
							yapp_5_packets::get_type()	);
  endfunction : build_phase

endclass : short_packet_test



//==============================================================================
// set_config_test -- CONFIGURATION  (Section 7)
//
// Muc tieu: dat tx_agent sang PASSIVE.
//           Ket qua: khong con driver va sequencer => khong goi nao duoc gui.
//==============================================================================

class set_config_test extends base_test;

  // ---- TEST-9 ----------------------------------------------------------
  // macro + constructor
  // ----------------------------------------------------------------------
	`uvm_component_utils(set_config_test)
	function new(string name, uvm_component parent);
		super.new(name, parent);
	endfunction : new



  function void build_phase(uvm_phase phase);

    // ---- TEST-10 -------------------------------------------------------
    // Dat is_active cua tx_agent thanh UVM_PASSIVE.
    //
    //     uvm_config_int::set( this, "__________", "_________", ___________ );
    //                                 (instance)     (field)      (value)
    //
    //  (a) instance: duong dan tu base_test xuong toi agent.
    //      *** LAY TU print_topology() CUA CHINH BAN, dung chep tu slide ***
    //      Slide Section 7 dung ten rut gon "agent", nhung lab that
    //      dung ten khac. Kiem tra cot Name.
    //
    //  (b) field: ten property. Viet y nguyen, KHONG duoc dung wildcard
    //      o day (Section 7 slide 10, luat 3).
    //
    //  (c) value: enum cua uvm_active_passive_enum.
    //
    // Neu go sai (a) hoac (b): mo phong van chay, 0 error, agent van ACTIVE,
    // va check_config_usage() cua ban se in [CFGNRD]. Do la bai test cho
    // TEST-3.
    // --------------------------------------------------------------------
	  uvm_config_int::set(this, "tb.yapp.tx_agent", "is_active", UVM_PASSIVE);


    // ---- TEST-11 -------------------------------------------------------
    // super.build_phase(phase);
    //
    // Dat truoc hay sau TEST-10?
    //
    // Section 7 slide 8:  config phai duoc set TRUOC khi component dich
    //                     duoc build.
    // Section 7 slide 9:  agent doc config trong super.build_phase() CUA NO.
    //
    // Agent duoc tao ra o dau trong chuoi goi nay? Lan nguoc len.
    // --------------------------------------------------------------------
	super.build_phase(phase);


  endfunction : build_phase

endclass : set_config_test



//==============================================================================
// TU KIEM TRA SAU KHI VIET XONG
//==============================================================================
//
// 1. Ba class short_packet_test, set_config_test, test2 deu extends base_test.
//    Ca ba co can viet lai end_of_elaboration_phase khong? Vi sao?
//
// 2. short_packet_test va set_config_test deu co build_phase rieng.
//    Dong super.build_phase(phase) trong HAI class do goi vao HAM NAO?
//
// 3. Neu ban quen super.build_phase(phase) trong short_packet_test thi
//    chuyen gi xay ra? Du doan truoc, roi thu that.
//
//==============================================================================
