//------------------------------------------------------------------------------
// yapp_pkg.sv   --   LAB 3  (SKELETON)
//
// Package cua UVC. Nguoi dung import DUY NHAT file nay de dung ca UVC.
//
// Tham khao:  Section 6 slide 18  ("File order is important")
//             Section 3 slide 19  (Creating a UVM Package)
//------------------------------------------------------------------------------

package yapp_pkg;

  // ---- PKG-1 ---------------------------------------------------------------
  // Hai dong bat buoc, DUNG THU TU:
  //   (a) import thu vien UVM
  //   (b) include file macro cua UVM
  // (Lab 1 ban da lam roi -- xem lai yapp_pkg.sv cua Lab 1)
  // --------------------------------------------------------------------------
	import uvm_pkg::*;
	`include "uvm_macros.svh"


  // ---- PKG-2 ---------------------------------------------------------------
  // Include 7 file class cua UVC.
  //
  // *** THU TU QUAN TRONG ***  (Section 6 slide 18)
  // SystemVerilog KHONG co forward declaration cho class.
  // Compiler doc tuan tu -> class B tham chieu class A thi A phai duoc
  // dinh nghia TRUOC.
  //
  // Hay tu ve so do phu thuoc truoc khi viet:
  //
  //    - yapp_packet       phu thuoc gi?
  //    - yapp_tx_driver    tham so hoa bang gi?  -> phu thuoc ai?
  //    - yapp_tx_sequencer      ,,
  //    - yapp_tx_seqs           ,,
  //    - yapp_tx_monitor   phu thuoc gi?
  //    - yapp_tx_agent     khai handle toi nhung ai?  -> phu thuoc ai?
  //    - yapp_env          khai handle toi ai?        -> phu thuoc ai?
  //
  // Roi sap xep sao cho moi file deu dung SAU cac file no phu thuoc.
  //
  // (Co nhieu thu tu dung -- khong chi mot. Mien la rang buoc phu thuoc
  //  duoc ton trong.)
  // --------------------------------------------------------------------------

	`include "yapp_packet.sv"
	`include "yapp_tx_monitor.sv"
	`include "yapp_tx_sequencer.sv"
	`include "yapp_tx_seqs.sv"
	`include "yapp_tx_driver.sv"
	`include "yapp_tx_agent.sv"
	`include "yapp_env.sv"



endpackage : yapp_pkg
