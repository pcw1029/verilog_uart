xvlog ./BaudRateGenerator.v  ./UartReceiver.v  ./UartTransmitter.v  ./customUartTop.v  ./tb_tx.v
xelab tb_tx -debug wave -s tb_tx
xsim tb_tx -gui -wdb simulate_xsim_tb_tx.wdb 
