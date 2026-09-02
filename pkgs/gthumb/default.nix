{
  stdenv,
  lib,
  fetchurl,
  pkg-config,
  meson,
  ninja,
  exiv2,
  libheif,
  libjpeg,
  libtiff,
  gst_all_1,
  libraw,
  glib,
  gtk3,
  gsettings-desktop-schemas,
  libjxl,
  librsvg,
  libwebp,
  libx11,
  lcms2,
  bison,
  brasero ? null,
  flex,
  clutter-gtk ? null,
  colord,
  wrapGAppsHook3,
  shared-mime-info,
  python3,
  desktop-file-utils,
  itstool,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "gthumb";
  version = "3.12.10";

  src = fetchurl {
    url = "mirror://gnome/sources/gthumb/${lib.versions.majorMinor finalAttrs.version}/gthumb-${finalAttrs.version}.tar.xz";
    sha256 = "sha256-MiI0RlPNb7XXmBtzlRrj2QxBT3QiCoschmWyVXQoTHU=";
  };

  strictDeps = true;

  nativeBuildInputs = [
    bison
    desktop-file-utils
    flex
    itstool
    meson
    meson.configurePhaseHook
    ninja
    pkg-config
    python3
    wrapGAppsHook3
  ];

  buildInputs = [
    colord
    exiv2
    glib
    gsettings-desktop-schemas
    gst_all_1.gst-plugins-base
    (gst_all_1.gst-plugins-good.override { gtkSupport = true; })
    gst_all_1.gst-plugins-bad
    gst_all_1.gst-plugins-ugly
    gtk3
    lcms2
    libheif
    libjpeg
    libjxl
    libraw
    librsvg
    libtiff
    libwebp
    libx11
  ]
  ++ lib.optional (brasero != null) brasero
  ++ lib.optional (clutter-gtk != null) clutter-gtk;

  postPatch = ''
    chmod +x gthumb/make-gthumb-h.py

    patchShebangs data/gschemas/make-enums.py \
      gthumb/make-gthumb-h.py \
      po/make-potfiles-in.py \
      gthumb/make-authors-tab.py
  '';

  preFixup = ''
    gappsWrapperArgs+=(--prefix XDG_DATA_DIRS : "${shared-mime-info}/share")
  '';

  meta = {
    homepage = "https://gitlab.gnome.org/GNOME/gthumb";
    description = "Image browser and viewer for GNOME";
    mainProgram = "gthumb";
    platforms = lib.platforms.linux;
    license = lib.licenses.gpl2Plus;
  };
})
