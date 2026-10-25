//------------------------------------------------------------------------------
// router_tb.sv   --   LAB 2  (phien ban SKELETON)
//
// TESTBENCH CLASS.
// Tu Lab 3 tro di, day la noi chua cac UVC. O Lab 2 no con RONG --
// muc tieu chi la dung dung khung cua mot component.
//
// Tham khao:  Section 5 slide 6  (Component Template)
//             Section 5 slide 8  (Testbench Shell)
//             Section 4 slide 7  (Phase Method Reference)
//------------------------------------------------------------------------------


// ---- TODO-1 ----------------------------------------------------------------
// Khai bao class, ke thua lop UVM phu hop cho mot testbench.
// Goi y: Section 5 slide 8 ghi ro "No testbench subclass".
//        UVM KHONG co class ten uvm_testbench.
//        Vay chon lop nao? Section 1 slide 22 mo ta lop do la
//        "Basis for aggregating verification components around a DUT".
// ----------------------------------------------------------------------------
class router_tb extends uvm_env;


  // ---- TODO-2 --------------------------------------------------------------
  // Macro dang ky factory.
  // Day la COMPONENT hay OBJECT?  (Section 5 slide 5)
  // Can dang field automation khong, hay mot dong la du?
  // --------------------------------------------------------------------------
	`uvm_component_utils(router_tb)


  // ---- TODO-3 --------------------------------------------------------------
  // Constructor.
  //   - May doi so?  (Section 5 slide 6: "must use these arguments")
  //   - Co nen cho parent mot gia tri mac dinh khong?
  //   - Goi super nhu the nao?
  // --------------------------------------------------------------------------
	function new(string name, uvm_component parent);
		super.new(name, parent);
	endfunction : new


  // ---- TODO-4 --------------------------------------------------------------
  // build_phase.
  //   - Dong DAU TIEN bat buoc phai la gi?  (Section 4 slide 7)
  //   - Lab 2 chua co UVC nao de tao, nen hay in MOT dong log de chung minh
  //     phase nay that su chay.
  //       + Dung macro report nao?            (Section 5 slide 16)
  //       + id dat la gi?  message la gi?
  //       + verbosity nao de no CHI hien khi chay voi +UVM_VERBOSITY=UVM_HIGH?
  //                                             (Section 5 slide 17)
  // --------------------------------------------------------------------------

	function void build_phase(uvm_phase phase);
		super.build_phase(phase);
		`uvm_info("MSG", "Testbench build phase executed", UVM_HIGH)
	endfunction : build_phase


endclass : router_tb
