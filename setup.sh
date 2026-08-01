#!/bin/bash

# Specific Device Tree

echo "Cloning device/xiaomi/cupid - Xiaomi 12 folder..."
git clone https://github.com/Joshaby/android_device_xiaomi_cupid.git -b lineage-23.2 device/xiaomi/cupid

echo "Cloning vendor/xiaomi/cupid - Xiaomi 12 folder..."
git clone https://github.com/TheMuppets/proprietary_vendor_xiaomi_cupid.git -b lineage-23.2 vendor/xiaomi/cupid

echo "Cloning device/xiaomi/zeus - Xiaomi 12 Pro folder..."
git clone https://github.com/LineageOS/android_device_xiaomi_zeus.git -b lineage-23.2 device/xiaomi/zeus

echo "Cloning vendor/xiaomi/zeus - Xiaomi 12 Pro folder..."
git clone https://github.com/TheMuppets/proprietary_vendor_xiaomi_zeus.git -b lineage-23.2 vendor/xiaomi/zeus

echo "Cloning device/xiaomi/mayfly - Xiaomi 12S folder..."
git clone https://github.com/LineageOS/android_device_xiaomi_mayfly.git -b lineage-23.2 device/xiaomi/mayfly

echo "Cloning vendor/xiaomi/mayfly - Xiaomi 12S folder..."
git clone https://github.com/TheMuppets/proprietary_vendor_xiaomi_mayfly.git -b lineage-23.2 vendor/xiaomi/mayfly

echo "Cloning device/xiaomi/unicorn - Xiaomi 12S Pro folder..."
git clone https://github.com/LineageOS/android_device_xiaomi_unicorn.git -b lineage-23.2 device/xiaomi/unicorn

echo "Cloning vendor/xiaomi/unicorn - Xiaomi 12S Pro folder..."
git clone https://github.com/TheMuppets/proprietary_vendor_xiaomi_unicorn.git -b lineage-23.2 vendor/xiaomi/unicorn

echo "Cloning device/xiaomi/diting - Xiaomi 12T Pro folder..."
git clone https://github.com/LineageOS/android_device_xiaomi_diting.git -b lineage-23.2 device/xiaomi/diting

echo "Cloning vendor/xiaomi/diting - Xiaomi 12T Pro folder..."
git clone https://github.com/TheMuppets/proprietary_vendor_xiaomi_diting.git -b lineage-23.2 vendor/xiaomi/diting

echo "Cloning device/xiaomi/thor - Xiaomi 12S Ultra folder..."
git clone https://github.com/LineageOS/android_device_xiaomi_thor.git -b lineage-23.2 device/xiaomi/thor

echo "Cloning vendor/xiaomi/thor - Xiaomi 12S Ultra  folder..."
git clone https://github.com/TheMuppets/proprietary_vendor_xiaomi_thor.git -b lineage-23.2 vendor/xiaomi/thor

echo "Cloning device/xiaomi/mondrian - Poco F5 Pro folder..."
git clone https://github.com/LineageOS/android_device_xiaomi_mondrian.git -b lineage-23.2 device/xiaomi/mondrian

echo "Cloning vendor/xiaomi/mondrian - Poco F5 Pro folder..."
git clone https://github.com/TheMuppets/proprietary_vendor_xiaomi_mondrian.git -b lineage-23.2 vendor/xiaomi/mondrian

# Common SM8450 Tree + MIUI/HyperOS Camera

echo "Cloning device/xiaomi/sm8450-common folder..."
git clone https://github.com/Joshaby/android_device_xiaomi_sm8450-common -b lineage-23.2 device/xiaomi/sm8450-common

echo "Cloning vendor/xiaomi/sm8450-common..."
git clone https://github.com/Joshaby/proprietary_vendor_xiaomi_sm8450-common.git -b lineage-23.2-gpu-driver-863.1 vendor/xiaomi/sm8450-common

echo "Cloning vendor/xiaomi/miuicamera-cupid folder..."
git clone https://github.com/Joshaby/proprietary_vendor_xiaomi_miuicamera-cupid.git -b lineage-23.2 vendor/xiaomi/miuicamera-cupid

