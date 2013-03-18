# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5

AUTOTOOLS_AUTORECONF=1
AUTOTOOLS_IN_SOURCE_BUILD=1

EGIT_REPO_URI="git://git.kernel.org/pub/scm/network/ofono/${PN}.git"
inherit eutils multilib autotools-utils git-2

DESCRIPTION="Phone simulator for ofono"
HOMEPAGE="http://ofono.org/"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS=""
IUSE="doc"

RDEPEND="net-misc/ofono
	dev-qt/qtcore
	dev-qt/qtdbus
	dev-qt/qtgui
	dev-qt/qtscript"

DEPEND="${RDEPEND}
	virtual/pkgconfig"

DOCS=( ChangeLog AUTHORS )

src_prepare() {
	autotools-utils_src_prepare
}

src_configure() {
	econf \
		--disable-maintainer-mode \
		--disable-dependency-tracking \
		--enable-optimization
}

src_install() {
	default

	use doc && dodoc doc/*.txt
}
