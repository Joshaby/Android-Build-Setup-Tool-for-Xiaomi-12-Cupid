#!/bin/bash

. build/envsetup.sh

brunch lineage_cupid-bp4a-user -j$(nproc --all) && sleep 45 &&

brunch lineage_zeus-bp4a-user -j$(nproc --all) && sleep 45 &&

brunch lineage_mayfly-bp4a-user -j$(nproc --all) && sleep 45 &&

brunch lineage_unicorn-bp4a-user -j$(nproc --all) && sleep 45 &&

brunch lineage_diting-bp4a-user -j$(nproc --all) && sleep 45 &&

brunch lineage_thor-bp4a-user -j$(nproc --all)