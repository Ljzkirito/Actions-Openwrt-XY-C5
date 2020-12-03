#
# Copyright (C) 2015-2016 OpenWrt.org
# This is free software, licensed under the GNU General Public License v2.
# See /LICENSE.txt for more information.
#

include $(TOPDIR)/rules.mk

PKG_NAME:=AdGuardHome
PKG_VERSION:=0.104.3
PKG_RELEASE:=1

PKG_SOURCE_PROTO:=git
PKG_SOURCE_VERSION:=v$(PKG_VERSION)
PKG_SOURCE_URL:=https://github.com/AdguardTeam/AdGuardHome
PKG_MIRROR_HASH:=ec0d48413778267f4ac81091e58a88e5b5ee2f3c1ab48256ded3438bf171d311

PKG_LICENSE:=GPL-3.0-only
PKG_LICENSE_FILES:=LICENSE.txt
PKG_MAINTAINER:=Dobroslaw Kijowski <dobo90@gmail.com>

PKG_BUILD_DEPENDS:=golang/host node/host packr/host
PKG_BUILD_PARALLEL:=1
PKG_USE_MIPS16:=0

GO_PKG:=github.com/AdguardTeam/AdGuardHome
GO_PKG_EXCLUDES:=dhcpd/standalone
GO_PKG_LDFLAGS:=-s -w
GO_PKG_LDFLAGS_X:=main.version=$(PKG_VERSION) main.channel=release main.goarm=$(GO_ARM)

include $(INCLUDE_DIR)/package.mk
include $(TOPDIR)/feeds/packages/lang/golang/golang-package.mk

define Package/AdGuardHome
  SECTION:=net
  CATEGORY:=Network
  TITLE:=Network-wide ads and trackers blocking DNS server
  URL:=https://github.com/AdguardTeam/AdGuardHome
  DEPENDS:=$(GO_ARCH_DEPENDS) +ca-bundle
endef

define Package/AdGuardHome/description
Free and open source, powerful network-wide ads and trackers blocking DNS server.
endef

define Build/Compile
	( \
		pushd $(PKG_BUILD_DIR) ; \
		npm --prefix client ci ; \
		npm --prefix client run build-prod ; \
		packr -z -v -i internal ; \
		popd ; \
		$(call GoPackage/Build/Compile) ; \
	)
endef

define Package/AdGuardHome/install
	$(call GoPackage/Package/Install/Bin,$(PKG_INSTALL_DIR))
	$(INSTALL_DIR) $(1)/usr/bin/AdGuardHome
	$(INSTALL_BIN) $(GO_PKG_BUILD_BIN_DIR)/AdGuardHome $(1)/usr/bin/AdGuardHome/AdGuardHome
endef

$(eval $(call GoBinPackage,AdGuardHome))
$(eval $(call BuildPackage,AdGuardHome))
