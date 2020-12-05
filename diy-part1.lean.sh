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

# Uncomment a feed source
sed -i 's/^#\(.*helloworld\)/\1/' feeds.conf.default
# Change feed source
#sed -i 's/fw876\/helloworld/Mattraks\/helloworld;dev\/control/' feeds.conf.default
#sed -i 's/coolsnowwolf\/packages/openwrt\/packages/' feeds.conf.default
# Add a feed source
#sed -i '$a src-git lienol https://github.com/Lienol/openwrt-package' feeds.conf.default

# 获取luci-app-adguardhome
#git clone https://github.com/rufengsuixing/luci-app-adguardhome package/diy-packages/luci-app-adguardhome
svn co https://github.com/kenzok8/openwrt-packages/trunk/luci-app-adguardhome package/lean/luci-app-adguardhome
# 获取luci-app-passwall以及缺失的依赖
pushd package/lean
svn co https://github.com/xiaorouji/openwrt-passwall/trunk/luci-app-passwall
svn co https://github.com/xiaorouji/openwrt-passwall/trunk/ssocks
svn co https://github.com/xiaorouji/openwrt-passwall/trunk/trojan-go
svn co https://github.com/xiaorouji/openwrt-passwall/trunk/trojan-plus
svn co https://github.com/xiaorouji/openwrt-passwall/trunk/brook
svn co https://github.com/xiaorouji/openwrt-passwall/trunk/chinadns-ng
popd
# 清除旧版argon主题并拉取最新版
rm -rf package/lean/luci-theme-argon && git clone -b 18.06 https://github.com/jerrykuku/luci-theme-argon.git package/lean/luci-theme-argon
# 使用官方ppp
rm -rf package/network/services/ppp
svn co https://github.com/openwrt/openwrt/trunk/package/network/services/ppp package/network/services/ppp
# Use xiaorouji/openwrt-passwall/xray
rm -rf package/lean/xray
svn co https://github.com/xiaorouji/openwrt-passwall/trunk/xray package/lean/xray
# Remove UnblockNeteaseMusicGo upx commands
sed -i "/upx/d" package/lean/UnblockNeteaseMusicGo/Makefile || true
#===================================================================================================================================
#sed -i "/upx/d" package/lean/frp/Makefile || true
#sed -i "/upx/d" package/lean/v2ray-plugin/Makefile || true
#关机（增加关机功能）
#sed -i '$a src-git poweroff https://github.com/esirplayground/luci-app-poweroff.git' feeds.conf.default
#新的argon主题设置
#git clone https://github.com/jerrykuku/luci-app-argon-config package/lean/luci-app-argon-config
# 获取luci-app-smartdns
#svn co https://github.com/kenzok8/openwrt-packages/trunk/luci-app-smartdns package/lean/luci-app-smartdns
# 获取luci-app-serverchan
#git clone https://github.com/tty228/luci-app-serverchan package/diy-packages/luci-app-serverchan
# 获取luci-app-openclash 编译po2lmo
#git clone -b master https://github.com/vernesong/OpenClash package/openclash
#pushd package/openclash/luci-app-openclash/tools/po2lmo
#make && sudo make install
#popd
# 下载去广告文件anti-ad-for-dnsmasq.conf
#mkdir -p $GITHUB_WORKSPACE/files/etc/dnsmasq.d
#wget -O $GITHUB_WORKSPACE/files/etc/dnsmasq.d/anti-ad-for-dnsmasq.conf https://anti-ad.net/anti-ad-for-dnsmasq.conf
# v2ray 4.33.0
#sed -i 's/PKG_VERSION:=.*/PKG_VERSION:=4.33.0/g' package/lean/v2ray/Makefile
#sed -i 's/PKG_HASH:=.*/PKG_HASH:=ce456df0a798e1ed76ec014cb619e89c508bfb812c689260067575ee94e18c76/g' package/lean/v2ray/Makefil
