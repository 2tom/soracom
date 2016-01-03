#!/bin/bash
lsusb

# USB modem device information
vendor=1c9e           # OMEGA TECHNOLOGY
product=6801          # 3G(FS01BU)
tty=/dev/ttyUSB2

init_modem()
{
  sudo usb_modeswitch -t <<EOF
DefaultVendor= 0x$1
DefaultProduct= 0x$2
TargetVendor= 0x$1
TargetProduct= 0x$2
MessageEndpoint= not set
MessageContent="55534243123456780000000080000606f50402527000000000000000000000"
NeedResponse=0
ResponseEndpoint= not set
Interface=0x00
EOF
  sudo modprobe usbserial vendor=0x$1 product=0x$2
  sudo modprobe -v option
    echo "$1 $2" | sudo tee /sys/bus/usb-serial/drivers/option1/new_id
}

dialup()
{
	echo waiting for modem device
        for i in {1..30}
        do
                [ -e $1 ] && break
                echo -n .
                sleep 1
        done
        [ $i = 30 ] && ( echo modem not found ; exit 1 )
        while [ 1 ] ; do sudo wvdial ; sleep 60 ; done
}

lsusb | grep $vendor:$product && \
        init_modem $vendor $product && \
        dialup $tty soracom.io sora sora
