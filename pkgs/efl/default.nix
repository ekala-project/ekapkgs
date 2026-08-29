{
  lib,
  stdenv,
  fetchurl,
  meson,
  ninja,
  pkg-config,
  SDL2,
  alsa-lib,
  bullet,
  check,
  curl,
  dbus,
  doxygen,
  expat,
  fontconfig,
  freetype,
  fribidi,
  giflib,
  glib,
  gstreamer,
  gtk3,
  harfbuzz,
  hicolor-icon-theme,
  libGL,
  libdrm,
  libgbm,
  libinput,
  libjpeg,
  libpng,
  libpulseaudio,
  libraw,
  librsvg,
  libsndfile,
  libspectre,
  libtiff,
  libwebp,
  libxkbcommon,
  lua5_1,
  lz4,
  mesa-gl-headers,
  mint-x-icons,
  openjpeg,
  openssl,
  poppler,
  systemd,
  udev,
  util-linux,
  wayland,
  wayland-protocols,
  wayland-scanner,
  writeText,
  libxtst,
  libxscrnsaver,
  libxrender,
  libxrandr,
  libxi,
  libxinerama,
  libxfixes,
  libxext,
  libxdamage,
  libxcursor,
  libxcomposite,
  libx11,
  xorgproto,
  libxcb,
  zlib,
}:
let
  inherit (lib)
    mesonBool
    mesonOption
    ;
in
stdenv.mkDerivation (finalAttrs: {
  pname = "efl";
  version = "1.28.1";

  src = fetchurl {
    url = "https://download.enlightenment.org/rel/libs/efl/efl-${finalAttrs.version}.tar.xz";
    hash = "sha256-hM9hRfnMgr//aQAFviQ5LI88UvjgD/BNjuo3FCnAlCQ=";
  };

  nativeBuildInputs = [
    meson
    meson.configurePhaseHook
    ninja
    gtk3
    pkg-config
    check
    wayland-scanner
  ];

  buildInputs = [
    fontconfig
    freetype
    giflib
    glib
    gstreamer.gst-plugins-base
    gstreamer.gst-plugins-good
    gstreamer.gstreamer
    # TODO: gst-libav not available; video codec support limited
    libGL
    libpng
    libpulseaudio
    libsndfile
    libtiff
    lz4
    mesa-gl-headers
    openssl
    systemd
    udev
    wayland-protocols
    libx11
    libxcursor
    xorgproto
    zlib
  ];

  propagatedBuildInputs = [
    SDL2
    alsa-lib
    bullet
    curl
    dbus
    doxygen
    expat
    fribidi
    # TODO: ghostscript fails to build (GCC 14 compat); disable PostScript support until fixed
    # ghostscript
    harfbuzz
    hicolor-icon-theme
    # jbig2dec  # only needed with ghostscript
    libdrm
    libgbm
    libinput
    libjpeg
    libraw
    librsvg
    # libspectre  # requires ghostscript
    libwebp
    libxkbcommon
    lua5_1
    mint-x-icons
    openjpeg
    poppler
    util-linux
    wayland
    libxscrnsaver
    libxcomposite
    libxdamage
    libxext
    libxfixes
    libxi
    libxinerama
    libxrandr
    libxrender
    libxtst
    libxcb
  ];

  strictDeps = true;

  dontDropIconThemeCache = true;

  # Fix build with gcc15 (-std=gnu23)
  env.NIX_CFLAGS_COMPILE = lib.optionalString stdenv.cc.isGNU "-std=gnu17";

  mesonBuildType = "release";

  mesonFlags = [
    (mesonBool "build-tests" false)
    (mesonOption "ecore-imf-loaders-disabler" "ibus,scim")
    (mesonBool "embedded-lz4" false)
    (mesonBool "fb" true)
    (mesonOption "network-backend" "connman")
    (mesonBool "sdl" true)
    (mesonBool "elua" true)
    (mesonOption "bindings" "lua,cxx")
    (mesonBool "wl" true)
    (mesonBool "drm" true)
  ];

  patches = [
    ./efl-elua.patch
  ];

  postPatch = ''
    patchShebangs src/lib/elementary/config_embed

    # fix destination of systemd unit and dbus service
    substituteInPlace systemd-services/meson.build --replace-fail "sys_dep.get_pkgconfig_variable('systemduserunitdir')" "'$out/systemd/user'"
    substituteInPlace dbus-services/meson.build --replace-fail "dep.get_pkgconfig_variable('session_bus_services_dir')" "'$out/share/dbus-1/services'"
  '';

  setupHook = writeText "setupHook.sh" ''
    export HOME="$TEMPDIR"
  '';

  preConfigure = ''
    export LD_LIBRARY_PATH="${curl.out}/lib''${LD_LIBRARY_PATH:+:}$LD_LIBRARY_PATH"

    source "$setupHook"
  '';

  postInstall = ''
    # fix use of $out variable
    substituteInPlace "$out/share/elua/core/util.lua" --replace-fail '$out' "$out"
    rm "$out/share/elua/core/util.lua.orig"

    # add all module include dirs to the Cflags field in efl.pc
    modules=$(for i in "$out/include/"*/; do printf ' -I''${includedir}/'`basename $i`; done)
    substituteInPlace "$out/lib/pkgconfig/efl.pc" \
      --replace-fail 'Cflags: -I''${includedir}/efl-1' \
                     'Cflags: -I''${includedir}/eina-1/eina'"$modules"

    # build icon cache
    gtk-update-icon-cache "$out"/share/icons/Enlightenment-X
  '';

  postFixup = ''
    patchelf --add-needed ${curl.out}/lib/libcurl.so $out/lib/libecore_con.so
    patchelf --add-needed ${libpulseaudio}/lib/libpulse.so $out/lib/libecore_audio.so
    patchelf --add-needed ${libsndfile.out}/lib/libsndfile.so $out/lib/libecore_audio.so
  '';

  meta = {
    description = "Enlightenment foundation libraries";
    homepage = "https://enlightenment.org/";
    license = with lib.licenses; [
      bsd2
      lgpl2Only
      zlib
    ];
    platforms = lib.platforms.linux;
  };
})
