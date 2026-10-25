//------------------------------------------------------------------------------
// router_test_lib.sv   --   LAB 3  (SKELETON)
//
// LAY FILE LAB 2 CUA BAN LAM GOC. Chi them MOT dong (nhung la dong
// quan trong nhat de "generate packets").
//
// Tham khao:  Section 6 slide 13 (duong dan phan cap)
//             Section 6 slide 14 (uvm_config_wrapper)
//------------------------------------------------------------------------------

class base_test extends uvm_test;

  `uvm_component_utils(base_test)

  router_tb tb;

  function new (string name, uvm_component parent);
    super.new(name, parent);
  endfunction : new


  function void build_phase(uvm_phase phase);
    super.build_phase(phase);

    // ---- TEST-1 ------------------------------------------------------------
    // *** THEM DONG NAY -- khong co no thi KHONG GOI NAO DUOC GUI ***
    //
    // Noi cho sequencer biet: trong run_phase, hay chay sequence nao.
    //
    // Cu phap (Section 6 slide 14):
    //
    //    uvm_config_wrapper::set( this,
    //                             "<DUONG DAN TOI SEQUENCER>.run_phase",
    //                             "default_sequence",
    //                             <TEN SEQUENCE>::get_type() );
    //
    // Hai cho ban phai dien:
    //
    //  (a) DUONG DAN -- tinh tu base_test di xuong.
    //      Doc tu topology report o Section 6 slide 13, bo "uvm_test_top".
    //      Dang:   tb . ??? . ??? . ???
    //      Dung dau "." ngan cach, KHONG co uvm_test_top o dau.
    //      Nho them  ".run_phase"  o cuoi.
    //
    //  (b) TEN SEQUENCE -- class ban viet o yapp_tx_seqs.sv.
    //
    // (Section 7 va 9 se giai thich co che nay. Lab 3 chi can dien dung.)
    // ------------------------------------------------------------------------
	uvm_config_wrapper::set(this,
   							"tb.yapp.tx_agent.sequencer.run_phase",
							"default_sequence",
							yapp_5_packets::get_type()	);


    tb = new("tb", this);

  endfunction : build_phase


  function void end_of_elaboration_phase(uvm_phase phase);
    uvm_top.print_topology();
  endfunction : end_of_elaboration_phase


  // ---- TEST-2 (tuy chon) ---------------------------------------------------
  // start_of_simulation_phase: in mot dong.
  // --------------------------------------------------------------------------
	function void start_of_simulation_phase(uvm_phase phase);
		    `uvm_info(get_type_name(), {"start of simulation for ", get_full_name()}, UVM_HIGH)
	endfunction : start_of_simulation_phase
		  

endclass : base_test


//==============================================================================
// test2 -- ke thua, khong them gi.  Giong het Lab 2.
//==============================================================================

class test2 extends base_test;

  `uvm_component_utils(test2)

  function new (string name, uvm_component parent);
    super.new(name, parent);
  endfunction : new

endclass : test2
