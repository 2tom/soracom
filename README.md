WiFi利用時のSORACOM設定
=======


## Environment
- Raspberry Pi 2 Model B
- 富士ソフト FS01BU
- SORACOM Air
- WiFiドングル(wlan0)

## 事前準備

```
1. FS01BUをさす
2. sshでRPi2へログイン
3. ドライバインストール
$ sudo apt-get update && sudo apt-get install -y wvdial usb-modeswitch cu
$ sudo apt-get upgrade

4. FS01BUのIDが 1c9e:6801 であることを確認
$ sudo lsusb
Bus 001 Device 002: ID 0424:9514 Standard Microsystems Corp.
Bus 001 Device 001: ID 1d6b:0002 Linux Foundation 2.0 root hub
Bus 001 Device 003: ID 0424:ec00 Standard Microsystems Corp.
Bus 001 Device 007: ID 1c9e:6801 OMEGA TECHNOLOGY ←　FS01BU
Bus 001 Device 004: ID 0403:6001 Future Technology Devices International, Ltd FT232 USB-Serial (UART) IC
Bus 001 Device 005: ID 2019:ab2a PLANEX GW-USNano2 802.11n Wireless Adapter [Realtek RTL8188CUS]

5. modprobe でUSBデバイスとして認識させる
$ sudo modprobe usbserial vendor=0x1c9e product=0x6801
$ echo "1c9e 6801" | sudo tee /sys/bus/usb-serial/drivers/option1/new_id
$ ls -l /dev/ttyU*
crw-rw---T 1 root dialout 188, 0  1月  1  1970 /dev/ttyUSB0
crw-rw---T 1 root dialout 188, 1  1月  3 16:27 /dev/ttyUSB1
crw-rw---T 1 root dialout 188, 2  1月  3 16:27 /dev/ttyUSB2
crw-rw---T 1 root dialout 188, 3  1月  3 16:27 /dev/ttyUSB3

6. 接続テスト
$ cu -l /dev/ttyUSB2
Connected.
ATI					←入力
Manufacturer: Fujisoft.inc
Model: FS01BU
Revision: FS01BU_FV1.0.0
IMEI: 356360043384278
+GCAP: +CGSM,+DS,+ES

~.					←入力

7. 再ログイン
$ ssh pi@***.***.***.***


7. wvdialの接続設定
$ sudo vi /etc/wvdial.conf
[Dialer Defaults]
Init1 = ATZ
Init2 = ATQ0 V1 E1 S0=0 &C1 &D2 +FCLASS=0
Dial Attempts = 3
Modem Type = Analog Modem
Dial Command = ATD
Stupid Mode = yes
Baud = 460800
New PPPD = yes
ISDN = 0
Phone = *99***1#
Carrier Check = no
Modem = /dev/ttyUSB2
APN = soracom.io
Username = sora
Password = sora
```


## 設定

```
1. 接続用スクリプトダウンロード
$ git clone https://github.com/2tom/soracom.git

$ cd soracom
$ chmod +x *.sh soracomair
$ ls -l
-rw-r--r-- 1 pi pi 2399  *月  * **:** README.md
-rwxr-xr-x 1 pi pi  551  *月  * **:** change_gw.sh
-rwxr-xr-x 1 pi pi  994  *月  * **:** connect_air.sh
-rwxr-xr-x 1 pi pi 1768  *月  * **:** soracomair

$ ./soracomair start

2. soracom無効化
$ ./soracomair stop
```
