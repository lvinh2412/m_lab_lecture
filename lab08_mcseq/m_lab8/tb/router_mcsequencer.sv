//------------------------------------------------------------------------------
// router_mcsequencer.sv   --   LAB 8  (SKELETON)   *** FILE MOI ***
//
// SEQUENCER AO (virtual sequencer / multichannel sequencer).
//
// File ngan nhat cua ca khoa hoc: khoang 10 dong, khong co mot dong
// logic nao. Nhung no la thu kho hieu nhat, vi no PHU DINH gan het
// moi thu ban biet ve sequencer.
//
// Tham khao: Section 12 slide 8 (buoc 1), slide 9
//------------------------------------------------------------------------------


// ---- MCS-1 ------------------------------------------------------------------
// Khai bao class.
//
//     class router_mcsequencer extends uvm_sequencer;
//                                     ^^^^^^^^^^^^^^
//                                     KHONG CO #(T)
//
// *** SLIDE 9 GHI RO: "No type parameterization" ***
//
// So sanh voi sequencer thuong ban da viet o Lab 3:
//
//     class yapp_tx_sequencer extends uvm_sequencer #(yapp_packet);
//                                                    `------+-----'
//                                            toi phat ra loai nay
//
// Tham so kieu ton tai de sequencer biet BA dieu:
//     (a) bien req trong sequence la kieu gi
//     (b) hang doi item chua kieu gi
//     (c) seq_item_export noi voi seq_item_port cua driver kieu gi
//
// Sequencer AO khong co ca ba. No KHONG phat transaction nao.
// => khong co kieu nao de dien vao.
//
// Cau hoi: neu ban viet "extends uvm_sequencer #(yapp_packet)" thi
//          co bien dich duoc khong? Co chay duoc khong? Sai o dau?
//          (Tra loi truoc khi thu)
// -----------------------------------------------------------------------------
class router_mcsequencer extends uvm_sequencer;



// ---- MCS-2 ------------------------------------------------------------------
// HAI con tro toi sequencer that cua UVC.
//
//     hbus_master_sequencer hbus_seqr;
//     yapp_tx_sequencer     yapp_seqr;
//
// *** DAY CHI LA CON TRO -- SLIDE 9: "Do NOT create these in build" ***
//
// Hai dong nay KHONG tao ra sequencer nao. Chung cho ra hai o nho
// de chua DIA CHI cua hai sequencer da ton tai san trong cac UVC.
//
// Viec gan dia chi lam o connect_phase cua router_tb  [RTB-3], khong
// lam o day.
//
// *** NEU BAN TRO TAY VIET create() ***
//
//     function void build_phase(uvm_phase phase);
//       yapp_seqr = yapp_tx_sequencer::type_id::create("yapp_seqr", this);
//     endfunction
//
// Cay se thanh:
//     router_tb
//       |-- mcsequencer
//       |     `-- yapp_seqr      <- sequencer MO COI, khong co driver
//       `-- yapp
//             `-- tx_agent
//                   |-- sequencer  <- sequencer THAT
//                   `-- driver
//
// `uvm_do_on chay tren cai mo coi -> start_item() goi wait_for_grant()
// -> cho driver goi get_next_item() -> khong co driver -> TREO MAI MAI.
// 0 goi, khong mot dong loi.
//
// Cach tu bat: print_topology(). Thay "sequencer" nam duoi mcsequencer
// la dinh bay.
//
// *** VI SAO CHI HAI, KHONG PHAI BON? ***
// Repo ghi comment giai thich. Doc va tu tra loi cau hoi 7 trong README:
// khi nao thi PHAI them con tro cho mot UVC?
// (Goi y: Channel UVC chi co MOT lua chon sequence; Clock/Reset cung vay)
// -----------------------------------------------------------------------------
	hbus_master_sequencer hbus_seqr;
	yapp_tx_sequencer     yapp_seqr;



// ---- MCS-3 ------------------------------------------------------------------
// Macro dang ky + constructor.
//
//     `uvm_component_utils(router_mcsequencer)
//
//     function new (string name, uvm_component parent);
//       super.new(name, parent);
//     endfunction : new
//
// Chu y: COMPONENT constructor -- hai doi so (name, parent).
// Khong phai object constructor mot doi so.
//
// Sequencer ao la COMPONENT. No xuat hien trong print_topology().
// (Khac voi multichannel SEQUENCE -- cai do la object, khong xuat hien)
//
// Dong `uvm_component_utils co BAT BUOC khong? Dieu gi hong neu thieu?
// (Goi y: test_mc dung router_mcsequencer::type_id::create(...) o dau?
//  Va factory tim class nay bang gi?)
// -----------------------------------------------------------------------------
`uvm_component_utils(router_mcsequencer)

	function new(string name, uvm_component parent);
		super.new(name, parent);
	endfunction : new


endclass : router_mcsequencer
//==============================================================================
// TU KIEM TRA SAU KHI VIET XONG
//==============================================================================
//
// 1. Dem so dong code that (khong tinh comment). Duoi 12 dong?
//    Neu nhieu hon, ban dang viet them thu gi khong can.
//
// 2. File nay co build_phase khong? Co connect_phase khong? Vi sao khong?
//
// 3. So sanh ba thu, dien vao bang:
//
//    +--------------------+------------------+------------------+
//    |                    | yapp_tx_sequencer| router_mcsequencer|
//    +--------------------+------------------+------------------+
//    | extends gi         |                  |                  |
//    | co #(T) khong      |                  |                  |
//    | co driver noi vao  |                  |                  |
//    | co hang doi item   |                  |                  |
//    | tao o dau          |                  |                  |
//    | noi bang cach nao  |                  |                  |
//    +--------------------+------------------+------------------+
//
// 4. File nay se duoc `include o dau? Truoc hay sau router_tb.sv?
//    Vi sao? (Xem [TB-1])
//==============================================================================
