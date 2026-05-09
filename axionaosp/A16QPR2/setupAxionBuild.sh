#!/bin/bash

# Add ROM Flags

echo -e "\n# Camera information (multiple sensors supported)
AXION_CAMERA_REAR_INFO := 50,13,5
AXION_CAMERA_FRONT_INFO := 32

# Maintainer name (underscores become spaces in the UI)
AXION_MAINTAINER := Joshaby

# Processor name (underscores become spaces)
AXION_PROCESSOR := Snapdragon®_8_Gen_1

TARGET_IS_LOW_RAM ?= false

TARGET_SUPPORTED_REFRESH_RATES := 60,120

TARGET_ENABLE_BLUR := true

TARGET_INCLUDE_AXFX := true\n" >> device/xiaomi/cupid/lineage_cupid.mk

echo -e "\n# Camera information (multiple sensors supported)
AXION_CAMERA_REAR_INFO := 50,50,50
AXION_CAMERA_FRONT_INFO := 32

# Maintainer name (underscores become spaces in the UI)
AXION_MAINTAINER := Joshaby

# Processor name (underscores become spaces)
AXION_PROCESSOR := Snapdragon®_8_Gen_1

TARGET_IS_LOW_RAM ?= false

TARGET_SUPPORTED_REFRESH_RATES := 60,120

TARGET_ENABLE_BLUR := true

TARGET_INCLUDE_AXFX := true\n" >> device/xiaomi/zeus/lineage_zeus.mk

echo -e "\n# Camera information (multiple sensors supported)
AXION_CAMERA_REAR_INFO := 50,13,5
AXION_CAMERA_FRONT_INFO := 32

# Maintainer name (underscores become spaces in the UI)
AXION_MAINTAINER := Joshaby

# Processor name (underscores become spaces)
AXION_PROCESSOR := Snapdragon®_8+_Gen_1

TARGET_IS_LOW_RAM ?= false

TARGET_SUPPORTED_REFRESH_RATES := 60,120

TARGET_ENABLE_BLUR := true

TARGET_INCLUDE_AXFX := true\n" >> device/xiaomi/mayfly/lineage_mayfly.mk

echo -e "\n# Camera information (multiple sensors supported)
AXION_CAMERA_REAR_INFO := 50,50,50
AXION_CAMERA_FRONT_INFO := 32

# Maintainer name (underscores become spaces in the UI)
AXION_MAINTAINER := Joshaby

# Processor name (underscores become spaces)
AXION_PROCESSOR := Snapdragon®_8+_Gen_1

TARGET_IS_LOW_RAM ?= false

TARGET_SUPPORTED_REFRESH_RATES := 60,120

TARGET_ENABLE_BLUR := true

TARGET_INCLUDE_AXFX := true\n" >> device/xiaomi/unicorn/lineage_unicorn.mk

echo -e "\n# Camera information (multiple sensors supported)
AXION_CAMERA_REAR_INFO := 200,8,5
AXION_CAMERA_FRONT_INFO := 20

# Maintainer name (underscores become spaces in the UI)
AXION_MAINTAINER := Joshaby

# Processor name (underscores become spaces)
AXION_PROCESSOR := Snapdragon®_8+_Gen_1

TARGET_IS_LOW_RAM ?= false

TARGET_SUPPORTED_REFRESH_RATES := 60,120

TARGET_ENABLE_BLUR := true

TARGET_INCLUDE_AXFX := true\n" >> device/xiaomi/diting/lineage_diting.mk

echo -e "\n# Camera information (multiple sensors supported)
AXION_CAMERA_REAR_INFO := 50,48,48
AXION_CAMERA_FRONT_INFO := 32

# Maintainer name (underscores become spaces in the UI)
AXION_MAINTAINER := Joshaby

# Processor name (underscores become spaces)
AXION_PROCESSOR := Snapdragon®_8+_Gen_1

TARGET_IS_LOW_RAM ?= false

TARGET_SUPPORTED_REFRESH_RATES := 60,120

TARGET_ENABLE_BLUR := true

TARGET_INCLUDE_AXFX := true\n" >> device/xiaomi/thor/lineage_thor.mk