echo "Cloning device/xiaomi/miuicamera-cupid folder..."
git clone https://github.com/Joshaby/android_device_xiaomi_miuicamera-cupid.git -b lineage-23.2 device/xiaomi/miuicamera-cupid

# Hardware Xiaomi + Dolby

echo "Cloning hardware/xiaomi folder..."
git clone https://github.com/Evolution-X-Devices/hardware_xiaomi -b bka hardware/xiaomi

echo "Cloning hardware/dolby folder..."
git clone https://github.com/rk134/hardware_dolby.git -b 15-ximi hardware/dolby

# SM8450 Kernel + DTS + Modules + KSU Next + SusFS + Performance Optimizations Patches

echo "Cloning kernel/xiaomi/sm8450 folder..."
git clone https://github.com/Joshabys-Xiaomi-12-Org/android_kernel_xiaomi_sm8450_test.git -b lineage-23.2 kernel/xiaomi/sm8450

echo "Cloning kernel/xiaomi/sm8450-devicetrees folder..."
git clone https://github.com/LineageOS/android_kernel_xiaomi_sm8450-devicetrees.git kernel/xiaomi/sm8450-devicetrees

echo "Cloning kernel/xiaomi/sm8450-modules folder..."
git clone https://github.com/LineageOS/android_kernel_xiaomi_sm8450-modules.git kernel/xiaomi/sm8450-modules

echo "Cloning Wild Kernel Patches"
git clone https://github.com/WildKernels/kernel_patches.git extras/ksu/wild-kernel-patches

echo "Apply ptrace patch for older kernels"
cd kernel/xiaomi/sm8450
patch -p1 -F 3 < ../../../extras/ksu/wild-kernel-patches/gki_ptrace.patch

echo "Add KernelSU Next Kernel"
curl -LSs "https://raw.githubusercontent.com/pershoot/KernelSU-Next/dev-susfs/kernel/setup.sh" | bash -s dev-susfs

echo "Apply latest SusFS"
git clone https://gitlab.com/simonpunk/susfs4ksu.git -b gki-android12-5.10 ../../../extras/ksu/susfs

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

echo "Apply LRNG v59"
git clone --depth=1 https://github.com/smuellerDD/lrng.git drivers/char/lrng/

echo "Apply SYSVIPC kABI fix for Droidspaces"
git clone --depth=1 https://github.com/ravindu644/Droidspaces-OSS.git droidspaces
patch -p1 < droidspaces/Documentation/resources/kernel-patches/GKI/below-kernel-6.12/001.GKI-below-6.12-fix_sysvipc_kabi_6_7_8.patch
patch -p1 < droidspaces/Documentation/resources/kernel-patches/GKI/below-kernel-6.12/002.5.10_or_lower_use_android_abi_padding_for_posix_mqueue.patch 

echo "Apply Kernel Configuration Flags and Performance Optimizations Patches"

