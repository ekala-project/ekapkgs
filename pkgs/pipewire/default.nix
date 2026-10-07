{
  stdenv,
  lib,
  buildPackages,
  fetchFromGitLab,
  fetchpatch,
  python3,
  meson,
  ninja,
  freebsd,
  elogind,
  libinotify-kqueue ? null,
  epoll-shim,
  systemd,
  enableSystemd ? lib.meta.availableOn stdenv.hostPlatform systemd, # enableSystemd=false maintained by maintainers.qyliss.
  pkg-config,
  docutils,
  doxygen,
  graphviz,
  glib,
  dbus,
  alsa-lib,
  libjack2,
  libusb1,
  udev,
  libsndfile,
  vulkanSupport ? true,
  vulkan-headers,
  vulkan-loader,
  webrtc-audio-processing,
  ncurses,
  readline, # meson can't find <7 as those versions don't have a .pc file
  lilv,
  makeFontsConf,
  valgrind,
  libcamera ? null,
  libdrm,
  gstreamer,
  # ffmpeg depends on SDL2 which depends on pipewire by default.
  # Break the cycle by depending on ffmpeg.headless, which excludes SDL2.
  # Pipewire only uses libavcodec (via an SPA plugin), which isn't
  # affected by the headless changes.
  ffmpeg,
  fftw,
  bluezSupport ? stdenv.hostPlatform.isLinux,
  bluez,
  sbc,
  libfreeaptx,
  liblc3,
  fdk_aac,
  libopus,
  ldacbt,
  spandsp ? null,
  modemmanager ? null,
  libpulseaudio,
  onnxruntimeSupport ? false,
  onnxruntime ? null,
  zeroconfSupport ? false, # TODO(ekapkgs): re-enable when avahi provides libavahi-client
  avahi,
  raopSupport ? true,
  openssl,
  roc-toolkit ? null,
  rocSupport ? roc-toolkit != null,
  x11Support ? true,
  libcanberra,
  libxfixes,
  libx11,
  libxcb,
  libmysofa,
  ffado ? null,
  ffadoSupport ?
    x11Support
    && lib.systems.equals stdenv.buildPlatform stdenv.hostPlatform
    && ffado != null
    && lib.meta.availableOn stdenv.hostPlatform ffado,
  libselinux,
  libebur128,
  bashNonInteractive,
}:

let
  modemmanagerSupport = lib.meta.availableOn stdenv.hostPlatform modemmanager;
  libcameraSupport = lib.meta.availableOn stdenv.hostPlatform libcamera;
  ldacbtSupport = lib.meta.availableOn stdenv.hostPlatform ldacbt;
  webrtcAudioProcessingSupport = lib.meta.availableOn stdenv.hostPlatform webrtc-audio-processing;
in

