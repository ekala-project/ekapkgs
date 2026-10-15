{
  lib,
  stdenv,
  fetchFromGitHub,
  meson,
  ninja,
  python3,
  pkg-config,
  ldc,
  dconf,
  dbus,
  gsettings-desktop-schemas,
  desktop-file-utils,
  gettext,
  gtkd,
  libsecret,
  gtk3,
  libunwind,
  appstream,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "tilix";
  version = "1.9.6";

  src = fetchFromGitHub {
    owner = "gnunn1";
    repo = "tilix";
    rev = finalAttrs.version;
    hash = "sha256-KP0ojwyZ5FaYKW0nK9mGGAiz1h+gTbfjCUDCgN2LAO8=";
  };

  # Default upstream else LDC fails to link
  mesonBuildType = [
    "debugoptimized"
  ];

  nativeBuildInputs = [
    appstream
    desktop-file-utils
    gtk3.wrapGAppsHook
    ldc
    meson
    ninja
    pkg-config
    python3
  ];

  buildInputs = [
    dbus
    dconf
    gettext
    gsettings-desktop-schemas
    gtkd
    libsecret
    libunwind
  ];

  postPatch = ''
    chmod +x meson_post_install.py
    patchShebangs meson_post_install.py
    # https://aur.archlinux.org/cgit/aur.git/tree/PKGBUILD?h=tilix
    substituteInPlace source/gx/tilix/{prefeditor/prefdialog.d,terminal/terminal.d} \
      --replace-fail "(Align." "(GtkAlign."
  '';

  meta = {
    description = "Tiling terminal emulator following the Gnome Human Interface Guidelines";
    homepage = "https://gnunn1.github.io/tilix-web";
    license = lib.licenses.mpl20;
    platforms = lib.platforms.linux;
    mainProgram = "tilix";
  };
})