patch -p1 --forward < ../../../extras/ksu/wild-kernel-patches/common/optimized_mem_operations.patch
patch -p1 --forward < ../../../extras/ksu/wild-kernel-patches/common/file_struct_8bytes_align.patch
patch -p1 --forward < ../../../extras/ksu/wild-kernel-patches/common/reduce_cache_pressure.patch
# patch -p1 --forward < ../../../extras/ksu/wild-kernel-patches/common/clear_page_16bytes_align.patch
patch -p1 --forward < ../../../extras/ksu/wild-kernel-patches/common/add_timeout_wakelocks_globally.patch
patch -p1 --forward < ../../../extras/ksu/wild-kernel-patches/common/f2fs_reduce_congestion.patch
patch -p1 --forward < ../../../extras/ksu/wild-kernel-patches/common/force_tcp_nodelay.patch
patch -p1 --forward < ../../../extras/ksu/wild-kernel-patches/common/int_sqrt.patch
patch -p1 --forward < ../../../extras/ksu/wild-kernel-patches/common/mem_opt_prefetch.patch
# patch -p1 --forward < ../../../extras/ksu/wild-kernel-patches/common/minimise_wakeup_time.patch
# patch -p1 --forward < ../../../extras/ksu/wild-kernel-patches/common/reduce_freeze_timeout.patch
patch -p1 --forward < ../../../extras/ksu/wild-kernel-patches/common/reduce_gc_thread_sleep_time.patch
patch -p1 --forward < ../../../extras/ksu/wild-kernel-patches/common/add_limitation_scaling_min_freq.patch
patch -p1 --forward < ../../../extras/ksu/wild-kernel-patches/common/adjust_cpu_scan_order.patch
# patch -p1 --forward < ../../../extras/ksu/wild-kernel-patches/common/avoid_extra_s2idle_wake_attempts.patch
patch -p1 --forward < ../../../extras/ksu/wild-kernel-patches/common/disable_cache_hot_buddy.patch
patch -p1 --forward < ../../../extras/ksu/wild-kernel-patches/common/f2fs_enlarge_min_fsync_blocks.patch
patch -p1 --forward < ../../../extras/ksu/wild-kernel-patches/common/increase_ext4_default_commit_age.patch
patch -p1 --forward < ../../../extras/ksu/wild-kernel-patches/common/increase_sk_mem_packets.patch
patch -p1 --forward < ../../../extras/ksu/wild-kernel-patches/common/re_write_limitation_scaling_min_freq.patch
patch -p1 --forward < ../../../extras/ksu/wild-kernel-patches/common/reduce_pci_pme_wakeups.patch
patch -p1 --forward < ../../../extras/ksu/wild-kernel-patches/common/silence_irq_cpu_logspam.patch
patch -p1 --forward < ../../../extras/ksu/wild-kernel-patches/common/silence_system_logspam.patch
patch -p1 --forward < ../../../extras/ksu/wild-kernel-patches/common/use_unlikely_wrap_cpufreq.patch
patch -p1 --forward < ../../../extras/ksu/wild-kernel-patches/common/unicode_bypass_fix_6.1-.patch
patch -p1 --forward < ../../../extras/ksu/wild-kernel-patches/common/ntsync/ntsync_base.patch
patch -p1 --forward < ../../../extras/ksu/wild-kernel-patches/common/ntsync/ntsync_compat_android12-5.10.patch

defconfig="./arch/arm64/configs/gki_defconfig"

# KernelSU Core Configuration
echo "CONFIG_KSU=y" >> "$defconfig"
echo "CONFIG_KSU_KPROBES_HOOK=n" >> "$defconfig"

# SUSFS Configuration
echo "CONFIG_KSU_SUSFS=y" >> "$defconfig"
echo "#CONFIG_KSU_SUSFS_HAS_MAGIC_MOUNT=y" >> "$defconfig"
echo "CONFIG_KSU_SUSFS_SUS_PATH=y" >> "$defconfig"
echo "CONFIG_KSU_SUSFS_SUS_MOUNT=y" >> "$defconfig"
echo "CONFIG_KSU_SUSFS_TRY_UMOUNT=y" >> "$defconfig"

# SUSFS Auto Mount Features
echo "CONFIG_KSU_SUSFS_AUTO_ADD_SUS_KSU_DEFAULT_MOUNT=y" >> "$defconfig"
echo "CONFIG_KSU_SUSFS_AUTO_ADD_SUS_BIND_MOUNT=y" >> "$defconfig"
echo "CONFIG_KSU_SUSFS_AUTO_ADD_TRY_UMOUNT_FOR_BIND_MOUNT=y" >> "$defconfig"

# SUSFS Advanced Features
echo "CONFIG_KSU_SUSFS_SUS_KSTAT=y" >> "$defconfig"
echo "CONFIG_KSU_SUSFS_SUS_OVERLAYFS=n" >> "$defconfig"
echo "CONFIG_KSU_SUSFS_SPOOF_UNAME=y" >> "$defconfig"
echo "CONFIG_KSU_SUSFS_SPOOF_CMDLINE_OR_BOOTCONFIG=y" >> "$defconfig"
echo "CONFIG_KSU_SUSFS_OPEN_REDIRECT=y" >> "$defconfig"
echo "CONFIG_KSU_SUSFS_SUS_MAP=y" >> "$defconfig"

# SUSFS Debugging and Security
echo "CONFIG_KSU_SUSFS_ENABLE_LOG=y" >> "$defconfig"
echo "CONFIG_KSU_SUSFS_HIDE_KSU_SUSFS_SYMBOLS=y" >> "$defconfig"

