# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5

inherit eutils

if [[ ${PV} = *9999* ]]; then
	EGIT_REPO_URI="git://github.com/openSUSE/snapper.git"
	inherit autotools git-2
	SRC_URI=""
	KEYWORDS=""
else
	SRC_URI="ftp://ftp.suse.com/pub/projects/snapper/${P}.tar.bz2"
	DOCS="AUTHORS README package/snapper.changes"
	KEYWORDS="~amd64 ~x86"
fi

DESCRIPTION="Command-line program for btrfs and ext4 snapshot management"
HOMEPAGE="http://snapper.io/"

LICENSE="GPL-2"
SLOT="0"
IUSE="btrfs ext4 lvm pam xattr"

RDEPEND="dev-libs/boost[threads]
	dev-libs/libxml2
	dev-libs/icu
	sys-apps/acl
	sys-apps/dbus
	sys-libs/zlib
	virtual/libintl
	btrfs? ( sys-fs/btrfs-progs )
	ext4? ( sys-fs/e2fsprogs )
	pam? ( sys-libs/pam )
	xattr? ( sys-apps/attr )"

DEPEND="${RDEPEND}
	sys-devel/gettext
	virtual/pkgconfig"

DOCS="AUTHORS README"

src_prepare() {
	# Replace sysconfig with conf.d
	epatch "${FILESDIR}"/cron-confd.patch
}

src_configure() {
	# No YaST in Gentoo

	econf  \
	--with-conf="/etc/conf.d" \
	$(use_enable btrfs) \
	$(use_enable ext4) \
	$(use_enable lvm) \
	$(use_enable pam) \
	$(use_enable xattr xattrs) \
	--disable-zypp
}

src_install() {
	default
	# Existing configuration file required to function
	newconfd data/sysconfig.snapper snapper
}

pkg_postinst() {
	elog "In order to use Snapper, you need to set up at least one config"
	elog "manually, or else the tool will get confused. Typically you should"
	elog "create a '/.snapshots' directory, then copy the file"
	elog "'/etc/snapper/config-templates/default' into '/etc/snapper/configs/',"
	elog "rename the file to 'root', and add its name into '/etc/conf.d/snapper'."
	elog "That will instruct Snapper to snapshot the root of the filesystem by"
	elog "default. For more information, see the snapper(8) manual page."
}
