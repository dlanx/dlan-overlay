# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-misc/connman/connman-1.9.ebuild,v 1.1 2012/11/15 23:59:46 chainsaw Exp $

EAPI=5

inherit autotools-utils linux-mod

DESCRIPTION="Provides a daemon for managing internet connections"
HOMEPAGE="http://connman.net"
SRC_URI="mirror://kernel/linux/network/${PN}/${P}.tar.xz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~arm ~ppc ~ppc64 ~x86"
IUSE="bluetooth debug doc dundee examples +ethernet neard ofono openvpn pacrunner policykit selinux threads tools vpnc +wifi +wispr -nmcompat"

RDEPEND=">=dev-libs/glib-2.16
	>=sys-apps/dbus-1.2.24
	>=dev-libs/libnl-1.1
	>=net-firewall/iptables-1.4.8
	net-libs/gnutls
	bluetooth? ( net-wireless/bluez )
	ofono? ( net-misc/ofono )
	policykit? ( sys-auth/polkit )
	openvpn? ( net-misc/openvpn )
	vpnc? ( net-misc/vpnc )
	wifi? ( >=net-wireless/wpa_supplicant-0.7[dbus] )"

DEPEND="${RDEPEND}
	>=sys-kernel/linux-headers-2.6.39
	doc? ( dev-util/gtk-doc )"

REQUIRED_USE="
	dundee?		( bluetooth					)
"

CONFIG_CHECK="~BRIDGE ~IP_NF_TARGET_MASQUERADE ~NETFILTER ~NF_CONNTRACK_IPV4 ~NF_NAT_IPV4 "

src_configure() {
	econf \
		--localstatedir=/var \
		--enable-client \
		--enable-datafiles \
		--enable-loopback \
		$(use_enable bluetooth ) \
		$(use_enable nmcompat) \
		$(use_enable debug) \
		$(use_enable doc gtk-doc) \
		$(use_enable dundee ) \
		$(use_enable examples test) \
		$(use_enable ethernet ) \
		$(use_enable wifi ) \
		$(use_enable wispr ) \
		$(use_enable neard ) \
		$(use_enable ofono ) \
		$(use_enable policykit polkit) \
		$(use_enable pacrunner ) \
		$(use_enable selinux ) \
		$(use_enable threads) \
		$(use_enable tools) \
		$(use_enable openvpn openvpn builtin) \
		$(use_enable vpnc vpnc builtin) \
		--disable-iospm \
		--disable-hh2serial-gps \
		--disable-openconnect
}

src_install() {
	emake DESTDIR="${D}" install || die "emake install failed"
	dobin client/connmanctl

	keepdir /var/lib/${PN} || die
	newinitd "${FILESDIR}"/${PN}.initd ${PN} || die
	newconfd "${FILESDIR}"/${PN}.confd ${PN} || die
}