# KPatch Next Support
echo "CONFIG_KALLSYMS=y" >> "$defconfig"
echo "CONFIG_KALLSYMS_ALL=y" >> "$defconfig"

# Mountify Support
echo "CONFIG_TMPFS_XATTR=y" >> "$defconfig"
echo "CONFIG_TMPFS_POSIX_ACL=y" >> "$defconfig"

# Enable OverlayFS Support
echo "CONFIG_OVERLAY_FS=y" >> "$defconfig"

# BBG
echo "CONFIG_BBG=y" >> "$defconfig"

# LRNG v59
echo "CONFIG_LRNG=y" >> "$defconfig"
echo "CONFIG_LRNG_SHA256=y" >> "$defconfig"
echo "CONFIG_LRNG_COLLECTION_SIZE=1024" >> "$defconfig"
echo "CONFIG_LRNG_HEALTH_TESTS=y" >> "$defconfig"
echo "CONFIG_LRNG_RCT_CUTOFF=31" >> "$defconfig"
echo "CONFIG_LRNG_APT_CUTOFF=325" >> "$defconfig"
echo "CONFIG_LRNG_IRQ=y" >> "$defconfig"
echo "CONFIG_LRNG_CONTINUOUS_COMPRESSION_ENABLED=y" >> "$defconfig"

# Networking Configuration
echo "CONFIG_IP_NF_TARGET_TTL=y" >> "$defconfig"
echo "CONFIG_IP6_NF_TARGET_HL=y" >> "$defconfig"
echo "CONFIG_IP6_NF_MATCH_HL=y" >> "$defconfig"

# Add more TCP Congestion Control
echo "CONFIG_TCP_CONG_ADVANCED=y" >> "$defconfig"
echo "CONFIG_NET_SCH_FQ=y" >> "$defconfig"
echo "CONFIG_TCP_CONG_BIC=y" >> "$defconfig"
echo "CONFIG_TCP_CONG_WESTWOOD=y" >> "$defconfig"
echo "CONFIG_TCP_CONG_HTCP=y" >> "$defconfig"
echo "CONFIG_TCP_CONG_CUBIC=y" >> "$defconfig"

# Enable Traffic Shaping (Qdisc) Configs
echo "CONFIG_NET_SCH_FQ=y" >> "$defconfig"
echo "CONFIG_NET_SCH_FQ_CODEL=y" >> "$defconfig"
echo "CONFIG_NET_SCH_CAKE=y" >> "$defconfig"

# Enable Connection Marking Configs
echo "CONFIG_NET_ACT_CONNMARK=y" >> "$defconfig"

# Enable TTL/Hop Limit Target Configs
echo "CONFIG_IP_NF_TARGET_TTL=y" >> "$defconfig"
echo "CONFIG_IP6_NF_TARGET_HL=y" >> "$defconfig"
echo "CONFIG_IP6_NF_MATCH_HL=y" >> "$defconfig"

# Enable Wireguard VPN Configs
echo "CONFIG_WIREGUARD=y" >> "$defconfig"

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
echo "CONFIG_NETFILTER_XT_MATCH_ADDRTYPE=y" >> "$defconfig"
echo "CONFIG_NETFILTER_XT_SET=y" >> "$defconfig"
echo "CONFIG_NETFILTER_XT_TARGET_LOG=y" >> "$defconfig" 
echo "CONFIG_NETFILTER_XT_MATCH_RECENT=y" >> "$defconfig"
echo "CONFIG_IP6_NF_TARGET_MASQUERADE=y" >> "$defconfig"

# NTSync Support
echo "CONFIG_NTSYNC=y" >> "$defconfig"

# Configure ZRAM Writeback - Better memory management
echo "CONFIG_ZRAM_WRITEBACK=y" >> "$defconfig"
echo "CONFIG_ZRAM_MEMORY_TRACKING=y" >> "$defconfig"

