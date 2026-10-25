//------------------------------------------------------------------------------
// yapp_env.sv   --   LAB 3  (SKELETON)
//
// NOC CUA UVC.
//
// Section 6 slide 12 noi thang:  "You should have the knowledge to create
// this..."  -- vi no dung Y HET khuon router_tb ban da viet o Lab 2,
// chi khac la lan nay build_phase CO tao mot con.
//
// Tham khao:  Section 6 slide 12
//             Lab 2 router_tb.sv cua chinh ban
//------------------------------------------------------------------------------


// ---- ENV-1 -----------------------------------------------------------------
// Khai bao class. Ke thua lop nao?
// (So sanh: router_tb cua ban o Lab 2 ke thua gi?  Giong hay khac?)
// ----------------------------------------------------------------------------
class yapp_env extends uvm_env ;


  // ---- ENV-2 ---------------------------------------------------------------
  // Handle toi agent. Kieu gi, ten gi?
  //
  // LUU Y TEN: topology report o Section 6 slide 13 hien dong "tx_agent".
  //            Chuoi do den tu dau -- ten bien hay doi so cua new()?
  // --------------------------------------------------------------------------
	yapp_tx_agent tx_agent;



  // ---- ENV-3 ---------------------------------------------------------------
  // Macro + constructor.
  // --------------------------------------------------------------------------
	`uvm_component_utils(yapp_env)

	function new(string name, uvm_component parent);
		super.new(name, parent);
	endfunction : new


  // ---- ENV-4 ---------------------------------------------------------------
  // build_phase: super call, roi tao agent.
  // --------------------------------------------------------------------------
	function void build_phase(uvm_phase phase);
		super.build_phase(phase);
		tx_agent = new("tx_agent", this);
	endfunction : build_phase



  // ---- ENV-5 (tuy chon) ----------------------------------------------------
  // start_of_simulation_phase: in mot dong.
  // --------------------------------------------------------------------------
	function void start_of_simulation_phase(uvm_phase phase);
		`uvm_info(get_type_name(), {"start of simulation for ", get_full_name()}, UVM_HIGH)
	endfunction : start_of_simulation_phase


endclass : yapp_env
