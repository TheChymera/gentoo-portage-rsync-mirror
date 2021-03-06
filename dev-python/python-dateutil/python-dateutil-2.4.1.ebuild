# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-python/python-dateutil/python-dateutil-2.4.1.ebuild,v 1.1 2015/03/25 14:33:07 idella4 Exp $

EAPI=5
PYTHON_COMPAT=( python{2_7,3_3,3_4} pypy )

inherit distutils-r1

DESCRIPTION="Extensions to the standard Python datetime module"
HOMEPAGE="https://dateutil.readthedocs.org/ https://pypi.python.org/pypi/python-dateutil https://github.com/dateutil/dateutil/"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~m68k ~mips ~ppc ~ppc64 ~s390 ~sh ~sparc ~x86 ~x86-fbsd ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos"
IUSE=""

RDEPEND=">=dev-python/six-1.5[${PYTHON_USEDEP}]
	sys-libs/timezone-data"
DEPEND="${RDEPEND}
	dev-python/setuptools[${PYTHON_USEDEP}]"
RESTRICT="test"

python_prepare_all() {
	# don't install zoneinfo tarball
	sed -i '/package_data=/d' setup.py || die

	distutils-r1_python_prepare_all
}

# Leave test phase for now. Upstream yet again missed out the testsuite in the tarball
python_test() {
	esetup.py test
}
