//------------------------------------------------------------------------------
// router_tb.sv   --   LAB 3  (SKELETON)
//
// LAY FILE LAB 2 CUA BAN LAM GOC. Chi them 2 thu.
//
// O Lab 2, build_phase chi in mot dong log (vi chua co UVC nao).
// Gio da co YAPP UVC -> testbench phai khoi tao no.
//
// Tham khao:  Section 6 slide 12 (nua duoi)
//------------------------------------------------------------------------------

class router_tb extends uvm_env;

  `uvm_component_utils(router_tb)


  // ---- TB-1 ----------------------------------------------------------------
  // THEM: handle toi YAPP UVC.
  //   Kieu gi?  Ten bien gi?
  //
  //   LUU Y TEN: Section 6 slide 13 cho thay topology hien dong "yapp".
  //   Va Section 6 slide 14 dung duong dan  "tb.yapp.tx_agent.sequencer".
  //   Vay chuoi ten phai la gi?
  // --------------------------------------------------------------------------
	yapp_env yapp;


  function new (string name, uvm_component parent=null);
    super.new(name, parent);
  endfunction : new


  function void build_phase(uvm_phase phase);
    `uvm_info("MSG","In the build phase",UVM_HIGH)
	super.build_phase(phase);

    // ---- TB-2 --------------------------------------------------------------
    // THEM: tao instance cua YAPP UVC.
    //   Lab 3 dung new() hay type_id::create()?
    //   Doi so thu hai truyen gi?
    // ------------------------------------------------------------------------
	yapp = new("yapp", this);	

  endfunction : build_phase

    function void start_of_simulation_phase(uvm_phase phase);
		    `uvm_info(get_type_name(), {"start of simulation for ", get_full_name()}, UVM_HIGH)
	endfunction : start_of_simulation_phase
		  

endclass : router_tb
