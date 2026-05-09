#!/bin/bash

. build/envsetup.sh

axion cupid full user &&
ax -br -j$(nproc --all) &&

axion zeus full user &&
ax -br -j$(nproc --all) &&

axion mayfly full user &&
ax -br -j$(nproc --all) &&

axion unicorn full user &&
ax -br -j$(nproc --all) &&

axion diting full user &&
ax -br -j$(nproc --all) &&

axion thor full user &&
ax -br -j$(nproc --all)