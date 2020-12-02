#!/bin/bash
#
# Copyright (c) 2019-2020 P3TERX <https://p3terx.com>
#
# This is free software, licensed under the MIT License.
# See /LICENSE for more information.
#
# https://github.com/P3TERX/Actions-OpenWrt
# File name: diy-part2.sh
# Description: OpenWrt DIY script part 2 (After Update feeds)
#

# 修改openwrt登陆地址
sed -i 's/192.168.1.1/192.168.2.1/g' package/base-files/files/bin/config_generate
# 版本号里显示一个自己的名字
sed -i "s/OpenWrt /Ljzkirito build $(TZ=UTC-8 date "+%Y.%m.%d") @ OpenWrt /g" package/default-settings/files/zzz-default-settings
#=================================================
# let pdnsd filter aaaa
mv $GITHUB_WORKSPACE/pdnsd-patch $GITHUB_WORKSPACE/openwrt/feeds/diy1/package/pdnsd-alt/patches
# 更新smartdns
rm -fr feeds/packages/net/smartdns
mv $GITHUB_WORKSPACE/smartdns $GITHUB_WORKSPACE/openwrt/feeds/packages/net
wget -O feeds/packages/net/smartdns/files/anti-ad-smartdns.conf https://raw.githubusercontent.com/privacy-protection-tools/anti-AD/master/anti-ad-smartdns.conf
# 修改 argon 为默认主题
sed -i 's/luci-theme-bootstrap/luci-theme-argon/g' feeds/luci/collections/luci/Makefile
#=================================================
# Add kernel build user
[ -z $(grep "CONFIG_KERNEL_BUILD_USER=" .config) ] &&
    echo 'CONFIG_KERNEL_BUILD_USER="Ljzkirito"' >>.config ||
    sed -i 's@\(CONFIG_KERNEL_BUILD_USER=\).*@\1$"Ljzkirito"@' .config
# Add kernel build domain
[ -z $(grep "CONFIG_KERNEL_BUILD_DOMAIN=" .config) ] &&
    echo 'CONFIG_KERNEL_BUILD_DOMAIN="GitHub Actions"' >>.config ||
    sed -i 's@\(CONFIG_KERNEL_BUILD_DOMAIN=\).*@\1$"GitHub Actions"@' .config
#=================================================
