# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-i18n/ibus-cangjie/ibus-cangjie-2.3.ebuild,v 1.1 2015/03/06 20:24:54 dlan Exp $

EAPI=5
PYTHON_COMPAT=( python{3_2,3_3,3_4} )

inherit autotools-utils gnome2-utils python-r1 eutils

DESCRIPTION="The IBus engine for users of the Cangjie and Quick input methods"
HOMEPAGE="http://cangjians.github.io"
SRC_URI="https://github.com/Cangjians/ibus-cangjie/releases/download/v${PV}/ibus-cangjie-${PV}.tar.xz"

LICENSE="GPL-3+"
SLOT="0"
KEYWORDS="~amd64 ~x86"

DEPEND="${PYTHON_DEPS}
	>=app-i18n/ibus-1.4.1
	app-i18n/libcangjie
	dev-python/cangjie[${PYTHON_USEDEP}]
	dev-util/intltool
	sys-devel/gettext"

RDEPEND=">=app-i18n/ibus-1.4.1
	app-i18n/libcangjie
	dev-python/cangjie[${PYTHON_USEDEP}]
	virtual/libintl
	${PYTHON_DEPS}"

src_configure() {
	python_foreach_impl autotools-utils_src_configure
}

src_compile() {
	python_foreach_impl autotools-utils_src_compile
}

src_install() {
	python_foreach_impl autotools-utils_src_install
}

pkg_preinst() {
	gnome2_icon_savelist
}

pkg_postinst() {
	gnome2_icon_cache_update
}
