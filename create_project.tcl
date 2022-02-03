create_project verilog_uart /home/pcw1029/projects/MTTS/hw/verilog_uart -part xczu3eg-sfvc784-1-e
add_files -norecurse {/home/pcw1029/projects/MTTS/hw/verilog_uart/src/UartReceiver.v /home/pcw1029/projects/MTTS/hw/verilog_uart/src/UartTransmitter.v /home/pcw1029/projects/MTTS/hw/verilog_uart/src/customUartTop.v /home/pcw1029/projects/MTTS/hw/verilog_uart/src/BaudRateGenerator.v}
update_compile_order -fileset sources_1

set_property SOURCE_SET sources_1 [get_filesets sim_1]
add_files -fileset sim_1 -norecurse /home/pcw1029/projects/MTTS/hw/verilog_uart/src/tb_rx.v
add_files -fileset sim_1 -norecurse /home/pcw1029/projects/MTTS/hw/verilog_uart/src/tb_tx.v
update_compile_order -fileset sim_1
