{
  lib,
  stdenv,
  fetchurl,
  appstream-glib,
  desktop-file-utils,
  gettext,
  glib,
  gtk3,
  gusb,
  libcanberra-gtk3 ? null, # TODO: not in ekapkgs, needs porting or corepkgs (libcanberra is available but libcanberra-gtk3 variant may need checking)
  libgudev,
  meson,
  ninja,
  pkg-config,
  wrapGAppsHook3,
  polkit,
  udisks, # called udisks2 in nixpkgs, udisks in ekapkgs
}:

stdenv.mkDerivation rec {
  pname = "gnome-multi-writer";
  version = "3.35.90";

  src = fetchurl {
    url = "mirror://gnome/sources/gnome-multi-writer/${lib.versions.majorMinor version}/gnome-multi-writer-${version}.tar.xz";
    sha256 = "07vgzjjdrxcp7h73z13h9agafxb4vmqx5i81bcfyw0ilw9kkdzmp";
  };

  nativeBuildInputs = [
    appstream-glib
    desktop-file-utils
    gettext
    meson
    ninja
    pkg-config
    wrapGAppsHook3
  ];

  buildInputs = [
    glib
    gtk3
    gusb
  ] ++ lib.optional (libcanberra-gtk3 != null) libcanberra-gtk3 ++ [
    libgudev
    polkit
    udisks
  ];

  meta = {
    description = "Tool for writing an ISO file to multiple USB devices at once";
    mainProgram = "gnome-multi-writer";
    homepage = "https://gitlab.gnome.org/GNOME/gnome-multi-writer";
    license = lib.licenses.gpl2Plus;
    platforms = lib.platforms.linux;
    maintainers = [ ];
  };
}
