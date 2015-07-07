#!/system/bin/sh
# Copyright (c) 2012, The Linux Foundation. All rights reserved.
#
# Redistribution and use in source and binary forms, with or without
# modification, are permitted provided that the following conditions are
# met:
#     * Redistributions of source code must retain the above copyright
#       notice, this list of conditions and the following disclaimer.
#     * Redistributions in binary form must reproduce the above
#       copyright notice, this list of conditions and the following
#       disclaimer in the documentation and/or other materials provided
#       with the distribution.
#     * Neither the name of The Linux Foundation nor the names of its
#       contributors may be used to endorse or promote products derived
#      from this software without specific prior written permission.
#
# THIS SOFTWARE IS PROVIDED "AS IS" AND ANY EXPRESS OR IMPLIED
# WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF
# MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NON-INFRINGEMENT
# ARE DISCLAIMED.  IN NO EVENT SHALL THE COPYRIGHT OWNER OR CONTRIBUTORS
# BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR
# CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF
# SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR
# BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY,
# WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE
# OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN
# IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
#
#
chown -h root.system /sys/devices/platform/msm_hsusb/gadget/wakeup
chmod -h 220 /sys/devices/platform/msm_hsusb/gadget/wakeup

target=`getprop ro.board.platform`
build_type=`getprop ro.build.type`

#
# Check ESOC for external MDM
#
# Note: currently only a single MDM is supported
#
if [ -d /sys/bus/esoc/devices ]; then
for f in /sys/bus/esoc/devices/*; do
    if [ -d $f ]; then
        esoc_name=`cat $f/esoc_name`
        if [ "$esoc_name" = "MDM9x25" -o "$esoc_name" = "MDM9x35" ]; then
            esoc_link=`cat $f/esoc_link`
            break
        fi
    fi
done
fi

target=`getprop ro.board.platform`

#
# Allow USB enumeration with default PID/VID
#
baseband=`getprop ro.baseband`
debuggable=`getprop ro.debuggable`
echo 1  > /sys/class/android_usb/f_mass_storage/lun/nofua
usb_config=`getprop persist.sys.usb.config`
case "$usb_config" in
    "" | "adb" | "none") #USB persist config not set, select default configuration
      case "$esoc_link" in
          "HSIC")
              setprop persist.sys.usb.config diag,diag_mdm,serial_hsic,serial_tty,rmnet_hsic,mass_storage,adb
              setprop persist.rmnet.mux enabled
          ;;
          "HSIC+PCIe")
              setprop persist.sys.usb.config diag,diag_mdm,serial_hsic,rmnet_qti_ether,mass_storage,adb
          ;;
          "PCIe")
              setprop persist.sys.usb.config diag,diag_mdm,serial_tty,rmnet_qti_ether,mass_storage,adb
          ;;
          *)
              case "$target" in
                  "msm8916" | "msm8994" | "msm8909")
                      if [ -z "$debuggable" -o "$debuggable" = "1" ]; then
                          setprop persist.sys.usb.config mtp,adb
                      else
                          setprop persist.sys.usb.config mtp
                      fi
                  ;;
              esac
          ;;
      esac
    ;;
    * )
    ;; #USB persist config exists, do nothing
esac

#
# Do target specific things
#
case "$target" in
    "msm8974")
# Select USB BAM - 2.0 or 3.0
        echo ssusb > /sys/bus/platform/devices/usb_bam/enable
    ;;
    "apq8084")
	if [ "$baseband" == "apq" ]; then
		echo "msm_hsic_host" > /sys/bus/platform/drivers/xhci_msm_hsic/unbind
	fi
    ;;
    "msm8226")
         if [ -e /sys/bus/platform/drivers/msm_hsic_host ]; then
             if [ ! -L /sys/bus/usb/devices/1-1 ]; then
                 echo msm_hsic_host > /sys/bus/platform/drivers/msm_hsic_host/unbind
             fi
         fi
    ;;
    "msm8994")
        echo BAM2BAM_IPA > /sys/class/android_usb/android0/f_rndis_qc/rndis_transports
        echo 1 > /sys/class/android_usb/android0/f_rndis_qc/max_pkt_per_xfer # Disable RNDIS UL aggregation
    ;;
esac

#
# Add support for exposing lun0 as cdrom in mass-storage
#
cdromname="/system/etc/cdrom_install.iso"
platformver=`cat /sys/devices/soc0/hw_platform`
case "$target" in
	"msm8226" | "msm8610" | "msm8916")
		case $platformver in
			"QRD")
				echo "mounting usbcdrom lun"
				echo $cdromname > /sys/class/android_usb/android0/f_mass_storage/rom/file
				chmod 0444 /sys/class/android_usb/android0/f_mass_storage/rom/file
				;;
		esac
		;;
esac

#
# Initialize RNDIS Diag option. If unset, set it to 'none'.
#
diag_extra=`getprop persist.sys.usb.config.extra`
if [ "$diag_extra" == "" ]; then
	setprop persist.sys.usb.config.extra none
fi
