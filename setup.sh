#!/bin/bash

echo "Cloning device/xiaomi/cupid folder..."
git clone https://github.com/Joshaby/android_device_xiaomi_cupid.git -b lineage-23.0 device/xiaomi/cupid

echo "Cloning device/xiaomi/sm8450-common folder..."
git clone https://github.com/Joshaby/android_device_xiaomi_sm8450-common device/xiaomi/sm8450-common

echo "Cloning vendor/xiaomi/sm8450-common..."
git clone https://github.com/Joshaby/proprietary_vendor_xiaomi_sm8450-common.git vendor/xiaomi/sm8450-common

echo "Cloning vendor/xiaomi/cupid folder..."
git clone https://github.com/TheMuppets/proprietary_vendor_xiaomi_cupid.git -b lineage-23.0 vendor/xiaomi/cupid

echo "Cloning vendor/xiaomi/miuicamera-cupid folder..."
git clone https://codeberg.org/dopaemon/proprietary_vendor_xiaomi_miuicamera-cupid.git -b lineage-22.2 vendor/xiaomi/miuicamera-cupid

echo "Cloning device/xiaomi/miuicamera-cupid folder..."
git clone https://github.com/cupid-development/android_device_xiaomi_miuicamera-cupid.git device/xiaomi/miuicamera-cupid

echo "Cloning hardware/xiaomi folder..."
git clone https://github.com/Evolution-X-Devices/hardware_xiaomi -b bka hardware/xiaomi

echo "Cloning hardware/dolby folder..."
git clone https://github.com/rk134/hardware_dolby.git -b 15-ximi hardware/dolby

echo "Cloning kernel/xiaomi/sm8450 folder..."
git clone https://github.com/LineageOS/android_kernel_xiaomi_sm8450.git kernel/xiaomi/sm8450

echo "Cloning kernel/xiaomi/sm8450-devicetrees folder..."
git clone https://github.com/Joshaby/android_kernel_xiaomi_sm8450-devicetrees.git kernel/xiaomi/sm8450-devicetrees

echo "Cloning kernel/xiaomi/sm8450-modules folder..."
git clone https://github.com/Joshaby/android_kernel_xiaomi_sm8450-modules.git kernel/xiaomi/sm8450-modules

echo "Cloning Wild Kernel Patches"
git clone https://github.com/WildKernels/kernel_patches.git extras/ksu/wild-kernel-patches

echo "Apply ptrace patch for older kernels"
cd kernel/xiaomi/sm8450
patch -p1 -F 3 < ../../../extras/ksu/wild-kernel-patches/gki_ptrace.patch

echo "Cloning Wild Kernel Patches"
git clone https://github.com/WildKernels/kernel_patches.git extras/ksu/wild-kernel-patches

echo "Apply ptrace patch for older kernels"
cd kernel/xiaomi/sm8450
patch -p1 -F 3 < ../../../extras/ksu/wild-kernel-patches/gki_ptrace.patch

echo "Add Wild Kernel"
curl -LSs "https://raw.githubusercontent.com/WildKernels/Wild_KSU/wild/kernel/setup.sh" | bash -s wild

echo "Apply latest SusFS"
# Apply core SUSFS patches
git clone https://gitlab.com/simonpunk/susfs4ksu.git -b gki-android12-5.10 ../../../extras/ksu/susfs

cp -f ../../../extras/ksu/susfs/kernel_patches/fs/* fs
cp -f ../../../extras/ksu/susfs/kernel_patches/include/linux/* include/linux
patch -p1 -ui ../../../extras/ksu/susfs/kernel_patches/50_add_susfs_in_gki-android12-5.10.patch

echo "Apply Module Check Bypass"
cd kernel
sed -i '/bad_version:/{:a;n;/return 0;/{s/return 0;/return 1;/;b};ba}' module.c

echo "Apply Kernel Configuration and Performance Optimizations Patches"
cd ..

patch -p1 --forward < ../../../extras/ksu/wild-kernel-patches/common/optimized_mem_operations.patch
patch -p1 --forward < ../../../extras/ksu/wild-kernel-patches/common/file_struct_8bytes_align.patch
patch -p1 --forward < ../../../extras/ksu/wild-kernel-patches/common/reduce_cache_pressure.patch
#sed -e 's/SYM_FUNC_START_PI(clear_page)/SYM_FUNC_START_PI(__pi_clear_page)/' ../../../extras/ksu/wild-kernel-patches/common/clear_page_16bytes_align.patch > ../../../extras/ksu/wild-kernel-patches/common/clear_page_16bytes_align__pi.patch
patch -p1 --forward < ../../../extras/ksu/wild-kernel-patches/common/clear_page_16bytes_align.patch

defconfig="./arch/arm64/configs/gki_defconfig"

# KernelSU Core Configuration
echo "CONFIG_KSU=y" >> "$defconfig"
echo "CONFIG_KSU_SUSFS=y" >> "$defconfig"

# Mountify Support
echo "CONFIG_TMPFS_XATTR=y" >> "$defconfig"
echo "CONFIG_TMPFS_POSIX_ACL=y" >> "$defconfig"

# Build Optimization Configuration
echo "CONFIG_CC_OPTIMIZE_FOR_PERFORMANCE=y" >> "$defconfig"
echo "CONFIG_CC_OPTIMIZE_FOR_PERFORMANCE_O3=n" >> "$defconfig"
echo "CONFIG_OPTIMIZE_INLINING=y" >> "$defconfig"