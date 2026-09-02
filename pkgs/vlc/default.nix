{
  lib,
  alsa-lib,
  autoreconfHook,
  avahi,
  bison,
  cairo,
  dbus,
  faad2,
  fetchFromGitLab,
  fetchpatch,
  ffmpeg,
  flac,
  flex,
  fluidsynth,
  fontconfig,
  freefont_ttf,
  freetype,
  fribidi,
  gnutls,
  harfbuzz,
  libGL,
  libsm,
  libxext,
  libxinerama,
  libxpm,
  libarchive,
  libaacs,
  libass,
  libbluray,
  libcaca,
  libcddb,
  libdc1394,
  libdvbpsi,
  libdvdnav,
  libdvdread,
  libebml,
  libgcrypt,
  libgpg-error,
  libjack2,
  libjpeg,
  libkate,
  libmad,
  libmatroska,
  libmicrodns,
  libmodplug,
  libmtp,
  libogg,
  libopus,
  libpng,
  libpulseaudio,
  librsvg,
  libsamplerate,
  libssh2,
  libtheora,
  libtiger,
  libupnp,
  libv4l,
  libva,
  libvorbis,
  libxml2,
  live555,
  lua5_4,
  ncurses,
  perl,
  pkg-config,
  pkgsBuildBuild,
  protobuf,
  removeReferencesTo,
  samba,
  schroedinger,
  speex,
  srt,
  stdenv,
  systemdLibs,
  taglib,
  unzip,
  wayland,
  wayland-protocols,
  wayland-scanner,
  wrapGAppsHook3,
  libxcb-keysyms,
  zlib,
  chromecastSupport ? true,
  jackSupport ? false,
  onlyLibVLC ? false,
  skins2Support ? !onlyLibVLC,
  waylandSupport ? true,
}:

let
  inherit (lib) optionalString optionals;
in
stdenv.mkDerivation (finalAttrs: {
  pname = "${optionalString onlyLibVLC "lib"}vlc";
  version = "3.0.23-2";

  src = fetchFromGitLab {
    domain = "code.videolan.org";
    owner = "videolan";
    repo = "vlc";
    rev = finalAttrs.version;
    hash = "sha256-vg/kKNrIpGF7Olz8EiA1ZsW5SB4iHlvFbREDp4JokB0=";
  };

  depsBuildBuild = optionals waylandSupport [ pkg-config ];

  nativeBuildInputs = [
    autoreconfHook
    bison
    flex
    lua5_4
    perl
    pkg-config
    removeReferencesTo
    unzip
    wrapGAppsHook3
  ]
  ++ optionals chromecastSupport [ protobuf ]
  ++ optionals waylandSupport [
    wayland-scanner
  ];

  # VLC uses a *ton* of libraries for various pieces of functionality, many of
  # which are not included here for no other reason that nobody has mentioned
  # needing them
  buildInputs = [
    alsa-lib
    avahi
    cairo
    dbus
    faad2
    ffmpeg
    flac
    fluidsynth
    fontconfig
    freetype
    fribidi
    gnutls
    harfbuzz
    libGL
    libsm
    libarchive
    libaacs
    libass
    libbluray
    libcaca
    libcddb
    libdc1394
    libdvbpsi
    libdvdnav
    libdvdread
    libebml
    libgcrypt
    libgpg-error
    libjpeg
    libkate
    libmad
    libmatroska
    libmodplug
    libmtp
    libogg
    libopus
    libpng
    libpulseaudio
    librsvg
    libsamplerate
    libssh2
    libtheora
    libtiger
    libupnp
    libv4l
    libva
    libvorbis
    libxml2
    lua5_4
    ncurses
    samba
    schroedinger
    speex
    srt
    systemdLibs
    taglib
    libxcb-keysyms
    zlib
  ]
  ++ optionals (!onlyLibVLC) [ live555 ]
  ++ optionals jackSupport [ libjack2 ]
  ++ optionals chromecastSupport [
    libmicrodns
    protobuf
  ]
  ++ optionals skins2Support [
    libxext
    libxinerama
    libxpm
  ]
  ++ optionals waylandSupport [
    wayland
    wayland-protocols
  ];

  strictDeps = true;
  __structuredAttrs = true;

  outputs = [
    "out"
    "dev"
    "doc"
    "man"
  ];

  env = {
    # vlc searches for c11-gcc, c11, c99-gcc, c99, which don't exist and would be wrong for cross compilation anyway.
    BUILDCC = lib.getExe pkgsBuildBuild.stdenv.cc;
    LIVE555_PREFIX = live555;
  };

  patches = [
    # patch to build with recent live555
    # upstream issue: https://code.videolan.org/videolan/vlc/-/issues/25473
    (fetchpatch {
      url = "https://code.videolan.org/videolan/vlc/uploads/eb1c313d2d499b8a777314f789794f9d/0001-Add-lssl-and-lcrypto-to-liblive555_plugin_la_LIBADD.patch";
      hash = "sha256-qs3gY1ksCZlf931TSZyMuT2JD0sqrmcRCZwL+wVG0U8=";
    })
    # make the plugins.dat file generation reproducible
    ./deterministic-plugin-cache.diff
  ];

  postPatch = ''
    echo "$version" > src/revision.txt
    substituteInPlace modules/text_renderer/freetype/platform_fonts.h \
      --replace-fail \
        /usr/share/fonts/truetype/freefont \
        ${freefont_ttf}/share/fonts/truetype
  '';

  enableParallelBuilding = true;

  # Most of the libraries are auto-detected so we don't need to set a bunch of
  # "--enable-foo" flags here
  configureFlags = [
    "--with-kde-solid=$out/share/apps/solid/actions"
    "--disable-qt" # Build without Qt5 since libsForQt5 subpackages are unavailable
  ]
  ++ optionals onlyLibVLC [ "--disable-vlc" ]
  ++ optionals skins2Support [ "--enable-skins2" ]
  ++ optionals waylandSupport [ "--enable-wayland" ]
  ++ optionals chromecastSupport [
    "--enable-sout"
    "--enable-chromecast"
    "--enable-microdns"
  ];

  # Remove runtime dependencies on libraries
  postConfigure = ''
    sed -i 's|^#define CONFIGURE_LINE.*$|#define CONFIGURE_LINE "<removed>"|g' config.h
  '';

  # Add missing SOFA files
  # Given in EXTRA_DIST, but not in install-data target
  postInstall = ''
    cp -R share/hrtfs $out/share/vlc
  '';

  # - Touch plugins (plugins cache keyed off mtime and file size)
  # - Remove references to the Qt development headers (used in error messages)
  postFixup = ''
    patchelf --add-rpath ${libaacs}/lib "$out/lib/vlc/plugins/access/liblibbluray_plugin.so"
    patchelf --add-rpath ${libv4l}/lib "$out/lib/vlc/plugins/access/libv4l2_plugin.so"
    find $out/lib/vlc/plugins -exec touch -d @1 '{}' ';'
    ${
      if stdenv.buildPlatform.canExecute stdenv.hostPlatform then "$out" else pkgsBuildBuild.libvlc
    }/lib/vlc/vlc-cache-gen $out/vlc/plugins
  '';

  meta = {
    description = "Cross-platform media player and streaming server";
    homepage = "https://www.videolan.org/vlc/";
    license = lib.licenses.lgpl21Plus;
    platforms = lib.platforms.linux;
    mainProgram = "vlc";
  };
})
