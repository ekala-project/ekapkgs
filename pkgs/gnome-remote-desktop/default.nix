{
  stdenv,
  lib,
  fetchurl,
  meson,
  ninja,
  pkg-config,
  python3,
  wrapGAppsHook3,
  asciidoc,
  cairo,
  fdk_aac,
  freerdp,
  fuse3,
  gdk-pixbuf,
  glib,
  libdrm,
  libei,
  libepoxy,
  libkrb5,
  libnotify,
  libopus,
  libsecret,
  libva,
  libxkbcommon,
  # TODO: nv-codec-headers-11 - not available
  pipewire,
  polkit,
  shaderc,
  systemd,
  tpm2-tss,
  vulkan-loader,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "gnome-remote-desktop";
  version = "50.2";

  src = fetchurl {
    url = "mirror://gnome/sources/gnome-remote-desktop/${lib.versions.major finalAttrs.version}/gnome-remote-desktop-${finalAttrs.version}.tar.xz";
    hash = "sha256-Md9ij0ETVz8Tb/yNwAF2Ou1jPNhb7SHli8YfihffCR8=";
  };

  nativeBuildInputs = [
    asciidoc
    meson
    meson.configurePhaseHook
    ninja
    pkg-config
    python3
    shaderc # for glslc
    wrapGAppsHook3
  ];

  buildInputs = [
    cairo
    fdk_aac
    freerdp
    fuse3
    gdk-pixbuf
    glib
    libdrm
    libei
    libepoxy
    libkrb5
    libnotify
    libopus
    libsecret
    libva
    libxkbcommon
    # TODO: nv-codec-headers-11 - not available
    pipewire
    polkit
    systemd
    tpm2-tss
    vulkan-loader
  ];

  mesonFlags = [
    "-Dconf_dir=/etc/gnome-remote-desktop"
    "-Dsystemd_user_unit_dir=${placeholder "out"}/lib/systemd/user"
    "-Dsystemd_system_unit_dir=${placeholder "out"}/lib/systemd/system"
    "-Dsystemd_sysusers_dir=${placeholder "out"}/lib/sysusers.d"
    "-Dsystemd_tmpfiles_dir=${placeholder "out"}/lib/tmpfiles.d"
    "-Dtests=false"
    "-Dc_args=-I${freerdp}/include/winpr3"
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
