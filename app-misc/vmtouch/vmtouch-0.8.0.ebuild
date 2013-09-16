# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5

inherit toolchain-funcs

DESCRIPTION="Portable file system cache diagnostics and control"
HOMEPAGE="http://hoytech.com/vmtouch/"
SRC_URI="https://raw.github.com/hoytech/vmtouch/master/vmtouch.c -> ${P}.c"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~x64"
IUSE=""

DEPEND=""
RDEPEND="${DEPEND}"

S="${WORKDIR}"
src_unpack() {
	cp "${DISTDIR}"/${A} "${WORKDIR}"/ || die
}

src_compile() {
	einfo "$(tc-getCC) ${LDFLAGS} ${CFLAGS} -o ${PN} ${P}.c"
	$(tc-getCC) ${LDFLAGS} ${CFLAGS} -o ${PN} ${P}.c || die
}

src_install() {
	dobin vmtouch || die
}
