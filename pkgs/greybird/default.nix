{
  stdenv,
  lib,
  fetchFromGitHub,
  gdk-pixbuf,
  glib,
  meson,
  ninja,
  pkg-config,
  sassc,
  librsvg,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "greybird";
  version = "3.23.4";

  src = fetchFromGitHub {
    owner = "shimmerproject";
    repo = "greybird";
    rev = "v${finalAttrs.version}";
    hash = "sha256-De8y+LRQ26UKrUECLCcbCg7p9Z+aRssQ/7YzegAUPw4=";
  };

  strictDeps = true;

  nativeBuildInputs = [
    gdk-pixbuf
    glib
    meson
    meson.configurePhaseHook
    ninja
    pkg-config
    sassc
    librsvg
  ];

  postPatch = ''
    export GDK_PIXBUF_MODULE_FILE=$(mktemp)
    ${gdk-pixbuf.dev}/bin/gdk-pixbuf-query-loaders ${librsvg}/lib/gdk-pixbuf-2.0/2.10.0/loaders/*.so ${gdk-pixbuf}/lib/gdk-pixbuf-2.0/2.10.0/loaders/*.so > "$GDK_PIXBUF_MODULE_FILE"
  '';

  meta = {
    description = "Desktop suite for Xfce";
    homepage = "https://github.com/shimmerproject/Greybird";
    license = lib.licenses.gpl2Plus;
    platforms = lib.platforms.linux;
    maintainers = [ ];
  };
})
