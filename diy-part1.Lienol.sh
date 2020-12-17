#!/bin/bash
#
# Copyright (c) 2019-2020 P3TERX <https://p3terx.com>
#
# This is free software, licensed under the MIT License.
# See /LICENSE for more information.
#
# https://github.com/P3TERX/Actions-OpenWrt
# File name: diy-part1.sh
# Description: OpenWrt DIY script part 1 (Before Update feeds)
#

# 修改openwrt-luci为18.06分支
#sed -i 's/17.01/18.06/g' feeds.conf.default

# 拉取最新版argon主题
git clone -b 18.06 https://github.com/jerrykuku/luci-theme-argon.git package/lean/luci-theme-argon

# 同步lean package包
pushd package/lean
update_package_list="UnblockNeteaseMusic UnblockNeteaseMusicGo vlmcsd luci-app-unblockmusic"
for a in ${update_package_list}
do
	rm -rf "$a" && svn co https://github.com/coolsnowwolf/lede/trunk/package/lean/"$a"
done
popd

# Remove UnblockNeteaseMusicGo upx commands
sed -i "/upx/d" package/lean/UnblockNeteaseMusicGo/Makefile || true
