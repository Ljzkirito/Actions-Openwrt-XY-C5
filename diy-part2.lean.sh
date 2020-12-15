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
sed -i "s/OpenWrt/Ljzkirito build $(TZ=UTC-8 date "+%y.%m.%d") @/g" package/lean/default-settings/files/zzz-default-settings
# 设置密码为空（安装固件时无需密码登陆，然后自己修改想要的密码）
sed -i 's@.*CYXluq4wUazHjmCDBCqXF*@#&@g' package/lean/default-settings/files/zzz-default-settings
# 使用官方golang版本
pushd feeds/packages/lang
rm -fr golang && svn co https://github.com/openwrt/packages/trunk/lang/golang
popd
# 使用Lienol https-dns-proxy版本
pushd feeds/packages/net
rm -fr https-dns-proxy && svn co https://github.com/Lienol/openwrt-packages/trunk/net/https-dns-proxy
popd
pushd feeds/luci/applications
rm -fr luci-app-https-dns-proxy && svn co https://github.com/Lienol/openwrt-luci/branches/17.01/applications/luci-app-https-dns-proxy
popd
# let pdnsd filter aaaa
mv $GITHUB_WORKSPACE/pdnsd-patch/* $GITHUB_WORKSPACE/openwrt/package/lean/pdnsd-alt/patches
#sed -i 's/min_ttl = 1h/min_ttl = 10m/g' feeds/passwall/luci-app-passwall/root/usr/share/passwall/app.sh
#sed -i 's/min_ttl = 1h/min_ttl = 10m/g' feeds/helloworld/luci-app-ssr-plus/root/etc/init.d/shadowsocksr
#======================================================================================
# 修改 argon 为默认主题,不再集成luci-theme-bootstrap
sed -i 's/luci-theme-bootstrap/luci-theme-argon/g' feeds/luci/collections/luci/Makefile
#sed -i "/commit luci/i\uci set luci.main.mediaurlbase='/luci-static/argon'" package/default-settings/files/zzz-default-settings
#======================================================================================
# Add kernel build user
#[ -z $(grep "CONFIG_KERNEL_BUILD_USER=" .config) ] &&
#    echo 'CONFIG_KERNEL_BUILD_USER="Ljzkirito"' >>.config ||
#    sed -i 's@\(CONFIG_KERNEL_BUILD_USER=\).*@\1$"Ljzkirito"@' .config
# Add kernel build domain
#[ -z $(grep "CONFIG_KERNEL_BUILD_DOMAIN=" .config) ] &&
#    echo 'CONFIG_KERNEL_BUILD_DOMAIN="GitHub Actions"' >>.config ||
#    sed -i 's@\(CONFIG_KERNEL_BUILD_DOMAIN=\).*@\1$"GitHub Actions"@' .config
#===================================================================================================================================
# 修改主机名字
#sed -i '/uci commit system/i\uci set system.@system[0].hostname='OpenWrt'' package/lean/default-settings/files/zzz-default-settings
# 清除默认主题
#sed -i '/set luci.main.mediaurlbase=\/luci-static\/bootstrap/d' feeds/luci/themes/luci-theme-bootstrap/root/etc/uci-defaults/30_luci-theme-bootstrap
# 更新smartdns
#rm -fr feeds/packages/net/smartdns
#mv $GITHUB_WORKSPACE/smartdns $GITHUB_WORKSPACE/openwrt/feeds/packages/net
#wget -O feeds/packages/net/smartdns/files/anti-ad-smartdns.conf https://raw.githubusercontent.com/privacy-protection-tools/anti-AD/master/anti-ad-smartdns.conf
# 使用Lienol luci-app-upnp版本
#pushd feeds/luci/applications
#rm -fr luci-app-upnp && svn co https://github.com/Lienol/openwrt-luci/branches/17.01/applications/luci-app-upnp
#popd
# 使用官方 miniupnp版本
#pushd feeds/packages/net
#rm -fr miniupnpd && svn co https://github.com/openwrt/packages/trunk/net/miniupnpd
#popd
#sed -i 's/ipv6_disable\ 0/ipv6_disable\ 1/' feeds/packages/net/miniupnpd/files/miniupnpd.init                       #默认关闭ipv6
#sed -i 's/ext_ip_reserved_ignore\ 0/ext_ip_reserved_ignore\ 1/' feeds/packages/net/miniupnpd/files/miniupnpd.init   #默认关闭保留地址检查
# adguardhome
#rm -fr feeds/packages/net/adguardhome
#mv $GITHUB_WORKSPACE/adguardhome $GITHUB_WORKSPACE/openwrt/package/lean
# Remove upx commands
#makefile_file="$({ find package|grep Makefile |sed "/Makefile./d"; } 2>"/dev/null")"
#for a in ${makefile_file}
#do
#	[ -n "$(grep "upx" "$a")" ] && sed -i "/upx/d" "$a"
#done
#pdnsd filter aaaa 
#wget https://github.com/coolsnowwolf/lede/commit/f93b3fef2e8ecebf8a8bafe68dedb2a9ae529761.patch
#git apply f93b3fef2e8ecebf8a8bafe68dedb2a9ae529761.patch
# Add po2lmo
mkdir -p feeds/helloworld/luci-app-ssr-plus/luasrc/i18n
po2lmo feeds/helloworld/luci-app-ssr-plus/po/zh-cn/*.po feeds/helloworld/luci-app-ssr-plus/luasrc/i18n/ssr-plus.zh-cn.lmo
rm -fr feeds/helloworld/luci-app-ssr-plus/po
