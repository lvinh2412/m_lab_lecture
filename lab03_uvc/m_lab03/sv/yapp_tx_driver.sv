//------------------------------------------------------------------------------
// yapp_tx_driver.sv   --   LAB 3  (SKELETON)
//
// ***  FILE QUAN TRONG NHAT CUA LAB 3  ***
// Day la noi ban hien thuc BAT TAY TLM voi sequencer.
//
// Tham khao:  Section 6 slide 6  (port / export)
//             Section 6 slide 7  (4 buoc bat tay)
//             Section 6 slide 8  (code mau)
//------------------------------------------------------------------------------


// ---- DRV-1 -----------------------------------------------------------------
// Khai bao class.
//   - Ke thua lop UVM nao?
//   - CO type parameter -- tham so la gi?
//
// Ke thua dung se cho ban MIEN PHI hai thu:
//   (a) mot TLM port ten gi?        (Section 6 slide 6)
//   (b) mot handle co san ten gi?   (Section 6 slide 8 -- ban KHONG phai khai)
// ----------------------------------------------------------------------------
class yapp_tx_driver extends uvm_driver #(yapp_packet) ;


  // ---- DRV-2 ---------------------------------------------------------------
  // Macro + constructor.
  // --------------------------------------------------------------------------
	`uvm_component_utils_begin(yapp_tx_driver)
	`uvm_component_utils_end

	function new(string name, uvm_component parent);
		super.new(name, parent);
	endfunction

	function void start_of_simulation_phase(uvm_phase phase);
		`uvm_info(get_type_name(), {"start of simulation for ", get_full_name()}, UVM_HIGH);
	endfunction: start_of_simulation_phase



  // ---- DRV-3 ---------------------------------------------------------------
  // run_phase -- TRAI TIM cua driver.
  //
  // Cau truc:   forever begin  ... 3 dong ...  end
  //
  // Ba dong theo dung thu tu cua Section 6 slide 7:
  //   (1) XIN gói tiep theo tu sequencer
  //         - goi method gi?  tren object nao?
  //         - truyen bien nao vao?  (bien do ban co phai khai khong?)
  //   (2) GUI gói do di   -> goi task send_to_dut o duoi
  //   (3) BAO sequencer biet da xong
  //         - goi method gi?  tren object nao?
  //
  // CANH BAO: thieu dong (3) -> sequencer treo mai mai, mo phong dung o gói
  //           dau tien. KHONG co loi bien dich, chi "chay hoai khong ra gi".
  //
  // run_phase la function hay task?  Vi sao?
  // --------------------------------------------------------------------------

	task run_phase(uvm_phase phase);
		forever begin
			seq_item_port.get_next_item(req);
			send_to_dut(req);
			seq_item_port.item_done();
		end
	endtask : run_phase


  // ---- DRV-4 ---------------------------------------------------------------
  // send_to_dut -- "implements protocol"  (Section 6 slide 8)
  //
  // O LAB 3 chua co tin hieu that, nen chi can GIA LAP:
  //   (a) in noi dung gói ra log, verbosity UVM_LOW
  //         - dung macro nao?  dung sprint() hay print()?  vi sao?
  //           (Section 5 slide 17)
  //   (b) cho mot khoang thoi gian de gia lap protocol:   #10ns;
  //
  // Dau vao: mot handle kieu yapp_packet.
  // Day la task hay function?  (no co #10ns -> ???)
  //
  // LAB 6 se thay toan bo than ham nay bang drive tin hieu that.
  // --------------------------------------------------------------------------

	task send_to_dut(yapp_packet packet);
		`uvm_info(get_type_name(), $sformatf("Input Packet to Send:\n%s", packet.sprint()),UVM_LOW);
		#10ns;
	endtask : send_to_dut


endclass : yapp_tx_driver


//------------------------------------------------------------------------------
// BA CAU HOI SAU KHI VIET XONG:
//
//  1. Ban khong he khai bien nhan gói o DRV-3. Ten no la gi, va no tu dau ra?
//
//  2. seq_item_port nam o DRIVER, con seq_item_export nam o SEQUENCER.
//     Ben nao la ben CHU DONG goi?  (Section 6 slide 6: "pull-down")
//
//  3. forever khong bao gio thoat. Vay vi sao mo phong van ket thuc duoc?
//     (Goi y: get_next_item la blocking. Section 9 noi ro hon.)
//------------------------------------------------------------------------------
