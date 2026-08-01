#!/bin/bash

echo "Enter the ROM name in lowercase:"
read -p "> " ROM_NAME
echo -e "----------------------------------------\n"

DEVICES=("cupid" "diting" "mayfly" "thor" "unicorn" "zeus" "mondrian")
COMMON_DT="sm8450-common"
DEVICE_PATH="device/xiaomi"

for d in "$DEVICE_PATH/*/"; do
    DEVICE=$(basename "$d")
    if [ "$DEVICE" != "sm8450-common" ] && [ "$DEVICE" != "miuicamera-cupid" ]; then
        mv "$DEVICE_PATH/$DEVICE/lineage_$DEVICE.mk" "$DEVICE_PATH/$DEVICE/$ROM_NAME"_"$DEVICE".mk
        sed "s/lineage/$ROM_NAME/" "$DEVICE_PATH/$DEVICE/$ROM_NAME"_"$DEVICE".mk

        sed "s/lineage/$ROM_NAME/" "$DEVICE_PATH/$DEVICE/AndroidProducts.mk"

        mv "$DEVICE_PATH/$DEVICE/lineage.dependencies" "$DEVICE_PATH/$DEVICE/$ROM_NAME.dependencies"
    fi
done

mv "$DEVICE_PATH/$COMMON_DT/lineage.dependencies" "$DEVICE_PATH/$COMMON_DT/$ROM_NAME.dependencies"