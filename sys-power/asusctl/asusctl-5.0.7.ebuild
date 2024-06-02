# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="A control daemon and CLI tools for interacting with ASUS ROG laptops."
HOMEPAGE="https://asus-linux.org/"

SRC_URI="
	https://gitlab.com/asus-linux/asusctl/-/archive/${PV}/${P}.tar.bz2
"
#https://gitlab.com/asus-linux/asusctl/uploads/a9d6f34620f707a7d785daa4c619c147/vendor_${PN}_${PV}.tar.xz

# Awful quick fix
RESTRICT="network-sandbox"

#S="${WORKDIR}/${P}"


LICENSE="MPL-2.0"

SLOT="0"
KEYWORDS="~amd64"

IUSE=""

RDEPEND="
	sys-power/acpi_call
	dev-libs/libappindicator:3
	>=sys-power/power-profiles-daemon-0.10.0
"

DEPEND="${RDEPEND}
	>=virtual/rust-1.51.0
	>=sys-devel/llvm-10.0.1
	>=sys-devel/clang-runtime-10.0.1
	dev-libs/libusb:1
	sys-apps/dbus
	media-libs/sdl2-gfx
"

BDEPEND="
	virtual/pkgconfig
	>=dev-build/cmake-3.24.3
"

src_unpack() {
	default
}

src_configure() {
	default
}

src_compile() {
	default
}

src_install() {
	default

	newinitd "${FILESDIR}"/asusd.init asusd
}
