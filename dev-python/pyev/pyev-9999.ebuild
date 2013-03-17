# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5

PYTHON_COMPAT=( python{2_6,2_7,3_1,3_2} )

ESVN_REPO_URI="http://pyev.googlecode.com/svn/trunk/${PN}"
inherit subversion distutils-r1

DESCRIPTION="Python libev interface, an event loop"
HOMEPAGE="http://code.google.com/p/pyev/
	http://pythonhosted.org/pyev/"

LICENSE="|| ( BSD GPL-2 )"
SLOT="0"
KEYWORDS=""
IUSE=""

RDEPEND="dev-libs/libev
	dev-python/setuptools[${PYTHON_USEDEP}]
	${PYTHON_DEPS}"

DEPEND="${RDEPEND}"

HTML_DOCS=( doc/. )

python_prepare() {
	distutils-r1_python_prepare
}
