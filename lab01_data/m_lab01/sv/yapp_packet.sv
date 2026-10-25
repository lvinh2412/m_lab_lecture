typedef enum bit {BAD_PARITY, GOOD_PARITY} parity_t;

class yapp_packet extends uvm_sequence_item;
 
	rand bit [5:0] length;
	rand bit [1:0] addr;
    rand bit [7:0] payload[];
		 bit [7:0] parity;

	// control fields
	rand int packet_delay;
	rand parity_t parity_type;

	`uvm_object_utils_begin(yapp_packet)
		`uvm_field_int	(length		,UVM_ALL_ON)
		`uvm_field_int  (addr     	,UVM_ALL_ON)
		`uvm_field_array_int  (payload     ,UVM_ALL_ON)
		`uvm_field_int	(parity		,UVM_ALL_ON)
		`uvm_field_enum	(parity_t	,parity_type	,UVM_ALL_ON)
		`uvm_field_int	(packet_delay	,UVM_ALL_ON |UVM_DEC|UVM_NOCOMPARE)	
	`uvm_object_utils_end

	function new (string name = "yapp_packet");
		super.new(name);
	endfunction : new

	// Deefault constraints
	constraint payload_size 	{ length == payload.size(); }
	constraint default_length	{ length > 0; length < 64;  }
	constraint pkt_delay		{ packet_delay > 1; packet_delay < 20; }

	constraint default_addr		{ addr != 'b11; }
	constraint default_parity  	{ parity_type dist {BAD_PARITY := 1, GOOD_PARITY := 5}; }

	// utility function
	function bit [7:0] calc_parity();
		calc_parity = {length, addr};

		foreach (payload[i])
			calc_parity = calc_parity ^ payload[i];
	endfunction : calc_parity

	// set parity
	function void set_parity();
		parity = calc_parity();
		if(parity_type == BAD_PARITY)
			parity++;
	endfunction : set_parity
	
	// post random
	function void post_randomize();
		set_parity();
	endfunction : post_randomize



endclass: yapp_packet
