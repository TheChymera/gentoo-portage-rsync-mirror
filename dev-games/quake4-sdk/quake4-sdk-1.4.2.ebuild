# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-games/quake4-sdk/quake4-sdk-1.4.2.ebuild,v 1.4 2015/03/25 13:50:03 ago Exp $

inherit unpacker games

DESCRIPTION="Quake4 SDK"
HOMEPAGE="http://www.iddevnet.com/quake4/"
SRC_URI="mirror://idsoftware/quake4/source/linux/quake4-linux-${PV}-sdk.x86.run"

LICENSE="QUAKE4"
SLOT="0"
KEYWORDS="-* amd64 x86"
IUSE=""
RESTRICT="strip"

S=${WORKDIR}

src_unpack() {
	unpack_makeself
	rm -rf setup.{sh,data} || die
}

src_install() {
	insinto "${GAMES_PREFIX_OPT}/${PN}"
	doins -r * || die
	prepgamesdirs
}
