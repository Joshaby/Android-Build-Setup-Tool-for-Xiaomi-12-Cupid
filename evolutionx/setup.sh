#!/bin/bash

# Specific Device Tree

echo "Cloning device/xiaomi/cupid folder..."
git clone https://github.com/Joshaby/android_device_xiaomi_cupid.git -b lineage-23.2 device/xiaomi/cupid

echo "Cloning vendor/xiaomi/cupid folder..."
git clone https://github.com/TheMuppets/proprietary_vendor_xiaomi_cupid.git -b lineage-23.2 vendor/xiaomi/cupid
cd vendor/xiaomi/cupid
git revert --no-edit ecef9a3a5b8fe04f59d6ddcd8aaa86c9b15372ac
cd ../../../

echo "Cloning device/xiaomi/zeus folder..."
git clone https://github.com/LineageOS/android_device_xiaomi_zeus.git -b lineage-23.2 device/xiaomi/zeus


echo "Cloning vendor/xiaomi/zeus folder..."
git clone https://github.com/TheMuppets/proprietary_vendor_xiaomi_zeus.git -b lineage-23.2 vendor/xiaomi/zeus
cd vendor/xiaomi/zeus
git revert --no-edit 441a358e2dee6756409e5224b1db1c1611fd057a
cd ../../../

echo "Cloning device/xiaomi/mayfly folder..."
git clone https://github.com/LineageOS/android_device_xiaomi_mayfly.git -b lineage-23.2 device/xiaomi/mayfly

echo "Cloning vendor/xiaomi/mayfly folder..."
git clone https://github.com/TheMuppets/proprietary_vendor_xiaomi_mayfly.git -b lineage-23.2 vendor/xiaomi/mayfly
cd vendor/xiaomi/mayfly
git revert --no-edit ebec45ba24e9a3a33b9cff99336f19525c3c9700
cd ../../../

echo "Cloning device/xiaomi/unicorn folder..."
git clone https://github.com/LineageOS/android_device_xiaomi_unicorn.git -b lineage-23.2 device/xiaomi/unicorn

echo "Cloning vendor/xiaomi/unicorn folder..."
git clone https://github.com/TheMuppets/proprietary_vendor_xiaomi_unicorn.git -b lineage-23.2 vendor/xiaomi/unicorn
cd vendor/xiaomi/unicorn
git revert --no-edit 4e21c730562899b9469691eb2b88eaffb200223d
cd ../../../

echo "Cloning device/xiaomi/diting folder..."
git clone https://github.com/LineageOS/android_device_xiaomi_diting.git -b lineage-23.2 device/xiaomi/diting

echo "Cloning vendor/xiaomi/diting folder..."
git clone https://github.com/TheMuppets/proprietary_vendor_xiaomi_diting.git -b lineage-23.2 vendor/xiaomi/diting
cd vendor/xiaomi/diting
git revert -X theirs --no-edit 01d8ba67f9e8ba8cdcb403da40a8449f056cd4e1
cd ../../../

echo "Cloning device/xiaomi/thor folder..."
git clone https://github.com/LineageOS/android_device_xiaomi_thor.git -b lineage-23.2 device/xiaomi/thor

echo "Cloning vendor/xiaomi/diting folder..."
git clone https://github.com/TheMuppets/proprietary_vendor_xiaomi_thor.git -b lineage-23.2 vendor/xiaomi/thor
cd vendor/xiaomi/thor
git revert --no-edit 5ec2831e974cb23f6e35b80a6c4f5ca52755a54b
cd ../../../

# Common SM8450 Tree + MIUI/HyperOS Camera

echo "Cloning device/xiaomi/sm8450-common folder..."
git clone https://github.com/Joshaby/android_device_xiaomi_sm8450-common -b lineage-23.2 device/xiaomi/sm8450-common

