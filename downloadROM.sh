#!/bin/bash

# 1. Ask for Host, Port, User, and Password all at once (separated by space)
echo "Enter HOST, PORT, USERNAME and PASSWORD (separated by space):"
read -p "> " SSH_HOST SSH_PORT SSH_USER SSH_PASS

echo -e "----------------------------------------\n"

echo "Enter ROM name:"
read -p "> " ROM_NAME

echo -e "----------------------------------------\n"

echo "Enter ROM Folder name:"
read -p "> " ROM_FOLDER_NAME

echo -e "----------------------------------------\n"

# Hardcoded list of device folders from your image
DEVICES=("cupid" "diting" "mayfly" "thor" "unicorn" "zeus")
IMG_FILES=("boot" "dtbo" "recovery" "vendor_boot")

# Path definitions
REMOTE_PATH="/home/joshaby/$ROM_FOLDER_NAME/out/target/product"
TIMESTAMP=$(date +"%Y%m%d_%H%M%S")  
LOCAL_PATH="$HOME/ROMs/$ROM_FOLDER_NAME/$TIMESTAMP"                 

echo "Starting download..."

for DEVICE in "${DEVICES[@]}"; do

    # Create the local directory for this device
    LOCAL_DEST="$LOCAL_PATH/$DEVICE"
    mkdir -p "$LOCAL_DEST"

    # Variable with base device remote dir
    REMOTE_DIR="$REMOTE_PATH/$DEVICE"

    # Download IMG files
    for IMG_FILE in "${IMG_FILES[@]}"; do
        echo "----------------------------------------"
        echo "Downloading content from device $DEVICE - $IMG_FILE.img"
        echo "From: $REMOTE_DIR"
        echo "To:   $LOCAL_DEST"
        echo -e "----------------------------------------"

        # Download IMG file
        sshpass -p "$SSH_PASS" scp -P "$SSH_PORT" -o StrictHostKeyChecking=no "$SSH_USER@$SSH_HOST:$REMOTE_DIR/$IMG_FILE.img" "$LOCAL_DEST/"

        if [ $? -eq 0 ]; then
            echo -e "Success!\n"
        else
            echo -e "Error: Failed to download!\n"
        fi
    done

    echo "----------------------------------------"
    echo "Downloading content from device $DEVICE - $ROM_NAME*$DEVICE.zip"
    echo "From: $REMOTE_DIR"
    echo "To:   $LOCAL_DEST"
    echo -e "----------------------------------------"

    # Download ROM file
    sshpass -p "$SSH_PASS" scp -P "$SSH_PORT" -o StrictHostKeyChecking=no "$SSH_USER@$SSH_HOST:$REMOTE_DIR/$ROM_NAME*$DEVICE*.zip" "$LOCAL_DEST/"

    if [ $? -eq 0 ]; then
        echo -e "Success!\n"
    else
        echo -e "Error: Failed to download!\n"
    fi
done
