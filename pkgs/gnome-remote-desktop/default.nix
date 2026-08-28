{
  stdenv,
  lib,
  fetchurl,
  meson,
  ninja,
  pkg-config,
  python3,
  wrapGAppsHook3,
  glib,
  pipewire,
  libsecret,
  libnotify,
  # TODO: cairo - not available
  # TODO: freerdp - not available
  # TODO: fdk_aac - not available
  # TODO: tpm2-tss - not available
  # TODO: fuse3 - not available
  # TODO: libei - not available
  # TODO: libepoxy - not available
  # TODO: libdrm - not available
  # TODO: libkrb5 - not available
  # TODO: libva - not available
  # TODO: vulkan-loader - not available
  # TODO: nv-codec-headers-11 - not available
  # TODO: libopus - not available
  # TODO: libxkbcommon - not available
  # TODO: gdk-pixbuf - not available
  # TODO: systemd - not available
  # TODO: polkit - not available
  # TODO: asciidoc - not available
  # TODO: shaderc - not available
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "gnome-remote-desktop";
  version = "50.2";

  src = fetchurl {
    url = "mirror://gnome/sources/gnome-remote-desktop/${lib.versions.major finalAttrs.version}/gnome-remote-desktop-${finalAttrs.version}.tar.xz";
    hash = "sha256-Md9ij0ETVz8Tb/yNwAF2Ou1jPNhb7SHli8YfihffCR8=";
  };

  nativeBuildInputs = [
    meson
    meson.configurePhaseHook
    ninja
    pkg-config
    python3
    # TODO: asciidoc
    # TODO: shaderc (for glslc)
    wrapGAppsHook3
  ];

  buildInputs = [
    # TODO: cairo
    # TODO: freerdp
    # TODO: fdk_aac
    # TODO: tpm2-tss
    # TODO: fuse3
    # TODO: gdk-pixbuf (for libnotify)
    glib
    # TODO: libei
    # TODO: libepoxy
    # TODO: libdrm
    # TODO: libkrb5
    # TODO: libva
    # TODO: vulkan-loader
    # TODO: nv-codec-headers-11
    libnotify
    # TODO: libopus
    libsecret
    # TODO: libxkbcommon
    pipewire
    # TODO: systemd
    # TODO: polkit
  ];

  mesonFlags = [
    "-Dconf_dir=/etc/gnome-remote-desktop"
    "-Dsystemd_user_unit_dir=${placeholder "out"}/lib/systemd/user"
    "-Dsystemd_system_unit_dir=${placeholder "out"}/lib/systemd/system"
    "-Dsystemd_sysusers_dir=${placeholder "out"}/lib/sysusers.d"
    "-Dsystemd_tmpfiles_dir=${placeholder "out"}/lib/tmpfiles.d"
    "-Dtests=false"
    # TODO: restore when freerdp is available
    # "-Dc_args=-I${freerdp}/include/winpr3"
  ];

  meta = {
    homepage = "https://gitlab.gnome.org/GNOME/gnome-remote-desktop";
    changelog = "https://gitlab.gnome.org/GNOME/gnome-remote-desktop/-/blob/${finalAttrs.version}/NEWS?ref_type=tags";
    description = "GNOME Remote Desktop server";
    mainProgram = "grdctl";
    license = lib.licenses.gpl2Plus;
    platforms = lib.platforms.linux;
  };
})
