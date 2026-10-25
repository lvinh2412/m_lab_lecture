//------------------------------------------------------------------------------
// yapp_tx_agent.sv   --   LAB 3  (SKELETON)
//
// *** FILE KHO NHAT CUA LAB 3 ***
// Day la noi 3 khoi con duoc DUNG LEN va NOI voi nhau.
//
// Tham khao:  Section 6 slide 10  (khai bao)
//             Section 6 slide 11  (build + connect)
//             Section 1 slide 14  (y nghia cua active/passive)
//------------------------------------------------------------------------------


// ---- AGT-1 -----------------------------------------------------------------
// Khai bao class.
//   - Ke thua lop UVM nao?
//   - CO type parameter khong?  (Section 6 slide 15)
// ----------------------------------------------------------------------------
class yapp_tx_agent extends uvm_agent ;


  // ==========================================================================
  // *** BAY QUAN TRONG NHAT CUA CA LAB 3 ***
  //
  //   //uvm_active_passive_enum is_active = UVM_ACTIVE;
  //
  // Dong tren bi COMMENT RA co chu dich.
  // is_active DA CO SAN tu uvm_agent  (Section 6 slide 10:
  //   "uvm_agent defines BUILT-IN is_active switch").
  //
  // TUYET DOI KHONG bo comment / khong khai lai.
  // Neu khai lai, ban tao mot bien MOI che mat bien cua lop cha
  // -> configuration tu ben ngoai dat vao bien CHA,
  //    con build_phase cua ban doc bien CON
  // -> cau hinh KHONG CO TAC DUNG, va khong he co loi bien dich.
  // ==========================================================================


  // ---- AGT-2 ---------------------------------------------------------------
  // Khai 3 handle toi cac khoi con.
  //   Kieu gi?  Ten bien gi?
  //   (Ten se hien trong topology report -- xem Section 6 slide 13)
  // --------------------------------------------------------------------------

	yapp_tx_driver 	driver;
	yapp_tx_sequencer	sequencer;
	yapp_tx_monitor	monitor;


  // ---- AGT-3 ---------------------------------------------------------------
  // Macro dang ky.
  //   Lan nay KHONG dung dang mot dong -- phai dung dang _begin / _end.
  //   Vi sao?  Vi can nhet MOT field macro vao giua:
  //
  //       `uvm_field_enum( <kieu>, <ten field>, UVM_ALL_ON )
  //
  //   Field do la is_active. Muc dich (Section 6 slide 10):
  //   "Automate built-in field for debug" -- de is_active HIEN RA
  //   trong topology report.
  //
  //   Kieu cua is_active la gi?  (xem dong comment o phan BAY ben tren)
  // --------------------------------------------------------------------------

	`uvm_component_utils_begin(yapp_tx_agent)
		`uvm_field_enum(uvm_active_passive_enum, is_active, UVM_ALL_ON)
	`uvm_component_utils_end


  // ---- AGT-4 ---------------------------------------------------------------
  // Constructor.
  // --------------------------------------------------------------------------
	function new(string name, uvm_component parent);
		super.new(name, parent);
	endfunction : new



  // ---- AGT-5 ---------------------------------------------------------------
  // build_phase.  BA viec:
  //
  //   (a) super call                         <- "super.build_phase is essential!"
  //
  //   (b) tao MONITOR  -- NAM NGOAI if
  //         Vi sao ngoai?  (Section 1 slide 14: cai gi LUON phai ton tai?)
  //
  //   (c) if (is_active == UVM_ACTIVE) begin
  //           tao sequencer
  //           tao driver
  //       end
  //
  //   Lab 3 dung new() hay type_id::create()?
  //     -> Lab 3 van dung new().  Lab 4 moi doi sang create().
  //   new() cua component can may doi so?  Doi so thu hai truyen gi?
  // --------------------------------------------------------------------------
	function void build_phase(uvm_phase phase);
		super.build_phase(phase);
		monitor = new("monitor", this);
		if(is_active == UVM_ACTIVE) begin
			sequencer 	= new("sequencer", this);
			driver 		= new("driver", this);
		end
	endfunction : build_phase



  // ---- AGT-6 ---------------------------------------------------------------
  // connect_phase.  MOT dong (trong mot if).
  //
  //   Noi TLM port cua driver voi TLM export cua sequencer.
  //
  //   Cu phap (Section 6 slide 11):
  //       "Connect method is called FROM THE PORT and takes
  //        THE EXPORT as an argument"
  //       =>   <ai>.<port>.connect( <ai>.<export> );
  //
  //   Ten port o driver la gi?  Ten export o sequencer la gi?
  //       (Section 6 slide 6)
  //
  //   CAU HOI: co can bao if (is_active == UVM_ACTIVE) o day khong?
  //            Dieu gi xay ra neu agent la PASSIVE ma ban bo cai if?
  //
  //   connect_phase co can super call khong?  (Section 4 slide 7)
  // --------------------------------------------------------------------------
	function void connect_phase(uvm_phase phase);
		if(is_active == UVM_ACTIVE)
			driver.seq_item_port.connect(sequencer.seq_item_export);
	endfunction : connect_phase



  // ---- AGT-7 (tuy chon) ----------------------------------------------------
  // start_of_simulation_phase: in mot dong bao agent da san sang.
  // Mau quen thuoc:
  //     `uvm_info(get_type_name(), {"start of simulation for ",
  //                                  get_full_name()}, UVM_HIGH)
  // --------------------------------------------------------------------------
	function void start_of_simulation_phase(uvm_phase phase);
		`uvm_info(get_type_name(), {"start of simulation for ", get_full_name()}, UVM_HIGH)
	endfunction : start_of_simulation_phase



endclass : yapp_tx_agent
