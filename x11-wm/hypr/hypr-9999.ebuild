# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake git-r3

DESCRIPTION="Hypr is a tiling window manager written in modern C++."
HOMEPAGE="https://github.com/hyprwm/Hypr"
EGIT_REPO_URI="https://github.com/hyprwm/Hypr.git"

# Source directory; the dir where the sources can be found (automatically
# unpacked) inside ${WORKDIR}.  The default value for S is ${WORKDIR}/${P}
# If you don't need to change it, leave the S= line out of the ebuild
# to keep it tidy.
#S="${WORKDIR}/${P}"


LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64"

# A space delimited list of portage features to restrict. man 5 ebuild
# for details.  Usually not needed.
#RESTRICT="strip"


# Run-time dependencies. Must be defined to whatever this depends on to run.
# Example:
#    ssl? ( >=dev-libs/openssl-1.0.2q:0= )
#    >=dev-lang/perl-5.24.3-r1
# It is advisable to use the >= syntax show above, to reflect what you
# had installed on your system when you tested the package.  Then
# other users hopefully won't be caught without the right version of
# a dependency.
#RDEPEND=""

# Build-time dependencies that need to be binary compatible with the system
# being built (CHOST). These include libraries that we link against.
# The below is valid if the same run-time depends are required to compile.
#DEPEND="${RDEPEND}"

BDEPEND="
>=dev-util/cmake-3.4.0
"


src_configure() {
	cmake_src_configure
}

src_compile() {
   cmake_src_compile
}

src_install() {
	insinto /usr/share/xsessions/
	doins example/hypr.desktop

	insinto /usr/share/${PN}
	doins example/hypr.conf

	dobin "${BUILD_DIR}/Hypr"
}
