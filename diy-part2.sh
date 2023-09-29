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
chmod -R 777 files
# Modify default IP
sed -i 's/192.168.1.1/192.168.8.1/g' package/base-files/files/bin/config_generate
# 取消bootstrap为默认主题
sed -i '/set luci.main.mediaurlbase=\/luci-static\/bootstrap/d' feeds/luci/themes/luci-theme-bootstrap/root/etc/uci-defaults/30_luci-theme-bootstrap
#5.更换lede源码中自带argon主题
rm -rf feeds/luci/themes/luci-theme-argon && git clone -b 18.06 https://github.com/jerrykuku/luci-theme-argon.git feeds/luci/themes/luci-theme-argon

# 更新
#  ./scripts/feeds update -a && ./scripts/feeds install -a
sed -i 's/set wireless.default_radio${devidx}.ssid=OpenWrt/set wireless.default_radio0.ssid=RT-ACRH17/g' package/kernel/mac80211/files/lib/wifi/mac80211.sh
sed -i '/set wireless.default_radio0.ssid=RT-ACRH17/a\ set wireless.default_radio1.ssid=HS-ACRH17' package/kernel/mac80211/files/lib/wifi/mac80211.sh

#添加额外软件包

#sed -i 's/"Turbo ACC 网络加速"/"网络加速"/g' feeds/luci/applications/luci-app-turboacc/po/zh-cn/turboacc.po
#sed -i 's/"CPU 性能优化调节"/"超频"/g' feeds/luci/applications/luci-app-cpufreq/po/zh-cn/cpufreq.po

#svn co https://github.com/jerrykuku/luci-app-vssr/trunk package/luci-app-vssr
#svn co https://github.com/xiaorouji/openwrt-passwall-packages/trunk/chinadns-ng package/chinadns-ng
#svn co https://github.com/xiaorouji/openwrt-passwall-packages/trunk/tcping package/tcping
#svn co https://github.com/xiaorouji/openwrt-passwall/trunk/luci-app-passwall package/luci-app-passwall


#2. web登陆密码从password修改为空
sed -i 's/$1$V4UetPzk$CYXluq4wUazHjmCDBCqXF.//g' openwrt/package/lean/default-settings/files/zzz-default-settings

#3.固件版本号添加个人标识和日期
sed -i "s/DISTRIB_DESCRIPTION='OpenWrt '/DISTRIB_DESCRIPTION='FICHEN(\$\(TZ=UTC-8 date +%Y-%m-%d\))@OpenWrt '/g" package/lean/default-settings/files/zzz-default-settings

#4.编译的固件文件名添加日期
#sed -i 's/IMG_PREFIX:=$(VERSION_DIST_SANITIZED)/IMG_PREFIX:=$(shell TZ=UTC-8 date "+%Y%m%d-%H%M")-$(VERSION_DIST_SANITIZED)/g' include/image.mk


#7.修改主机名
sed -i "s/hostname='OpenWrt'/hostname='asus_rt-acrh17'/g" package/base-files/files/bin/config_generate



#取消编译libnetwork，防止出现冲突：
# * check_data_file_clashes: Package libnetwork wants to install file /workdir/openwrt/build_dir/target-aarch64_generic_musl/root-armvirt/usr/bin/docker-proxy
#         But that file is already provided by package  * dockerd 
# * opkg_install_cmd: Cannot install package libnetwork.
sed -i 's|CONFIG_PACKAGE_libnetwork=y|# CONFIG_PACKAGE_libnetwork is not set|g' .config



#luci-app-bypass
#svn export https://github.com/kiddin9/openwrt-packages/trunk/luci-app-bypass package/luci-app-bypass


