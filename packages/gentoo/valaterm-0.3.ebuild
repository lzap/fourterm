# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v3

EAPI="3"

inherit git

EGIT_REPO_URI="git://gitorious.org/valaterm/valaterm.git"
DESCRIPTION="ValaTerm is a lightweigth terminal written in Vala"
HOMEPAGE="https://gitorious.org/valaterm/"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~hppa ~ia64 ~ppc ~ppc64 ~sh ~sparc ~x86"

RDEPEND="dev-libs/glib:2
	x11-libs/gtk+:2
	x11-libs/vte:0"
DEPEND="${RDEPEND}
	>=dev-lang/vala-0.12
	sys-devel/gettext
	dev-util/intltool
	dev-util/pkgconfig"

src_configure() {
	./waf configure --prefix=/usr || die "Configure failed !"
}

src_compile() {
	./waf build || die "Build failed !"
}

src_install() {
	./waf install || die "Install failed !"
}