#!/bin/bash

# Add ROM Flags
DEVICES=("cupid" "diting" "mayfly" "thor" "unicorn" "zeus")
for DEVICE in "${DEVICES[@]}"; do
    echo -e "\nTARGET_HAS_UDFPS := true
    TARGET_ENABLE_BLUR := true
    TARGET_SUPPORTS_QUICK_TAP := true
    BYPASS_CHARGE_SUPPORTED := true
    TARGET_BUILD_DEVICE_AS_WEBCAM := true\n" >> device/xiaomi/$DEVICE/lineage_$DEVICE.mk

    cp evolutionx/evolution_strings.xml device/xiaomi/$DEVICE/overlay/Settings/res/values
done