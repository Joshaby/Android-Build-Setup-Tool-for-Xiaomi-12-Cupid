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

echo "Add Wild Kernel"
curl -LSs "https://raw.githubusercontent.com/WildKernels/Wild_KSU/wild/kernel/setup.sh" | bash -s wild

echo "Apply latest SusFS"
# Apply core SUSFS patches
git clone https://gitlab.com/simonpunk/susfs4ksu.git -b gki-android12-5.10 ../../../extras/ksu/susfs
cd ../../../extras/ksu/susfs
git checkout a4c34e5877163b434a00c32b67c4e637f85a4c66
cd ../../../kernel/xiaomi/sm8450

cp -f ../../../extras/ksu/susfs/kernel_patches/fs/* fs
cp -f ../../../extras/ksu/susfs/kernel_patches/include/linux/* include/linux
patch -p1 -ui ../../../extras/ksu/susfs/kernel_patches/50_add_susfs_in_gki-android12-5.10.patch

echo "Apply Module Check Bypass"
cd kernel
sed -i '/bad_version:/{:a;n;/return 0;/{s/return 0;/return 1;/;b};ba}' module.c

echo "Apply BBG support"
cd ..
curl -LSs https://github.com/vc-teahouse/Baseband-guard/raw/main/setup.sh | bash
sed -i '/^config LSM$/,/^help$/{ /^[[:space:]]*default/ { /baseband_guard/! s/selinux/selinux,baseband_guard/ } }' security/Kconfig

echo "Apply Kernel Configuration Flags and Performance Optimizations Patches"

patch -p1 --forward < ../../../extras/ksu/wild-kernel-patches/common/optimized_mem_operations.patch
patch -p1 --forward < ../../../extras/ksu/wild-kernel-patches/common/file_struct_8bytes_align.patch
patch -p1 --forward < ../../../extras/ksu/wild-kernel-patches/common/reduce_cache_pressure.patch
patch -p1 --forward < ../../../extras/ksu/wild-kernel-patches/common/clear_page_16bytes_align.patch
patch -p1 --forward < ../../../extras/ksu/wild-kernel-patches/common/add_timeout_wakelocks_globally.patch
patch -p1 --forward < ../../../extras/ksu/wild-kernel-patches/common/f2fs_reduce_congestion.patch
patch -p1 --forward < ../../../extras/ksu/wild-kernel-patches/common/force_tcp_nodelay.patch
patch -p1 --forward < ../../../extras/ksu/wild-kernel-patches/common/int_sqrt.patch
patch -p1 --forward < ../../../extras/ksu/wild-kernel-patches/common/mem_opt_prefetch.patch
patch -p1 --forward < ../../../extras/ksu/wild-kernel-patches/common/minimise_wakeup_time.patch
patch -p1 --forward < ../../../extras/ksu/wild-kernel-patches/common/reduce_freeze_timeout.patch
patch -p1 --forward < ../../../extras/ksu/wild-kernel-patches/common/reduce_gc_thread_sleep_time.patch
patch -p1 --forward < ../../../extras/ksu/wild-kernel-patches/common/add_limitation_scaling_min_freq.patch
patch -p1 --forward < ../../../extras/ksu/wild-kernel-patches/common/adjust_cpu_scan_order.patch
patch -p1 --forward < ../../../extras/ksu/wild-kernel-patches/common/avoid_extra_s2idle_wake_attempts.patch
patch -p1 --forward < ../../../extras/ksu/wild-kernel-patches/common/disable_cache_hot_buddy.patch
patch -p1 --forward < ../../../extras/ksu/wild-kernel-patches/common/f2fs_enlarge_min_fsync_blocks.patch
patch -p1 --forward < ../../../extras/ksu/wild-kernel-patches/common/increase_ext4_default_commit_age.patch
patch -p1 --forward < ../../../extras/ksu/wild-kernel-patches/common/increase_sk_mem_packets.patch
patch -p1 --forward < ../../../extras/ksu/wild-kernel-patches/common/re_write_limitation_scaling_min_freq.patch
patch -p1 --forward < ../../../extras/ksu/wild-kernel-patches/common/reduce_pci_pme_wakeups.patch
patch -p1 --forward < ../../../extras/ksu/wild-kernel-patches/common/silence_irq_cpu_logspam.patch
patch -p1 --forward < ../../../extras/ksu/wild-kernel-patches/common/silence_system_logspam.patch
patch -p1 --forward < ../../../extras/ksu/wild-kernel-patches/common/use_unlikely_wrap_cpufreq.patch

defconfig="./arch/arm64/configs/gki_defconfig"

# KernelSU Core Configuration
echo "CONFIG_KSU=y" >> "$defconfig"
echo "CONFIG_KSU_SUSFS=y" >> "$defconfig"

# Mountify Support
echo "CONFIG_TMPFS_XATTR=y" >> "$defconfig"
echo "CONFIG_TMPFS_POSIX_ACL=y" >> "$defconfig"

#BBG
echo "CONFIG_BBG=y" >> "$defconfig"

# Networking Configuration
echo "CONFIG_IP_NF_TARGET_TTL=y" >> "$defconfig"
echo "CONFIG_IP6_NF_TARGET_HL=y" >> "$defconfig"
echo "CONFIG_IP6_NF_MATCH_HL=y" >> "$defconfig"

# BBR TCP Congestion Control
echo "CONFIG_TCP_CONG_ADVANCED=y" >> "$defconfig"
echo "CONFIG_TCP_CONG_BBR=y" >> "$defconfig"
echo "CONFIG_NET_SCH_FQ=y" >> "$defconfig"
echo "CONFIG_TCP_CONG_BIC=n" >> "$defconfig"
echo "CONFIG_TCP_CONG_WESTWOOD=n" >> "$defconfig"
echo "CONFIG_TCP_CONG_HTCP=n" >> "$defconfig"

# IPSet Support
echo "CONFIG_IP_SET=y" >> "$defconfig"
echo "CONFIG_IP_SET_MAX=65534" >> "$defconfig"
echo "CONFIG_IP_SET_BITMAP_IP=y" >> "$defconfig"
echo "CONFIG_IP_SET_BITMAP_IPMAC=y" >> "$defconfig"
echo "CONFIG_IP_SET_BITMAP_PORT=y" >> "$defconfig"
echo "CONFIG_IP_SET_HASH_IP=y" >> "$defconfig"
echo "CONFIG_IP_SET_HASH_IPMARK=y" >> "$defconfig"
echo "CONFIG_IP_SET_HASH_IPPORT=y" >> "$defconfig"
echo "CONFIG_IP_SET_HASH_IPPORTIP=y" >> "$defconfig"
echo "CONFIG_IP_SET_HASH_IPPORTNET=y" >> "$defconfig"
echo "CONFIG_IP_SET_HASH_IPMAC=y" >> "$defconfig"
echo "CONFIG_IP_SET_HASH_MAC=y" >> "$defconfig"
echo "CONFIG_IP_SET_HASH_NETPORTNET=y" >> "$defconfig"
echo "CONFIG_IP_SET_HASH_NET=y" >> "$defconfig"
echo "CONFIG_IP_SET_HASH_NETNET=y" >> "$defconfig"
echo "CONFIG_IP_SET_HASH_NETPORT=y" >> "$defconfig"
echo "CONFIG_IP_SET_HASH_NETIFACE=y" >> "$defconfig"
echo "CONFIG_IP_SET_LIST_SET=y" >> "$defconfig"

# Build Optimization Configuration
echo "CONFIG_CC_OPTIMIZE_FOR_PERFORMANCE=n" >> "$defconfig"
echo "CONFIG_CC_OPTIMIZE_FOR_PERFORMANCE_O3=y" >> "$defconfig"
echo "CONFIG_OPTIMIZE_INLINING=y" >> "$defconfig"

echo "Change Kernel Name"

# Kernel name
echo 'CONFIG_LOCALVERSION=""' >> "$defconfig"
echo "CONFIG_LOCALVERSION_AUTO=n" >> "$defconfig"
echo 'res="${res/-gki+/}"' >> scripts/setlocalversion
echo 'echo "$res-JoshaCore-WILDKSU+SUSFS"' >> scripts/setlocalversion