stdenv.mkDerivation (finalAttrs: {
  pname = "pipewire";
  version = "1.6.8";

  outputs = [
    "out"
    "jack"
    "dev"
    "doc"
    "man"
    "installedTests"
  ];

  src = fetchFromGitLab {
    domain = "gitlab.freedesktop.org";
    owner = "pipewire";
    repo = "pipewire";
    tag = finalAttrs.version;
    hash = "sha256-sxS6+LtvpEWCKoKLDUSYkW4+rrcIXPjWPBglReIDh/k=";
  };

  patches = [
    # Load libjack from a known location
    ./0060-libjack-path.patch
    # Move installed tests into their own output.
    ./0070-installed-tests-path.patch

    (fetchpatch {
      name = "musl.patch";
      url = "https://gitlab.freedesktop.org/pipewire/pipewire/-/commit/49ce385c44f4c2882ef0aeac0312e6ae9bc85f8a.patch";
      hash = "sha256-u8DLe6smodalVn3GwhI9RaDZTw4qZs8+Ylg9lxunMF0=";
    })
  ];

  strictDeps = true;
  __structuredAttrs = true;
  separateDebugInfo = true;

  depsBuildBuild = [ buildPackages.stdenv.cc ];
  nativeBuildInputs = [
    docutils
    doxygen
    graphviz
    meson
    meson.configurePhaseHook
    ninja
    pkg-config
    python3
    glib
  ];

  buildInputs = [
    dbus
    ffmpeg.headless
    fftw.float
    glib
    gstreamer.plugins-base
    gstreamer
    libebur128
    libjack2
    libmysofa
    libopus
    libpulseaudio
    libusb1
    libsndfile
    lilv
    ncurses
    readline
    bashNonInteractive
  ]
  ++ (
    if enableSystemd then
      [ systemd ]
    else if stdenv.hostPlatform.isLinux then
      [
        elogind
        udev
      ]
    else
      [ ]
  )
  ++ lib.optionals stdenv.hostPlatform.isFreeBSD [
    libinotify-kqueue
    epoll-shim
    freebsd.libstdthreads
  ]
  ++ lib.optional webrtcAudioProcessingSupport webrtc-audio-processing
  ++ lib.optional stdenv.hostPlatform.isLinux alsa-lib
  ++ lib.optional ldacbtSupport ldacbt
  ++ lib.optional libcameraSupport libcamera
  ++ lib.optional zeroconfSupport avahi
  ++ lib.optional raopSupport openssl
  ++ lib.optional rocSupport roc-toolkit
  ++ lib.optionals vulkanSupport [
    libdrm
    vulkan-headers
    vulkan-loader
  ]
  ++ lib.optionals x11Support [
    libcanberra
    libx11
    libxcb
    libxfixes
  ]
  ++ lib.optionals bluezSupport [
    bluez
    libfreeaptx
    liblc3
    sbc
    fdk_aac
    spandsp
  ]
  ++ lib.optional ffadoSupport ffado
  ++ lib.optional stdenv.hostPlatform.isLinux libselinux
  ++ lib.optional onnxruntimeSupport onnxruntime
  ++ lib.optional modemmanagerSupport modemmanager;

  # Valgrind binary is required for running one optional test.
  nativeCheckInputs = lib.optional (lib.meta.availableOn stdenv.hostPlatform valgrind) valgrind;

  mesonEntries = {
    udevrulesdir = "lib/udev/rules.d";
    installed_test_prefix = (placeholder "installedTests");
    libjack-path = "${placeholder "jack"}/lib";
    logind-provider = (if enableSystemd then "libsystemd" else "libelogind");
    sysconfdir = "/etc";
    session-managers = "";
    rlimits-install = false;
  };

  mesonFeatures = {
    pipewire-alsa = stdenv.hostPlatform.isLinux;
    alsa = stdenv.hostPlatform.isLinux;
    docs = true;
    installed_tests = true;
    echo-cancel-webrtc = webrtcAudioProcessingSupport;
    libcamera = (lib.meta.availableOn stdenv.hostPlatform libcamera);
    libffado = ffadoSupport;
    roc = rocSupport;
    libpulse = true;
    avahi = zeroconfSupport;
    gstreamer = true;
    gstreamer-device-provider = true;
    logind = stdenv.hostPlatform.isLinux;
    selinux = stdenv.hostPlatform.isLinux;
    avb = stdenv.hostPlatform.isLinux;
    v4l2 = stdenv.hostPlatform.isLinux;
    pipewire-v4l2 = stdenv.hostPlatform.isLinux;
    libsystemd = enableSystemd;
    systemd-system-service = enableSystemd;
    udev = stdenv.hostPlatform.isLinux;
    ffmpeg = true;
    pw-cat-ffmpeg = true;
    bluez5 = bluezSupport;
    bluez5-backend-hsp-native = bluezSupport;
    bluez5-backend-hfp-native = bluezSupport;
    bluez5-backend-native-mm = bluezSupport;
    bluez5-backend-ofono = bluezSupport;
    bluez5-backend-hsphfpd = bluezSupport;
    bluez5-codec-lc3plus = false;
    bluez5-codec-lc3 = bluezSupport;
    bluez5-codec-ldac = (bluezSupport && ldacbtSupport);
    bluez5-codec-ldac-dec = (bluezSupport && ldacbtSupport);
    opus = true;
    raop = raopSupport;
    vulkan = vulkanSupport;
    x11 = x11Support;
    x11-xfixes = x11Support;
    libcanberra = x11Support;
    libmysofa = true;
    sdl2 = false;
    compress-offload = true;
    man = true;
    snap = false;
    onnxruntime = onnxruntimeSupport;
  };

  # Fontconfig error: Cannot load default config file
  env.FONTCONFIG_FILE = makeFontsConf { fontDirectories = [ ]; };

  doCheck = true;
  doInstallCheck = true;

  postPatch = ''
    patchShebangs doc/*.py
    patchShebangs doc/input-filter-h.sh

    # Remove problematic installed-tests
    sed -i -e "/test-pipewire-alsa-stress/d" pipewire-alsa/tests/meson.build
    sed -i -e "/benchmark-aec/d" spa/tests/meson.build
  '';

  postInstall = ''
    moveToOutput "bin/pw-jack" "$jack"
  '';

  meta = {
    description = "Server and user space API to deal with multimedia pipelines";
    changelog = "https://gitlab.freedesktop.org/pipewire/pipewire/-/releases/${finalAttrs.version}";
    homepage = "https://pipewire.org/";
    license = lib.licenses.mit;
    platforms = lib.platforms.linux ++ lib.platforms.freebsd;
    pkgConfigModules = [
      "libpipewire-0.3"
      "libspa-0.2"
    ];
  };
})
