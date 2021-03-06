# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/x11-plugins/gkrellsun/gkrellsun-1.0.0-r1.ebuild,v 1.5 2014/08/10 20:01:49 slyfox Exp $

inherit gkrellm-plugin

IUSE="nls"
DESCRIPTION="A GKrellM plugin that shows sunrise and sunset times"
HOMEPAGE="http://gkrellsun.sourceforge.net/"
SRC_URI="mirror://sourceforge/gkrellsun/${P}.tar.gz"

SLOT="1"
LICENSE="GPL-2"
KEYWORDS="alpha amd64 hppa ia64 ppc sparc x86"

DEPEND="nls? ( sys-devel/gettext )"

PLUGIN_SO=src20/gkrellsun.so

src_compile() {
	use nls && myconf="$myconf enable_nls=1"
	emake ${myconf}
}
