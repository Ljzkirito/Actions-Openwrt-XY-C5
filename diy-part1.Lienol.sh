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

# 使用官方ppp
rm -rf package/network/services/ppp
svn co https://github.com/openwrt/openwrt/trunk/package/network/services/ppp package/network/services/ppp

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

# 获取luci-app-smartdns
svn co https://github.com/kenzok8/openwrt-packages/trunk/luci-app-smartdns package/lean/luci-app-smartdns

#关机（增加关机功能）
#git clone https://github.com/esirplayground/luci-app-poweroff.git package/lean/luci-app-poweroff

# Remove UnblockNeteaseMusicGo upx commands
sed -i "/upx/d" package/lean/UnblockNeteaseMusicGo/Makefile || true
