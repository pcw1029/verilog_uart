#1. UART 송수신 모듈 

##1.1 송신부
###1.1.1. tx_busy가 low일 때 wr_en을 1로 설정하고, 보내고자 하는 1Byte 데이터 를 din[7:0]에 넣는다.
<img src="./images/verilog_uart_img2.PNG?raw=true" width="150%"/>

##1.2. UART 수신부
###1.2.1. rx_complete이 high이고, rx_error_bit[1:0]가 0이면 dout[7:0]에 1Byte의 데이터를 출력한다.
###1.2.2. rx_error_bit[1:0] 상태 정보
####1.2.2.1. rx_error_bit[1:0]가 0이면 정상
####1.2.2.2. rx_error_bit[1:0]가 1이면 데이터가 들어오지 않는 경우(UART Baudrate기준 clock이 8번 이상 지난 경우)
####1.2.2.3. rx_error_bit[1:0]가 1이면 2이면 stop bit가 비정상인 경우
<img src="./images/verilog_uart_img1.PNG?raw=true" width="150%"/>
