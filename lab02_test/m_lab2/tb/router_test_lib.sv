//------------------------------------------------------------------------------
// router_test_lib.sv   --   LAB 2  (phien ban SKELETON)
//
// TEST LIBRARY: nhieu test class trong MOT file.
// Section 5 slide 9:  "Many test classes are declared in the same file"
//                     "Use inheritance to avoid describing hierarchy and
//                      settings for every test"
//
// Tham khao:  Section 5 slide 10  (router_test_lib.sv)
//             Section 5 slide 13  (UVM Hierarchy)
//             Section 5 slide 14  (Topology Report)
//------------------------------------------------------------------------------


//==============================================================================
// TEST 1 : base_test   --  test goc, dung toan bo phan cap
//==============================================================================

// ---- TODO-5 ----------------------------------------------------------------
// Ke thua lop UVM nao cho mot TEST?
// Goi y: nhin lai 7 o vang o Section 5 slide 5.
// ----------------------------------------------------------------------------
class base_test extends uvm_test ;


  // ---- TODO-6 --------------------------------------------------------------
  // Macro dang ky factory cho component.
  // --------------------------------------------------------------------------
	`uvm_component_utils(base_test)


  // ---- TODO-7 --------------------------------------------------------------
  // Handle toi testbench.
  //   - Kieu gi?  Ten bien gi?
  //   - Luu y: day moi chi la KHAI BAO handle (con tro), chua tao object.
  // --------------------------------------------------------------------------
	router_tb tb;	


  // ---- TODO-8 --------------------------------------------------------------
  // Constructor. Giong khuon o TODO-3.
  //   - Cau hoi: test co can parent mac dinh = null khong?
  //     (run_test() tao test voi parent = null -- Section 5 slide 13)
  // --------------------------------------------------------------------------
	function new(string name, uvm_component parent);
		super.new(name, parent);
	endfunction : new


  // ---- TODO-9 --------------------------------------------------------------
  // build_phase. Ba viec, DUNG THU TU:
  //   (a) super call
  //   (b) tao instance cua testbench va gan vao handle o TODO-7
  //         - Lab 2 dung new()  (Lab 4 moi doi sang type_id::create)
  //         - new() cua COMPONENT can may doi so?  Doi so thu hai truyen gi?
  //         - Chuoi ten nen dat la gi?  (xem Section 5 slide 14:
  //           topology report hien dong "tb" -- vay chuoi do tu dau ra?)
  //   (c) in mot dong log, verbosity UVM_HIGH
  // --------------------------------------------------------------------------
	function void build_phase(uvm_phase phase);
		super.build_phase(phase);
		tb = new("tb", this);
		`uvm_info("MSG", "Test build phase executed", UVM_HIGH);
	endfunction : build_phase


  // ---- TODO-10 -------------------------------------------------------------
  // end_of_elaboration_phase : in cay phan cap.
  //   - Goi method nao?            (Section 5 slide 13)
  //   - Goi tren object nao?       (ten instance cua uvm_root la gi?)
  //   - Vi sao dat o phase NAY ma khong phai build_phase hay run_phase?
  //        (Section 4 slide 6 mo ta phase nay la gi?)
  // --------------------------------------------------------------------------
	function void end_of_elaboration_phase(uvm_phase phase);
		uvm_top.print_topology();
	endfunction : end_of_elaboration_phase


endclass : base_test


//==============================================================================
// TEST 2 : test2   --  ke thua base_test, KHONG them gi
//
// Muc dich: chung minh y o Section 5 slide 9.
// Cau hoi truoc khi viet:
//    - Co phai khai lai handle tb khong?
//    - Co phai viet lai build_phase khong?
//    - Co phai viet lai end_of_elaboration_phase khong?
//    - Vay class nay can DUNG MAY thu?
//==============================================================================

// ---- TODO-11 ---------------------------------------------------------------
class test2 extends base_test ;

  // ---- TODO-12 -------------------------------------------------------------
  // Chi can hai thu. La hai thu nao?
  // --------------------------------------------------------------------------
	`uvm_component_utils(test2)

	function new(string name, uvm_component parent);
		super.new(name, parent);
	endfunction : new
	

endclass : test2
