set script_path [ file dirname [ file normalize [ info script ] ] ]
puts $script_path

set uartRx $script_path/src/UartReceiver.v
set uartTx $script_path/src/UartTransmitter.v
set uartTop $script_path/src/customUartTop.v
set uartBaudrate  $script_path/src/BaudRateGenerator.v

set uart_src [format "%s %s %s %s" $uartRx $uartTx $uartTop $uartBaudrate]
puts $uart_src

create_project verilog_uart $script_path -part xczu3eg-sfvc784-1-e
add_files -norecurse $uart_src 
update_compile_order -fileset sources_1

set_property SOURCE_SET sources_1 [get_filesets sim_1]
add_files -fileset sim_1 -norecurse $script_path/src/tb_rx.v
add_files -fileset sim_1 -norecurse $script_path/src/tb_tx.v
update_compile_order -fileset sim_1
