{
  lib,
  stdenv,
  fetchurl,
  pkg-config,
  meson,
  gettext,
  gobject-introspection,
  glib,
  gtk3,
  # TODO: evince (not yet ported)
  # TODO: gtksourceview4 (not yet ported)
  # TODO: gjs (being ported)
  # TODO: libsoup_3 (not yet ported)
  # TODO: webkitgtk_4_1 (not available)
  icu,
  wrapGAppsHook3,
  gst_all_1,
  gdk-pixbuf,
  # TODO: librsvg (not yet ported)
  harfbuzz,
  ninja,
  # TODO: libepoxy (not yet ported)
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "sushi";
  version = "50.0";

  src = fetchurl {
    url = "mirror://gnome/sources/sushi/${lib.versions.major finalAttrs.version}/sushi-${finalAttrs.version}.tar.xz";
    hash = "sha256-qyUXeQjVzMWFaHaageubTzIwZ4bmxzYYGT6/YaEn7gA=";
  };

  nativeBuildInputs = [
    pkg-config
    meson
    meson.configurePhaseHook
    ninja
    gettext
    gobject-introspection
    wrapGAppsHook3
  ];

  buildInputs = [
    glib
    gtk3
    # TODO: evince
    icu
    harfbuzz
    # TODO: gjs (being ported)
    # TODO: gtksourceview4
    gdk-pixbuf
    # TODO: librsvg
    # TODO: libsoup_3
    # TODO: webkitgtk_4_1 (not available)
    # TODO: libepoxy
    gst_all_1.gstreamer
    gst_all_1.gst-plugins-base
    # TODO: gst-plugins-good (with gtkSupport), gst-plugins-bad, gst-plugins-ugly
  ];

  # TODO: postPatch to fix gjs path once gjs is available
  # postPatch = ''
  #   substituteInPlace meson.build \
  #     --replace-fail "gjs = find_program('gjs', 'gjs-console')" "gjs = find_program('${lib.getExe gjs}')"
  # '';

  # See https://github.com/NixOS/nixpkgs/issues/31168
  postInstall = ''
    for file in $out/libexec/org.gnome.NautilusPreviewer
    do
      sed -e $"2iimports.package._findEffectiveEntryPointName = () => \'$(basename $file)\' " \
        -i $file
    done
  '';

  strictDeps = true;

  meta = {
    homepage = "https://gitlab.gnome.org/GNOME/sushi";
    changelog = "https://gitlab.gnome.org/GNOME/sushi/-/blob/${finalAttrs.version}/NEWS?ref_type=tags";
    description = "Quick previewer for Nautilus";
    mainProgram = "sushi";
    maintainers = [ ];
    license = lib.licenses.gpl2Plus;
    platforms = lib.platforms.linux;
  };
})