echo "Cloning vendor/xiaomi/sm8450-common..."
git clone https://github.com/Joshaby/proprietary_vendor_xiaomi_sm8450-common.git -b lineage-23.2-gpu-driver-863.1 vendor/xiaomi/sm8450-common
cd vendor/xiaomi/sm8450-common
git revert --no-edit 0d9ad99ce69c7fe036167db442ac84cefd538af8
git revert --no-edit 318d03ec9da4ecc65faf42ab26cccb4a73784323
cd ../../../

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
git clone https://github.com/Joshaby/android_kernel_xiaomi_sm8450_test.git kernel/xiaomi/sm8450

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
curl -LSs "https://raw.githubusercontent.com/KernelSU-Next/KernelSU-Next/dev/kernel/setup.sh" | bash -s 5a4a71874caaad06aa126f761c93391de1d32361
cd KernelSU-Next
patch -p1 < ../../../../extras/ksu/wild-kernel-patches/wild/ksun-5a4a718-susfs-f7ae19ef-gki-android14-6.1.patch
cd ../

echo "Apply latest SusFS"
git clone https://gitlab.com/simonpunk/susfs4ksu.git -b gki-android12-5.10 ../../../extras/ksu/susfs
cd ../../../extras/ksu/susfs
git checkout 86114db0c49f20fa7857b8b559f3ab87cbc2d00d
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

echo "Apply LRNG v59"
git clone --depth=1 https://github.com/smuellerDD/lrng.git drivers/char/lrng/

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
# patch -p1 --forward < ../../../extras/ksu/wild-kernel-patches/common/add_limitation_scaling_min_freq.patch
# patch -p1 --forward < ../../../extras/ksu/wild-kernel-patches/common/adjust_cpu_scan_order.patch
patch -p1 --forward < ../../../extras/ksu/wild-kernel-patches/common/avoid_extra_s2idle_wake_attempts.patch
patch -p1 --forward < ../../../extras/ksu/wild-kernel-patches/common/disable_cache_hot_buddy.patch
patch -p1 --forward < ../../../extras/ksu/wild-kernel-patches/common/f2fs_enlarge_min_fsync_blocks.patch
patch -p1 --forward < ../../../extras/ksu/wild-kernel-patches/common/increase_ext4_default_commit_age.patch
patch -p1 --forward < ../../../extras/ksu/wild-kernel-patches/common/increase_sk_mem_packets.patch
# patch -p1 --forward < ../../../extras/ksu/wild-kernel-patches/common/re_write_limitation_scaling_min_freq.patch
patch -p1 --forward < ../../../extras/ksu/wild-kernel-patches/common/reduce_pci_pme_wakeups.patch
patch -p1 --forward < ../../../extras/ksu/wild-kernel-patches/common/silence_irq_cpu_logspam.patch
patch -p1 --forward < ../../../extras/ksu/wild-kernel-patches/common/silence_system_logspam.patch
# patch -p1 --forward < ../../../extras/ksu/wild-kernel-patches/common/use_unlikely_wrap_cpufreq.patch
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

# BBR TCP Congestion Control
echo "CONFIG_TCP_CONG_ADVANCED=y" >> "$defconfig"
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

# NTSync Support
echo "CONFIG_NTSYNC=y" >> "$defconfig"

# Configure ZRAM Writeback - Better memory management
echo "CONFIG_ZRAM_WRITEBACK=y" >> "$defconfig"
echo "CONFIG_ZRAM_MEMORY_TRACKING=y" >> "$defconfig"

# Enable Wakelock Blocker – Reduce idle battery drain
echo "CONFIG_PM_WAKELOCKS=y" >> "$defconfig"
echo "CONFIG_PM_WAKELOCKS_GC=y" >> "$defconfig"
echo "CONFIG_PM_WAKELOCKS_LIMIT=100" >> "$defconfig"
echo -e "/* palaziks: wakelock blocker list */
static const char * const blocked_wakelocks[] = {
    \"WLAN_pm_wlock\",
    \"IPA_WS\",
    \"qcom_rx_wakelock\",
    \"event0\",
};" >> kernel/power/wakelock.c

