# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-emacs/wikipedia-mode/wikipedia-mode-0.5-r1.ebuild,v 1.5 2014/02/18 07:05:02 ulm Exp $

EAPI=5

inherit elisp eutils

DESCRIPTION="Mode for editing Wikipedia articles off-line"
HOMEPAGE="http://www.emacswiki.org/emacs/WikipediaMode"
SRC_URI="mirror://gentoo/${P}.el.bz2"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE="outline-magic"

DEPEND="outline-magic? ( app-emacs/outline-magic )"
RDEPEND="${DEPEND}"

SITEFILE="50${PN}-gentoo.el"

src_prepare() {
	use outline-magic && epatch "${FILESDIR}/${P}-require-outline-magic.patch"
}
