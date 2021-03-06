# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-db/mongodb/mongodb-3.0.1.ebuild,v 1.2 2015/03/26 15:56:30 ultrabug Exp $

EAPI=5
SCONS_MIN_VERSION="2.3.0"
CHECKREQS_DISK_BUILD="2400M"
CHECKREQS_DISK_USR="512M"
CHECKREQS_MEMORY="1024M"

inherit eutils flag-o-matic multilib pax-utils scons-utils systemd user versionator check-reqs

MY_P=${PN}-src-r${PV/_rc/-rc}

DESCRIPTION="A high-performance, open source, schema-free document-oriented database"
HOMEPAGE="http://www.mongodb.org"
SRC_URI="http://downloads.mongodb.org/src/${MY_P}.tar.gz"

LICENSE="AGPL-3 Apache-2.0"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="debug kerberos mms-agent ssl +tools"

RDEPEND="app-arch/snappy
	>=dev-cpp/yaml-cpp-0.5.1
	>=dev-libs/boost-1.50[threads(+)]
	>=dev-libs/libpcre-8.30[cxx]
	dev-libs/snowball-stemmer
	dev-util/google-perftools[-minimal]
	net-libs/libpcap
	mms-agent? ( app-admin/mms-agent )
	ssl? ( >=dev-libs/openssl-1.0.1g:= )"
DEPEND="${RDEPEND}
	>=sys-devel/gcc-4.8.2:*
	sys-libs/ncurses
	sys-libs/readline
	kerberos? ( dev-libs/cyrus-sasl[kerberos] )"
PDEPEND="tools? ( >=app-admin/mongo-tools-${PV} )"

S=${WORKDIR}/${MY_P}

pkg_setup() {
	enewgroup mongodb
	enewuser mongodb -1 -1 /var/lib/${PN} mongodb

	scons_opts="--variant-dir=build --cc=$(tc-getCC) --cxx=$(tc-getCXX)"
	scons_opts+=" --disable-warnings-as-errors"
	scons_opts+=" --use-system-boost"
	scons_opts+=" --use-system-pcre"
	scons_opts+=" --use-system-snappy"
	scons_opts+=" --use-system-stemmer"
	scons_opts+=" --use-system-tcmalloc"
	scons_opts+=" --use-system-yaml"

	if use debug; then
		scons_opts+=" --dbg=on"
	fi

	if use prefix; then
		scons_opts+=" --cpppath=${EPREFIX}/usr/include"
		scons_opts+=" --libpath=${EPREFIX}/usr/$(get_libdir)"
	fi

	if use kerberos; then
		scons_opts+=" --use-sasl-client"
	fi

	if use ssl; then
		scons_opts+=" --ssl"
	fi
}

src_prepare() {
	epatch "${FILESDIR}/${PN}-3.0.0-fix-scons.patch"
}

src_compile() {
	# respect mongoDB upstream's basic recommendations
	# see bug #536688 and #526114
	if ! use debug; then
		filter-flags '-m*'
		filter-flags '-O?'
	fi
	escons ${scons_opts} core tools
}

src_install() {
	escons ${scons_opts} --nostrip install --prefix="${ED}"/usr

	for x in /var/{lib,log}/${PN}; do
		keepdir "${x}"
		fowners mongodb:mongodb "${x}"
	done

	doman debian/mongo*.1
	dodoc README docs/building.md

	newinitd "${FILESDIR}/${PN}.initd-r2" ${PN}
	newconfd "${FILESDIR}/${PN}.confd-r2" ${PN}
	newinitd "${FILESDIR}/${PN/db/s}.initd-r2" ${PN/db/s}
	newconfd "${FILESDIR}/${PN/db/s}.confd-r2" ${PN/db/s}

	insinto /etc
	newins "${FILESDIR}/${PN}.conf-r3" ${PN}.conf
	newins "${FILESDIR}/${PN/db/s}.conf-r2" ${PN/db/s}.conf

	systemd_dounit "${FILESDIR}/${PN}.service"

	insinto /etc/logrotate.d/
	newins "${FILESDIR}/${PN}.logrotate" ${PN}

	# see bug #526114
	pax-mark emr "${ED}"/usr/bin/{mongo,mongod,mongos}
}

pkg_preinst() {
	# wrt bug #461466
	if [[ "$(get_libdir)" == "lib64" ]]; then
		rmdir "${ED}"/usr/lib/ &>/dev/null
	fi
}

src_test() {
	escons ${scons_opts} dbtest
	"${S}"/dbtest --dbpath=unittest || die "dbtest failed"
	escons ${scons_opts} smokeCppUnittests --smokedbprefix="smokecpptest" || die "smokeCppUnittests tests failed"
}

pkg_postinst() {
	if [[ ${REPLACING_VERSIONS} < 3.0 ]]; then
		ewarn "!! IMPORTANT !!"
		ewarn " "
		ewarn "${PN} configuration files have changed !"
		ewarn " "
		ewarn "Make sure you migrate from /etc/conf.d/${PN} to the new YAML standard in /etc/${PN}.conf"
		ewarn "  http://docs.mongodb.org/manual/reference/configuration-options/"
		ewarn " "
		ewarn "Make sure you also follow the upgrading process :"
		ewarn "  http://docs.mongodb.org/master/release-notes/3.0-upgrade/"
		ewarn " "
		ewarn "MongoDB 3.0 introduces the WiredTiger storage engine."
		ewarn "WiredTiger is incompatible with MMAPv1 and you need to dump/reload your data if you want to use it."
		ewarn "Once you have your data dumped, you need to set storage.engine: wiredTiger in /etc/${PN}.conf"
		ewarn "  http://docs.mongodb.org/master/release-notes/3.0-upgrade/#change-storage-engine-to-wiredtiger"
	fi
}
