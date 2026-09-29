{
  stdenv,
  lib,
  fetchFromGitHub,
  fetchpatch,
  meson,
  ninja,
  gettext,
  desktop-file-utils,
  appstream-glib,
  pkg-config,
  txt2man,
  vala,
  gsettings-desktop-schemas,
  gtk3,
  glib,
  cairo,
  keybinder3,
  ffmpeg,
  python3,
  libxml2,
  gstreamer,
  which,
  gifski,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "peek";
  version = "1.5.1";

  src = fetchFromGitHub {
    owner = "phw";
    repo = "peek";
    rev = finalAttrs.version;
    sha256 = "1xwlfizga6hvjqq127py8vabaphsny928ar7mwqj9cyqfl6fx41x";
  };

  patches = [
    # Fix compatibility with GNOME Shell >= 40.
    # https://github.com/phw/peek/pull/910
    (fetchpatch {
      url = "https://github.com/phw/peek/commit/008d15316ab5428363c512b263ca8138cb8f52ba.patch";
      sha256 = "xxJ+r5uRk93MEzWTFla88ewZsnUl3+YKTenzDygtKP0=";
    })
  ];

  nativeBuildInputs = [
    appstream-glib
    desktop-file-utils
    gettext
    meson
    meson.configurePhaseHook
    ninja
    libxml2
    pkg-config
    txt2man
    python3
    vala
    gtk3.wrapGAppsHook
  ];

  buildInputs = [
    cairo
    glib
    gsettings-desktop-schemas
    gtk3
    gstreamer
    gstreamer.plugins-good
    gstreamer.plugins-ugly
    keybinder3
  ];

  postPatch = ''
    patchShebangs build-aux/meson/postinstall.py data/man/build_man.sh
  '';

  preFixup = ''
    gappsWrapperArgs+=(--prefix PATH : ${
      lib.makeBinPath [
        which
        ffmpeg
        gifski
      ]
    })
  '';

  meta = {
    homepage = "https://github.com/phw/peek";
    description = "Simple animated GIF screen recorder with an easy to use interface";
    license = lib.licenses.gpl3Plus;
    platforms = lib.platforms.linux;
    mainProgram = "peek";
  };
})
