# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-libs/rest/rest-0.7.92-r2.ebuild,v 1.4 2015/03/15 13:31:07 pacho Exp $

EAPI="5"
GCONF_DEBUG="no"
GNOME2_LA_PUNT="yes"

inherit eutils gnome2 multilib-minimal virtualx

DESCRIPTION="Helper library for RESTful services"
HOMEPAGE="https://wiki.gnome.org/Projects/Librest"

LICENSE="LGPL-2.1"
SLOT="0.7"
IUSE="+gnome +introspection test"
KEYWORDS="~alpha amd64 ~arm ~hppa ~ia64 ~ppc ~ppc64 ~sparc x86"

# Coverage testing should not be enabled
RDEPEND="
	app-misc/ca-certificates
	>=dev-libs/glib-2.24:2[${MULTILIB_USEDEP}]
	dev-libs/libxml2:2[${MULTILIB_USEDEP}]
	net-libs/libsoup:2.4[${MULTILIB_USEDEP}]
	gnome? ( >=net-libs/libsoup-gnome-2.25.1:2.4[${MULTILIB_USEDEP}] )
	introspection? ( >=dev-libs/gobject-introspection-0.6.7 )
"
DEPEND="${RDEPEND}
	>=dev-util/gtk-doc-am-1.13
	>=dev-util/intltool-0.40
	virtual/pkgconfig[${MULTILIB_USEDEP}]
	test? ( sys-apps/dbus[${MULTILIB_USEDEP}] )
"

src_prepare() {
	# fixed in 0.7.93
	epatch "${FILESDIR}/${P}-oauth-missing-include.patch" #542264
	epatch "${FILESDIR}/${P}-xml-parser-missing-break.patch"
	# https://bugzilla.gnome.org/show_bug.cgi?id=745694
	epatch "${FILESDIR}/${P}-tests-GError-pointers.patch"

	gnome2_src_prepare
}

multilib_src_configure() {
	ECONF_SOURCE=${S} \
	gnome2_src_configure \
		--disable-static \
		--disable-gcov \
		--with-ca-certificates="${EPREFIX}"/etc/ssl/certs/ca-certificates.crt \
		$(use_with gnome) \
		$(multilib_native_use_enable introspection)

	if multilib_is_native_abi; then
		ln -s "${S}"/docs/reference/rest/html docs/reference/rest/html || die
	fi
}

multilib_src_test() {
	# Tests need dbus
	Xemake check
}

multilib_src_compile() { gnome2_src_compile; }
multilib_src_install() { gnome2_src_install; }
