module top;
  import uvm_pkg::*;
  `include "uvm_macros.svh"
  import yapp_pkg::*;

  yapp_packet packet;
  yapp_packet copy_packet;
  yapp_packet clone_packet;

  uvm_table_printer custom = new();

  string name;
  int ok;

  initial begin
    copy_packet = new("copy_packet");
    for (int i=0; i<5; i++) begin
      packet = new($sformatf("packet%0d",i));
      ok = packet.randomize();
      packet.print();
    end
  end
endmodule : top
