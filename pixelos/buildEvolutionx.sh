#!/bin/bash

. build/envsetup.sh

breakfast cupid user  &&
m pixelos -j$(nproc --all) && sleep 45 &&

breakfast zeus user &&
m pixelos -j$(nproc --all) && sleep 45 &&

breakfast mayfly user &&
m pixelos -j$(nproc --all) && sleep 45 &&

breakfast unicorn user &&
m pixelos -j$(nproc --all) && sleep 45 &&

breakfast diting user &&
m pixelos -j$(nproc --all) && sleep 45 &&

breakfast thor user &&
m pixelos -j$(nproc --all)
