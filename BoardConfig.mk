#
# Copyright (C) 2014 The CyanogenMod Project
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#      http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#
BOARD_VENDOR := xiaomi

LOCAL_PATH := device/xiaomi/ferrari

# Include path
TARGET_SPECIFIC_HEADER_PATH := $(LOCAL_PATH)/include

# Init
TARGET_INIT_VENDOR_LIB := libinit_msm
TARGET_PLATFORM_DEVICE_BASE := /devices/soc.0/

# Bootloader
TARGET_BOOTLOADER_BOARD_NAME := MSM8916
TARGET_NO_BOOTLOADER := false
TARGET_NO_KERNEL := false

# Architecture
ifneq ($(FERRARI_32_BIT),true)
TARGET_ARCH := arm64
TARGET_ARCH_VARIANT := armv8-a
TARGET_CPU_ABI := arm64-v8a
TARGET_CPU_ABI2 :=
TARGET_CPU_VARIANT := generic

TARGET_2ND_ARCH := arm
TARGET_2ND_ARCH_VARIANT := armv7-a-neon
TARGET_2ND_CPU_ABI := armeabi-v7a
TARGET_2ND_CPU_ABI2 := armeabi
TARGET_2ND_CPU_VARIANT := cortex-a53

TARGET_BOARD_SUFFIX := _64
TARGET_USES_64_BIT_BINDER := true
else
TARGET_ARCH := arm
TARGET_ARCH_VARIANT := armv7-a-neon
TARGET_CPU_ABI := armeabi-v7a
TARGET_CPU_ABI2 := armeabi
TARGET_CPU_VARIANT := cortex-a53
endif
TARGET_BOARD_PLATFORM := msm8916
TARGET_BOARD_PLATFORM_GPU := qcom-adreno405

# Bionic Optimisation
TARGET_USE_QCOM_BIONIC_OPTIMIZATION := true

# CPU
TARGET_CPU_CORTEX_A53 := true

# ANT+
BOARD_ANT_WIRELESS_DEVICE := "vfs-prerelease"

# Kernel
BOARD_CUSTOM_BOOTIMG_MK            := $(LOCAL_PATH)/mkbootimg.mk
BOARD_MKBOOTIMG_ARGS               := --ramdisk_offset 0x02000000 --tags_offset 0x01E00000
BOARD_KERNEL_CMDLINE               := console=ttyHSL0,115200,n8 androidboot.console=ttyHSL0 androidboot.hardware=qcom msm_rtb.filter=0x237 ehci-hcd.park=3 androidboot.bootdevice=7824900.sdhci lpm_levels.sleep_disabled=1 earlyprintk
BOARD_KERNEL_SEPARATED_DT          := true
BOARD_KERNEL_BASE                  := 0x80000000
BOARD_KERNEL_PAGESIZE              := 2048
BOARD_KERNEL_TAGS_OFFSET           := 0x01E00000
BOARD_RAMDISK_OFFSET               := 0x02000000
TARGET_KERNEL_SOURCE               := kernel/xiaomi/ferrari
ifneq ($(FERRARI_32_BIT),true)
TARGET_KERNEL_ARCH := arm64
TARGET_KERNEL_CONFIG := ferrari_debug_defconfig
TARGET_KERNEL_CROSS_COMPILE_PREFIX := aarch64-linux-android-
TARGET_KERNEL_HEADER_ARCH := arm64
TARGET_USES_UNCOMPRESSED_KERNEL := true
else
TARGET_KERNEL_CONFIG := cyanogenmod_ferrari_defconfig
endif

# Audio
BOARD_USES_ALSA_AUDIO := true
TARGET_USES_QCOM_MM_AUDIO := true
AUDIO_FEATURE_ENABLED_MULTI_VOICE_SESSIONS := true

# Bluetooth
BOARD_BLUETOOTH_BDROID_BUILDCFG_INCLUDE_DIR := $(LOCAL_PATH)/bluetooth
BOARD_HAVE_BLUETOOTH := true
BOARD_HAVE_BLUETOOTH_QCOM := true
QCOM_BT_USE_SMD_TTY := true
BLUETOOTH_HCI_USE_MCT := true

# Camera
# TO DO - Put correct sensors and support
BOARD_CAMERA_SENSORS := imx135_cp8675 imx214_cp8675 ov5648_cp8675
TARGET_USE_VENDOR_CAMERA_EXT := true
USE_DEVICE_SPECIFIC_CAMERA := true

# Charger
BOARD_CHARGER_SHOW_PERCENTAGE := true
BOARD_CHARGER_ENABLE_SUSPEND := true

# Crypto
TARGET_HW_DISK_ENCRYPTION := true
TARGET_SWV8_DISK_ENCRYPTION := true

