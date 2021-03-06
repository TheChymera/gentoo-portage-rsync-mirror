# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-java/jlex/jlex-1.2.6-r2.ebuild,v 1.1 2015/02/24 12:36:37 fordfrog Exp $

EAPI=5

JAVA_PKG_IUSE="doc source"

inherit java-pkg-2

DESCRIPTION="JLex: a lexical analyzer generator for Java"
SRC_URI="mirror://gentoo/${P}.tar.bz2"
HOMEPAGE="http://www.cs.princeton.edu/~appel/modern/java/JLex/"
KEYWORDS="~amd64 ~ppc ~x86"
LICENSE="jlex"
SLOT="0"
DEPEND=">=virtual/jdk-1.4"
RDEPEND=">=virtual/jre-1.4"
IUSE=""

src_compile() {
	ejavac -nowarn Main.java
}

src_install() {
	dodoc README Bugs

	if use doc ; then
		dohtml manual.html
		dodoc sample.lex
	fi

	mkdir JLex && mv *.class JLex/
	jar cf jlex.jar JLex/ || die "failed to jar"
	java-pkg_dojar jlex.jar
	java-pkg_dolauncher jlex --main JLex.Main jlex.jar

	if use source ; then
		rm JLex/*
		cp Main.java JLex
		java-pkg_dosrc JLex
	fi
}
