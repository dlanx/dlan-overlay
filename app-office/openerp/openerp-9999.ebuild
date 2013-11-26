# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="3"
PYTHON_DEPEND="2"
inherit eutils distutils user bzr

DESCRIPTION="Open Source ERP & CRM"
HOMEPAGE="http://www.openerp.com/"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS=""
IUSE="+postgres ldap ssl"

CDEPEND="!app-office/openerp-web
	postgres? ( dev-db/postgresql-server )
	dev-python/psutil
	dev-python/docutils
	dev-python/lxml
	dev-python/psycopg:2
	dev-python/pychart
	dev-python/pyparsing
	dev-python/reportlab
	dev-python/simplejson
	media-gfx/pydot
	dev-python/vobject
	dev-python/mako
	dev-python/mock
	dev-python/pyyaml
	dev-python/Babel
	dev-python/gdata
	ldap? ( dev-python/python-ldap )
	dev-python/python-openid
	dev-python/werkzeug
	dev-python/xlwt
	dev-python/feedparser
	dev-python/python-dateutil
	dev-python/pywebdav
	ssl? ( dev-python/pyopenssl )
	dev-python/vatnumber
	dev-python/zsi
	dev-python/mock
	dev-python/unittest2
	dev-python/jinja
	dev-python/matplotlib"

RDEPEND="${CDEPEND}"
DEPEND="${CDEPEND}"

OPENERP_USER="openerp"
OPENERP_GROUP="openerp"

S="${WORKDIR}/${FNAME}"

pkg_setup() {
	python_set_active_version 2
	python_pkg_setup
}

src_unpack() {
	mkdir -p ${WORKDIR}/${P} || die

	EBZR_REPO_URI="lp:~openerp/openerp-web/trunk" \
	EBZR_SUBPROJ=web \
	EBZR_UNPACK_DIR=${WORKDIR}/${P}/web bzr_src_unpack

	EBZR_REPO_URI="lp:~openerp/openobject-addons/trunk" \
	EBZR_SUBPROJ=addons \
	EBZR_UNPACK_DIR=${WORKDIR}/${P}/addons bzr_src_unpack

	EBZR_REPO_URI="lp:~openerp/openobject-server/trunk" \
	EBZR_SUBPROJ=server \
	EBZR_UNPACK_DIR=${WORKDIR}/${P}/server bzr_src_unpack

	EBZR_REPO_URI="lp:~openerp/openobject-client-web/trunk" \
	EBZR_SUBPROJ=client \
	EBZR_UNPACK_DIR=${WORKDIR}/${P}/client bzr_src_unpack
}

src_install() {
	distutils_src_install

	newinitd "${FILESDIR}/${PN}-2" "${PN}"
	newconfd "${FILESDIR}/openerp-confd-2" "${PN}"
	keepdir /var/log/openerp

	insinto /etc/logrotate.d
	newins "${FILESDIR}"/openerp.logrotate openerp || die
	dodir /etc/openerp
	insinto /etc/openerp
	newins "${FILESDIR}"/openerp.cfg.2 openerp.cfg || die

	# #453424 Fix error on /usr/openerp/import_xml.rng
	dosym /usr/${PN}/import_xml.rng $(python_get_sitedir)/${PN}/import_xml.rng || die

	# #453424 Fix error on /usr/openerp/addons/base/res/res_company_logo.png
	dosym /usr/${NAME}/addons/base/res/res_company_logo.png $(python_get_sitedir)/${NAME}/addons/base/res/res_company_logo.png || die

}

pkg_preinst() {
	enewgroup ${OPENERP_GROUP}
	enewuser ${OPENERP_USER} -1 -1 -1 ${OPENERP_GROUP}

	fowners ${OPENERP_USER}:${OPENERP_GROUP} /var/log/openerp
	fowners -R ${OPENERP_USER}:${OPENERP_GROUP} "$(python_get_sitedir)/${PN}/addons/"

	use postgres || sed -i '6,8d' "${D}/etc/init.d/openerp" || die "sed failed"
}

pkg_postinst() {
	chown ${OPENERP_USER}:${OPENERP_GROUP} /var/log/openerp
	chown -R ${OPENERP_USER}:${OPENERP_GROUP} "$(python_get_sitedir)/${PN}/addons/"

	elog "In order to setup the initial database, run:"
	elog " emerge --config =${CATEGORY}/${PF}"
	elog "Be sure the database is started before"
}

psqlquery() {
	psql -q -At -U postgres -d template1 -c "$@"
}

pkg_config() {
	einfo "In the following, the 'postgres' user will be used."
	if ! psqlquery "SELECT usename FROM pg_user WHERE usename = '${OPENERP_USER}'" | grep -q ${OPENERP_USER}; then
		ebegin "Creating database user ${OPENERP_USER}"
		createuser --username=postgres --createdb --no-adduser ${OPENERP_USER}
		eend $? || die "Failed to create database user"
	fi
}