# Display
MAX_EGL_CACHE_KEY_SIZE := 12*1024
MAX_EGL_CACHE_SIZE := 2048*1024
NUM_FRAMEBUFFER_SURFACE_BUFFERS := 3
TARGET_GRALLOC_USES_ASHMEM := false
OVERRIDE_RS_DRIVER := libRSDriver_adreno.so
TARGET_CONTINUOUS_SPLASH_ENABLED := true
TARGET_USES_C2D_COMPOSITION := true
TARGET_USES_ION := true
TARGET_USE_ION_COMPAT := true
USE_OPENGL_RENDERER := true
HAVE_ADRENO_SOURCE:= false
VSYNC_EVENT_PHASE_OFFSET_NS := 7500000
SF_VSYNC_EVENT_PHASE_OFFSET_NS := 5000000
TARGET_USES_NEW_ION_API := true

# Flags
COMMON_GLOBAL_CFLAGS += -DNO_SECURE_DISCARD -DUSE_RIL_VERSION_10
COMMON_GLOBAL_CPPFLAGS += -DNO_SECURE_DISCARD -DUSE_RIL_VERSION_10

# CMHW
BOARD_USES_CYANOGEN_HARDWARE := true

# FM
TARGET_QCOM_NO_FM_FIRMWARE := true
AUDIO_FEATURE_ENABLED_FM := true

# Fonts
EXTENDED_FONT_FOOTPRINT := true

# GPS
TARGET_GPS_HAL_PATH := $(LOCAL_PATH)/gps
TARGET_NO_RPC := true

# Lights
TARGET_PROVIDES_LIBLIGHT := true

# LOGD
TARGET_USES_LOGD := false

# Malloc
MALLOC_IMPL := dlmalloc

# Partition
TARGET_USERIMAGES_USE_EXT4          := true
BOARD_BOOTIMAGE_PARTITION_SIZE      := 0x02000000
BOARD_RECOVERYIMAGE_PARTITION_SIZE  := 0x02000000
BOARD_SYSTEMIMAGE_PARTITION_SIZE    := 1744830464
BOARD_USERDATAIMAGE_PARTITION_SIZE  := 13144931840
BOARD_CACHEIMAGE_PARTITION_SIZE     := 402653184
BOARD_CACHEIMAGE_FILE_SYSTEM_TYPE   := ext4
BOARD_PERSISTIMAGE_PARTITION_SIZE   := 33554432
BOARD_PERSISTIMAGE_FILE_SYSTEM_TYPE := ext4
BOARD_FLASH_BLOCK_SIZE              := 131072 # BOARD_KERNEL_PAGESIZE * 64

# Power
TARGET_POWERHAL_VARIANT := qcom

# Recovery
RECOVERY_FSTAB_VERSION := 2
TARGET_RECOVERY_FSTAB := $(LOCAL_PATH)/rootdir/root/fstab.qcom
BOARD_USE_CUSTOM_RECOVERY_FONT := \"roboto_23x41.h\"
TARGET_RECOVERY_PIXEL_FORMAT := "RGBX_8888"
TARGET_RECOVERY_LCD_BACKLIGHT_PATH := \"/sys/class/leds/lcd-backlight/brightness\"
BOARD_HAS_NO_SELECT_BUTTON := true

# RIL
PROTOBUF_SUPPORTED := true
TARGET_RIL_VARIANT := caf
ADD_RADIO_FILES := true

# SELinux
include device/qcom/sepolicy/sepolicy.mk

# SELinux
BOARD_SEPOLICY_DIRS += \
    device/xiaomi/ferrari/sepolicy

BOARD_SEPOLICY_UNION += \
    bluetooth_loader.te \
    bootanim.te \
    file.te \
    file_contexts \
    healthd.te \
    property_contexts \
    qseecomd.te \
    surfaceflinger.te \
    system_app.te \
    system_server.te \
    system.te \
    wcnss_service.te

# Qualcomm support
BOARD_USES_QC_TIME_SERVICES := true
ifneq ($(QCPATH),)
BOARD_USES_QCNE := true
endif
BOARD_USES_QCOM_HARDWARE := true

# Vold
BOARD_VOLD_EMMC_SHARES_DEV_MAJOR := true
TARGET_USE_CUSTOM_LUN_FILE_PATH := /sys/devices/platform/msm_hsusb/gadget/lun0/file

# Video
TARGET_HAVE_SIGNED_VENUS_FW := true

# Wifi
BOARD_HAS_QCOM_WLAN              := true
BOARD_WLAN_DEVICE                := qcwcn
BOARD_HOSTAPD_DRIVER             := NL80211
BOARD_HOSTAPD_PRIVATE_LIB        := lib_driver_cmd_qcwcn
BOARD_WPA_SUPPLICANT_DRIVER      := NL80211
BOARD_WPA_SUPPLICANT_PRIVATE_LIB := lib_driver_cmd_qcwcn
WIFI_DRIVER_FW_PATH_AP           := "ap"
WIFI_DRIVER_FW_PATH_STA          := "sta"
WPA_SUPPLICANT_VERSION           := VER_0_8_X
TARGET_USES_QCOM_WCNSS_QMI       := true

# inherit from the proprietary version
-include vendor/xiaomi/ferrari/BoardConfigVendor.mk
