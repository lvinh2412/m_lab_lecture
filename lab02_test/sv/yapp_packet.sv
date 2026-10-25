typedef enum bit {BAD_PARITY, GOOD_PARITY} parity_t;

class yapp_packet extends uvm_sequence_item;
  rand bit [5:0] length;
  rand bit [1:0] addr;
  rand bit [7:0] payload [];
  bit      [7:0] parity;

  rand parity_t parity_type;
  rand int packet_delay;

  `uvm_object_utils_begin(yapp_packet)
    `uvm_field_int(length, UVM_ALL_ON)
    `uvm_field_int(addr, UVM_ALL_ON)
    `uvm_field_array_int(payload, UVM_ALL_ON)
    `uvm_field_int(parity, UVM_ALL_ON)
    `uvm_field_enum(parity_t, parity_type, UVM_ALL_ON)
    `uvm_field_int(packet_delay, UVM_ALL_ON |UVM_DEC|UVM_NOCOMPARE)
  `uvm_object_utils_end

  function new (string name = "yapp_packet");
    super.new(name);
  endfunction : new

  constraint default_length {length > 0; length < 64;}
  constraint payload_size   {length == payload.size();}
  constraint default_delay  {packet_delay >= 0; packet_delay < 20;}

  constraint default_parity {parity_type dist {BAD_PARITY := 1, GOOD_PARITY := 5};}
  constraint default_addr   {addr != 'b11;}

  // Calculates correct parity over the header and payload
  function bit [7:0] calc_parity();
    calc_parity = {length, addr};
    foreach (payload[i])
      calc_parity = calc_parity ^ payload[i];
  endfunction : calc_parity

  // Sets parity field according to parity_type
  function void set_parity();
    parity = calc_parity();
    if (parity_type == BAD_PARITY)
      parity++;
  endfunction : set_parity

  // post randomize() - sets parity
  function void post_randomize();
    set_parity();
  endfunction : post_randomize

endclass : yapp_packet
