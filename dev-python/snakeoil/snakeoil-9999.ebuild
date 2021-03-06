# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-python/snakeoil/snakeoil-9999.ebuild,v 1.18 2015/03/24 05:19:18 radhermit Exp $

EAPI=5
PYTHON_COMPAT=( python{2_7,3_3,3_4} )
inherit distutils-r1

if [[ ${PV} == *9999 ]] ; then
	EGIT_REPO_URI="https://github.com/pkgcore/snakeoil.git"
	inherit git-r3
else
	KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~m68k ~mips ~ppc ~ppc64 ~s390 ~sh ~sparc ~x86"
	SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.bz2"
fi

DESCRIPTION="Miscellaneous python utility code"
HOMEPAGE="http://github.com/pkgcore/snakeoil"

LICENSE="BSD"
SLOT="0"

python_configure_all() {
	# disable snakeoil 2to3 caching
	unset PY2TO3_CACHEDIR
}

python_test() {
	esetup.py test
}
