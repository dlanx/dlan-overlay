# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5

CMAKE_IN_SOURCE_BUILD=1
inherit bzr eutils cmake-utils
DESCRIPTION="Mir is a display manager"
HOMEPAGE="http://bazaar.launchpad.net/~mir-team/mir"
EBZR_REPO_URI="lp:~mir-team/mir/trunk"

LICENSE="GPL"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND="media-libs/mesa[egl,gles2]
	dev-libs/protobuf
	dev-cpp/glog
	dev-cpp/gflags
	dev-cpp/gmock
	dev-util/astyle
	dev-util/lttng-ust
	dev-util/umockdev
	x11-libs/libxkbcommon
	"
RDEPEND="${DEPEND}
	"
src_configure() {
	local mycmakeargs=(
		-DMIR_PLATFORM=gbm
		-DMIR_ENABLE_TESTS=OFF
	)
	cmake-utils_src_configure
}
