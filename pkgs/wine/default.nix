{
  lib,
  stdenv,
  fetchurl,
  fetchpatch,

  # Native build inputs
  bison,
  flex,
  fontforge,
  gettext,
  makeWrapper,
  pkg-config,
  perl,

  # Build inputs (always)
  freetype,
  libunwind,
  libcap,

  # Optional features
  fontconfigSupport ? true,
  fontconfig,
  alsaSupport ? true,
  alsa-lib,
  openglSupport ? true,
  libGLU,
  libGL,
  libdrm,
  tlsSupport ? true,
  openssl,
  gnutls,
  x11Support ? true,
  libx11,
  libxcomposite,
  libxcursor,
  libxext,
  libxfixes,
  libxi,
  libxrandr,
  libxrender,
  libxxf86vm,
  xineramaSupport ? true,
  libxinerama,
  gettextSupport ? true,
  cursesSupport ? true,
  ncurses,
  dbusSupport ? true,
  dbus,
  cairoSupport ? true,
  cairo,
  pulseaudioSupport ? true,
  libpulseaudio,
  udevSupport ? true,
  udev,
  sdlSupport ? true,
  sdl2-compat,
  vulkanSupport ? true,
  vulkan-loader,
  usbSupport ? true,
  libusb1,
  # TODO(ekapkgs): enable mingw when pkgsCross.mingwW64 is available
  # mingwSupport ? true,
  ffmpegSupport ? true,
  ffmpeg,
  waylandSupport ? true,
  wayland,
  wayland-scanner,
  libxkbcommon,
  wayland-protocols,
  libgbm,
  cupsSupport ? false,
  cups ? null,
  pcapSupport ? false,
  libpcap ? null,
  vaSupport ? false,
  libva ? null,
  saneSupport ? false,
  sane-backends ? null,
  gphoto2Support ? false,
  libgphoto2 ? null,
  krb5Support ? false,
  libkrb5 ? null,
  v4lSupport ? false,
  libv4l ? null,
  odbcSupport ? false,
  unixODBC ? null,
  smartcardSupport ? false,
  pcsclite ? null,
}:

let
  version = "11.0";
in
stdenv.mkDerivation (finalAttrs: {
  pname = "wine64";
  inherit version;

  src = fetchurl {
    url = "https://dl.winehq.org/wine/source/11.0/wine-${version}.tar.xz";
    hash = "sha256-wHpoV5M8H8YN/1RI1585ySSBwenbWqYo250DWERuBwE=";
  };

  patches = [
    # Also look for root certificates at $NIX_SSL_CERT_FILE
    ./cert-path.patch
    # Fix LOAD_CONFIG_DIRECTORY handling for PE binaries
    (fetchpatch {
      name = "add-dll-accept-device-paths";
      url = "https://gitlab.winehq.org/wine/wine/-/commit/401910ae25a11032f2da7baa1666d71e8bca2496.patch";
      hash = "sha256-2726u9/vhhx39Tq7vOw24hslmeyZZEbxRRqe7JMFvCU";
    })
  ];

  # Fixes "Compiler cannot create executables" building with mingwSupport
  strictDeps = true;

  nativeBuildInputs = [
    bison
    flex
    fontforge
    makeWrapper
    pkg-config
  ]
  ++ lib.optional gettextSupport gettext;

  buildInputs = [
    freetype
    perl
    libunwind
    libcap
  ]
  ++ lib.optional fontconfigSupport fontconfig
  ++ lib.optional alsaSupport alsa-lib
  ++ lib.optional dbusSupport dbus
  ++ lib.optional cairoSupport cairo
  ++ lib.optional cursesSupport ncurses
  ++ lib.optional cupsSupport cups
  ++ lib.optional odbcSupport unixODBC
  ++ lib.optional vaSupport libva
  ++ lib.optional pcapSupport libpcap
  ++ lib.optional v4lSupport libv4l
  ++ lib.optional saneSupport sane-backends
  ++ lib.optional gphoto2Support libgphoto2
  ++ lib.optional krb5Support libkrb5
  ++ lib.optional pulseaudioSupport libpulseaudio
  ++ lib.optional (xineramaSupport && x11Support) libxinerama
  ++ lib.optional udevSupport udev
  ++ lib.optional vulkanSupport vulkan-loader
  ++ lib.optional sdlSupport sdl2-compat
  ++ lib.optional usbSupport libusb1
  ++ lib.optionals tlsSupport [
    openssl
    gnutls
  ]
  ++ lib.optionals (openglSupport) [
    libGLU
    libGL
    libdrm
  ]
  ++ lib.optionals x11Support [
    libx11
    libxcomposite
    libxcursor
    libxext
    libxfixes
    libxi
    libxrandr
    libxrender
    libxxf86vm
  ]
  ++ lib.optionals waylandSupport [
    wayland
    wayland-scanner
    libxkbcommon
    wayland-protocols
    wayland.dev
    libxkbcommon.dev
    libgbm
  ]
  ++ lib.optionals ffmpegSupport [
    ffmpeg.headless
  ]
  ++ lib.optionals smartcardSupport [
    pcsclite
  ];

  configureFlags = [
    "--enable-win64"
  ]
  ++ lib.optionals waylandSupport [ "--with-wayland" ]
  ++ lib.optionals vulkanSupport [ "--with-vulkan" ]
  ++ lib.optionals (!x11Support) [ "--without-x" ]
  ++ lib.optionals smartcardSupport [ "--with-pcsclite" ];

  # Wine locates many libraries dynamically through dlopen().
  # Add them to the RPATH so users don't have to set LD_LIBRARY_PATH.
  env.NIX_LDFLAGS = toString (
    map (path: "-rpath " + path) (
      map (x: "${lib.getLib x}/lib") ([ stdenv.cc.cc ] ++ finalAttrs.buildInputs)
      ++ lib.optionals pulseaudioSupport [
        "${lib.getLib libpulseaudio}/lib/pulseaudio"
      ]
      ++ lib.optionals waylandSupport [
        "${lib.getLib wayland-protocols}/share/wayland-protocols"
      ]
    )
  );

  # Just here to avoid rebuilds for now.
  env.NIX_CFLAGS_COMPILE = "";

  # Don't shrink the ELF RPATHs to keep the extra RPATH elements.
  dontPatchELF = true;

  doCheck = false;


  hardeningDisable = [
    "bindnow"
    "stackclashprotection"
  ];

  meta = {
    homepage = "https://www.winehq.org/";
    license = lib.licenses.lgpl21Plus;
    description = "Open Source implementation of the Windows API on top of X, OpenGL, and Unix";
    platforms = [
      "x86_64-linux"
    ];
    mainProgram = "wine";
  };
})
