xvlog ./BaudRateGenerator.v  ./UartReceiver.v  ./UartTransmitter.v  ./customUartTop.v  ./tb_rx.v
xelab tb_rx -debug wave -s tb_rx
xsim tb_rx -gui -wdb simulate_xsim_tb_rx.wdb 