# Droidspaces support
echo "CONFIG_IPC_NS=y" >> "$defconfig"
echo "CONFIG_PID_NS=y" >> "$defconfig"
echo "CONFIG_POSIX_MQUEUE=y" >> "$defconfig"
echo "CONFIG_IPC_NS=y" >> "$defconfig"
echo "CONFIG_DEVTMPFS=y" >> "$defconfig"
echo "CONFIG_BINFMT_MISC=y" >> "$defconfig"
echo "CONFIG_BINFMT_SCRIPT=y" >> "$defconfig"
echo "CONFIG_BINFMT_ELF=y" >> "$defconfig"

# Build Optimization Configuration
echo "CONFIG_CC_OPTIMIZE_FOR_PERFORMANCE=y" >> "$defconfig"
echo "CONFIG_CC_OPTIMIZE_FOR_PERFORMANCE_O3=n" >> "$defconfig"
# echo "CONFIG_OPTIMIZE_INLINING=y" >> "$defconfig"

echo "Change Kernel Name"

# Kernel name
echo 'CONFIG_LOCALVERSION=""' >> "$defconfig"
echo "CONFIG_LOCALVERSION_AUTO=n" >> "$defconfig"
sed -i '217s/^[[:space:]]*echo "$res"[[:space:]]*$/res="${res\/-gki+\/}"\necho "$res"/' scripts/setlocalversion

echo "Fix build for newer Clang"

echo 'KBUILD_CFLAGS += -Wuninitialized' >> Makefile
echo 'KBUILD_CFLAGS += -Wno-sometimes-uninitialized' >> Makefile
echo 'KBUILD_CFLAGS += -Wuninitialized' >> Makefile
sed -i '/^[[:space:]]*struct sys_reg_desc clidr[[:space:]]*;/s/;$/ = { 0 };/' arch/arm64/kvm/sys_regs.c
sed -i 's/struct i2c_dev_desc \*i2cdev;/struct i2c_dev_desc *i2cdev = NULL;/' drivers/i3c/master.c
sed -i 's/&rpdev->driver_override/(const char **)\&rpdev->driver_override/' drivers/rpmsg/rpmsg_core.c
sed -i '72s/^/\/\//' kernel/sched/walt/sysctl.c
sed -i 's/sched_ignore_cluster_handler/proc_dointvec/g' kernel/sched/walt/sysctl.c

echo "Download Alchemist LLVM 22.X"

git clone https://gitlab.com/nekoshirro/Alchemist-LLVM.git -b clang-22-LTO prebuilts/clang/host/linux-x86/clang-alchemist

echo "Download GreenForce Clang 24"
wget -P prebuilts/clang/host/linux-x86 https://github.com/greenforce-project/greenforce_clang/releases/download/20260727/gf-clang-24.0.0-20260727.tar.gz
tar -xvzf prebuilts/clang/host/linux-x86/gf-clang-24.0.0-20260727.tar.gz -C prebuilts/clang/host/linux-x86/clang-greenforce
ln -rs prebuilts/clang/host/linux-x86/clang-r574158/lib/clang/21/lib/x86_64-unknown-linux-gnu prebuilts/clang/host/linux-x86/clang-greenforce/lib/clang/24/lib/x86_64-unknown-linux-gnu 

echo "Other things"

echo "Remove duplicated Dolby Atmos app"
cd ../../../
sed -i '/PRODUCT_PACKAGES += \\/{N;/\n    DolbyManager/d;}' hardware/dolby/dolby.mk

# echo "Download keys for ROM signing"

# git clone git@github.com:Joshaby/android_vendor_lineage-priv.git vendor/lineage-priv/keys
# cp -rf vendor/lineage-priv/keys/.android-certs $HOME/

echo "Download kProfiles"
git clone https://github.com/KProfiles/android_packages_apps_KProfiles packages/apps/KProfiles

# echo "Add MIUI Camera support"

for d in device/xiaomi/*/; do
    folder=$(basename "$d")
    if [ "$folder" != "sm8450-common" ] && [ "$folder" != "miuicamera-cupid" ]; then
        echo -e "\n# Miui Camera
        include device/xiaomi/miuicamera-cupid/BoardConfig.mk\n" >> "${d}BoardConfig.mk"

        echo -e "\n# Miui Camera
        \$(call inherit-product, device/xiaomi/miuicamera-cupid/device.mk)\n" >> "${d}device.mk"
    fi
done

echo "Setup Complete!"
