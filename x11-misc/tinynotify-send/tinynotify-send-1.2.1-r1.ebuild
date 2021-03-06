# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/x11-misc/tinynotify-send/tinynotify-send-1.2.1-r1.ebuild,v 1.2 2014/07/06 13:24:12 mgorny Exp $

EAPI=4

inherit autotools-utils

DESCRIPTION="A notification sending utility (using libtinynotify)"
HOMEPAGE="https://bitbucket.org/mgorny/tinynotify-send/"
SRC_URI="https://www.bitbucket.org/mgorny/${PN}/downloads/${P}.tar.bz2"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND="app-admin/eselect-notify-send
	x11-libs/libtinynotify
	~x11-libs/libtinynotify-cli-${PV}"
DEPEND="${RDEPEND}
	virtual/pkgconfig"

src_configure() {
	myeconfargs=(
		--disable-library
		--enable-regular
		--disable-system-wide
		--with-system-wide-exec=/usr/bin/sw-notify-send
	)

	autotools-utils_src_configure
}

pkg_postinst() {
	eselect notify-send update ifunset
}

pkg_postrm() {
	eselect notify-send update ifunset
}
