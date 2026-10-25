//------------------------------------------------------------------------------
// yapp_tx_monitor.sv   --   LAB 3  (SKELETON)
//
// LUU Y: o Lab 3 monitor gan nhu RONG -- day la dung y do.
// Section 6 slide 4 ghi ro:  "Front end only -- Back-end connection to DUT
// is later".  Monitor chi co viec that su tu LAB 6, khi co virtual interface.
//
// O Lab 3, monitor chi can:
//   - ton tai trong cay phan cap  (de ban thay no trong topology report)
//   - in mot dong de chung minh run_phase cua no co chay
//
// Tham khao:  Section 6 slide 5 (vai tro cua monitor)
//------------------------------------------------------------------------------


// ---- MON-1 -----------------------------------------------------------------
// Khai bao class.
//   - Ke thua lop UVM nao cho monitor?
//   - CO type parameter khong?  Vi sao?
//     (Goi y: monitor co "cam" mot yapp_packet tu ai do dua cho khong,
//      hay no TU DUNG ra packet?  -- Section 6 slide 15)
// ----------------------------------------------------------------------------
class yapp_tx_monitor extends uvm_monitor ;


  // ---- MON-2 ---------------------------------------------------------------
  // Macro + constructor.
  // --------------------------------------------------------------------------
	`uvm_component_utils(yapp_tx_monitor)

	function new(string name, uvm_component parent);
		super.new(name, parent);
	endfunction : new

	function void start_of_simulation_phase(uvm_phase phase);
		`uvm_info(get_type_name(), {"star of simulation for ",get_full_name()}, UVM_HIGH)
	endfunction : start_of_simulation_phase

  // ---- MON-3 ---------------------------------------------------------------
  // run_phase: in MOT dong log, verbosity UVM_MEDIUM.
  //   - run_phase la function hay task?   (Section 4 slide 7)
  // --------------------------------------------------------------------------
	task run_phase(uvm_phase phase);
		`uvm_info(get_type_name(), "Inside the run_phase", UVM_MEDIUM);
	endtask : run_phase


endclass : yapp_tx_monitor
