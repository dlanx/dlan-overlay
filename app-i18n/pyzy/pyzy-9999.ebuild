# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5

inherit eutils python git-2 autotools

DESCRIPTION="The Chinese PinYin and Bopomofo conversion library"
HOMEPAGE="https://github.com/pyzy"
EGIT_REPO_URI="git://github.com/pyzy/pyzy.git"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS=""
IUSE="boost doc opencc test"

RDEPEND="dev-libs/glib:2
	dev-db/sqlite:3
	sys-apps/util-linux
	boost? ( dev-libs/boost )
	opencc? ( app-i18n/opencc )"

DEPEND="${RDEPEND}
	doc? ( app-doc/doxygen )"

# Currently it fails to build test code
RESTRICT="test"


src_prepare() {
	python_convert_shebangs 2 "${S}"/data/db/android/create_db.py
	eautoreconf
}

src_configure() {
	econf \
		--enable-db-open-phrase \
		--enable-db-android \
		$(use_enable boost) \
		$(use_enable opencc) \
		$(use_enable test tests)
}

src_install() {
	default
	use doc && dohtml -r docs/html/*
}