# Build Optimization Configuration
echo "CONFIG_CC_OPTIMIZE_FOR_PERFORMANCE=n" >> "$defconfig"
echo "CONFIG_CC_OPTIMIZE_FOR_PERFORMANCE_O3=y" >> "$defconfig"
echo "CONFIG_OPTIMIZE_INLINING=y" >> "$defconfig"

echo "Change Kernel Name"

# Kernel name
echo 'CONFIG_LOCALVERSION=""' >> "$defconfig"
echo "CONFIG_LOCALVERSION_AUTO=n" >> "$defconfig"
sed -i '217s/^[[:space:]]*echo "$res"[[:space:]]*$/res="${res\/-gki+\/}"\necho "$res"/' scripts/setlocalversion

echo "Fix build for Clang 22.X"

echo 'KBUILD_CFLAGS += -Wuninitialized' >> Makefile
echo 'KBUILD_CFLAGS += -Wno-sometimes-uninitialized' >> Makefile
echo 'KBUILD_CFLAGS += -Wuninitialized' >> Makefile
sed -i 's/^\([[:space:]]*const struct sde_pingpong_cfg \*pp_cfg\);/\1 = NULL;/' ../sm8450-modules/qcom/opensource/display-drivers/msm/sde/sde_rm.c
sed -i '/^[[:space:]]*struct sys_reg_desc clidr[[:space:]]*;/s/;$/ = { 0 };/' arch/arm64/kvm/sys_regs.c
sed -i 's/const char \*name;/const char \*name = NULL;/' drivers/input/misc/qcom-hv-haptics.c
sed -i 's/struct limits_freq_table \*cpu1_freq_table, \*cpu2_freq_table;/struct limits_freq_table *cpu1_freq_table = NULL, *cpu2_freq_table = NULL;/' drivers/thermal/qcom/cpu_voltage_cooling.c
sed -i 's/struct i2c_dev_desc \*i2cdev;/struct i2c_dev_desc *i2cdev = NULL;/' drivers/i3c/master.c
sed -i 's/&rpdev->driver_override/(const char **)\&rpdev->driver_override/' drivers/rpmsg/rpmsg_core.c
sed -i '72s/^/\/\//' kernel/sched/walt/sysctl.c
sed -i 's/sched_ignore_cluster_handler/proc_dointvec/g' kernel/sched/walt/sysctl.c

echo "Download Alchemist LLVM 22.X"

git clone https://gitlab.com/nekoshirro/Alchemist-LLVM.git -b clang-22-LTO prebuilts/clang/host/linux-x86/clang-alchemist

echo "Other things"

echo "Remove duplicated Dolby Atmos app"
cd ../../../
sed -i '/PRODUCT_PACKAGES += \\/{N;/\n    DolbyManager/d;}' hardware/dolby/dolby.mk

echo "Download keys for ROM signing"

git clone git@github.com:Joshaby/android_vendor_lineage-priv.git vendor/lineage-priv/keys
cp -rf vendor/lineage-priv/keys/.android-certs $HOME/

echo "Download kProfiles"
git clone https://github.com/KProfiles/android_packages_apps_KProfiles packages/apps/KProfiles

echo "Add MIUI Camera support"

for d in device/xiaomi/*/; do
    folder=$(basename "$d")
    if [ "$folder" != "diting" ] && [ "$folder" != "thor" ] && [ "$folder" != "sm8450-common" ] && [ "$folder" != "miuicamera-cupid" ]; then
        echo -e "\n# Miui Camera
        include device/xiaomi/miuicamera-cupid/BoardConfig.mk\n" >> "${d}BoardConfig.mk"

        echo -e "\n# Miui Camera
        \$(call inherit-product, device/xiaomi/miuicamera-cupid/device.mk)\n" >> "${d}device.mk"
    fi
done

echo "Setup Complete!"
