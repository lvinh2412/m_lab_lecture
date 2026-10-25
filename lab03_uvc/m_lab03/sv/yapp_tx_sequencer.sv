//------------------------------------------------------------------------------
// yapp_tx_sequencer.sv   --   LAB 3  (SKELETON)
//
// File NGAN NHAT cua UVC. Lam truoc tien de lay da.
//
// Tham khao:  Section 6 slide 9
//------------------------------------------------------------------------------


// ---- SEQR-1 ----------------------------------------------------------------
// Khai bao class.
//   - Ke thua lop UVM nao?
//   - CO type parameter hay KHONG?   (Section 6 slide 15: "only the active path")
//     Neu co thi tham so la gi?
// ----------------------------------------------------------------------------
class yapp_tx_sequencer extends uvm_sequencer #(yapp_packet) ;


  // ---- SEQR-2 --------------------------------------------------------------
  // Macro + constructor.  Giong het khuon component o Lab 2.
  // --------------------------------------------------------------------------
	`uvm_component_utils(yapp_tx_sequencer)

	function new(string name, uvm_component parent);
		super.new(name,parent);
	endfunction : new

	function void start_of_simulation_phase(uvm_phase phase);
		`uvm_info(get_type_name(), {"start of simulation for ", get_full_name()}, UVM_HIGH)
	endfunction : start_of_simulation_phase



endclass : yapp_tx_sequencer


//------------------------------------------------------------------------------
// CAU HOI SAU KHI VIET XONG:
//
//   Class nay KHONG co run_phase, KHONG co logic gi ca.
//   Vay no lam gi?  Tai sao van can no?
//
//   (Goi y Section 6 slide 9: "By default, a sequencer does not generate
//    a stimulus ... You must EXECUTE a sequence on the sequencer")
//------------------------------------------------------------------------------
