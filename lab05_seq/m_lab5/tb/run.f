
-64
-uvmhome $UVMHOME
-incdir ../sv
+UVM_VERBOSITY=UVM_LOW
//+UVM_TESTNAME=base_test
//+UVM_TESTNAME=short_packet_test
//+UVM_TESTNAME=incr_payload_test
+UVM_TESTNAME=exhaustive_seq_test
//+UVM_TESTNAME=set_config_test
//+UVM_TESTNAME=test2
//+SVSEED=random

../sv/yapp_pkg.sv
top.sv
