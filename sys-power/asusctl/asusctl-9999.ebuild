# Copyright 2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

# Auto-Generated by cargo-ebuild 0.5.2

EAPI=8

inherit cargo git-r3 linux-info xdg desktop systemd udev

_PN="asusd"

DESCRIPTION="Utilities to provide extended functionality to ASUS laptops."
# Double check the homepage as the cargo_metadata crate
# does not provide this value so instead repository is used
HOMEPAGE="
	https://asus-linux.org
	https://gitlab.com/asus-linux/asusctl
"
	#$(cargo_crate_uris)
EGIT_REPO_URI="https://gitlab.com/asus-linux/asusctl.git"
SRC_URI="https://gitlab.com/asus-linux/asusctl/-/archive/main/asusctl-main.tar.gz"

LICENSE="MPL-2.0"
SLOT="0/4"
KEYWORDS="-* ~amd64"
IUSE="+acpi anime gfx gnome gui notify systemd"
REQUIRED_USE="gnome? ( gfx )"

RESTRICT="mirror"

RDEPEND="!!sys-power/rog-core
	!!sys-power/asus-nb-ctrl
	acpi? ( sys-power/acpi_call )
	>=sys-power/power-profiles-daemon-0.10.0
"

DEPEND="${RDEPEND}
	>=virtual/rust-1.51.0
	>=sys-devel/llvm-10.0.1
	>=sys-devel/clang-runtime-10.0.1
	dev-libs/libusb:1
	gfx? (
		!sys-kernel/gentoo-g14-next
		>=sys-power/supergfxctl-2.0.0[gnome?]
	)
	gnome? ( gnome-extra/gnome-shell-extension-asusctl-gex:0/4 )
	systemd? ( sys-apps/systemd:0= )
	sys-apps/dbus
"

S="${WORKDIR}/${PN}-main/"

src_unpack() {
	unpack ${PN}-main.tar.gz
	cargo_live_src_unpack
}

src_configure() {
	cargo_src_configure --frozen
	default
}

src_compile() {
	cargo_gen_config
	default
}

src_install() {
	insinto /etc/${_PN}
	doins data/${_PN}-ledmodes.toml

	# icons (apps)
	insinto /usr/share/icons/hicolor/512x512/apps/
	doins data/icons/*.png

	# icons (status/notify)
	insinto /usr/share/icons/hicolor/scalable/status/
	doins data/icons/scalable/*.svg

	insinto /lib/udev/rules.d/
	doins "${FILESDIR}"/*.rules

	if [ -f data/_asusctl ] && [ -d /usr/share/zsh/site-functions ]; then
		insinto /usr/share/zsh/site-functions
		doins data/_asusctl
	fi

	insinto /usr/share/dbus-1/system.d/
	doins data/${_PN}.conf

	if use systemd ; then
		systemd_dounit data/${_PN}.service
		systemd_douserunit data/${_PN}-user.service
		#use notify && systemd_douserunit data/asus-notify.service
	else
		doinitd "${FILESDIR}"/openrc/${_PN}
		doinitd "${FILESDIR}"/openrc/${_PN}-user
		#use notify && doinitd "${FILESDIR}"/openrc/asus-notify
	fi

	if use acpi; then
		insinto /etc/modules-load.d
		doins "${FILESDIR}"/90-acpi_call.conf
	fi

	if use gui; then
		insinto /usr/share/rog-gui/layouts
		doins rog-aura/data/layouts/*.toml

		insinto /usr/share/icons/hicolor/512x512/apps/
		doins rog-control-center/data/rog-control-center.png

		domenu rog-control-center/data/rog-control-center.desktop
		dobin target/release/rog-control-center
	fi

	if use anime; then
		insinto /usr/share/${_PN}
		doins -r rog-anime/data/anime
	fi

	# binary
	dobin "target/release/"{asusd,asusd-user,asusctl}
}

pkg_postinst() {
	udev_reload
}

pkg_postrm() {
	udev_reload
}
