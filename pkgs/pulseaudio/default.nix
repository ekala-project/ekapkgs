{
  lib,
  stdenv,
  fetchurl,
  fetchpatch2,
  pkg-config,
  libsndfile,
  libtool,
  makeWrapper,
  perlPackages,
  libcap,
  alsa-lib,
  glib,
  dbus,
  udev,
  udevCheckHook,
  openssl,
  fftw,
  speexdsp,
  check,
  libintl,
  meson,
  ninja,
  m4,

  alsaSupport ? stdenv.hostPlatform.isLinux,
  udevSupport ? stdenv.hostPlatform.isLinux,

  # Whether to build only the library.
  libOnly ? false,
}:

let
  fftwFloat = fftw.override { precision = "single"; };
in

stdenv.mkDerivation rec {
  pname = "${lib.optionalString libOnly "lib"}pulseaudio";
  version = "17.0";

  src = fetchurl {
    url = "https://freedesktop.org/software/pulseaudio/releases/pulseaudio-${version}.tar.xz";
    hash = "sha256-BTeU1mcaPjl9hJ5HioC4KmPLnYyilr01tzMXu1zrh7U=";
  };

  patches = [
    ./add-option-for-installation-sysconfdir.patch

    (fetchpatch2 {
      name = "alsa-ucm-Check-UCM-verb-before-working-with-device-status.patch";
      url = "https://gitlab.freedesktop.org/pulseaudio/pulseaudio/-/commit/f5cacd94abcc47003bd88ad7ca1450de649ffb15.patch";
      hash = "sha256-WyEqCitrqic2n5nNHeVS10vvGy5IzwObPPXftZKy/A8=";
    })
    (fetchpatch2 {
      name = "alsa-ucm-Replace-port-device-UCM-context-assertion-with-an-error.patch";
      url = "https://gitlab.freedesktop.org/pulseaudio/pulseaudio/-/commit/ed3d4f0837f670e5e5afb1afa5bcfc8ff05d3407.patch";
      hash = "sha256-fMJ3EYq56sHx+zTrG6osvI/QgnhqLvWiifZxrRLMvns=";
    })
  ];

  postPatch = ''
    sed -i "/fail_unless(pthread_setaffinity_np/d" src/tests/once-test.c
  '';

  outputs = [
    "out"
    "dev"
  ];

  nativeBuildInputs = [
    pkg-config
    meson
    meson.configurePhaseHook
    ninja
    makeWrapper
    perlPackages.perl
    perlPackages.XMLParser
    m4
    udevCheckHook
  ] ++ lib.optionals (!stdenv.hostPlatform.isDarwin) [ glib ];

  propagatedBuildInputs = lib.optionals stdenv.hostPlatform.isLinux [ libcap ];

  buildInputs = [
    libtool
    libsndfile
    speexdsp
    fftwFloat
    check
  ]
  ++ lib.optionals (!stdenv.hostPlatform.isDarwin) [
    glib
    dbus
  ]
  ++ lib.optionals (stdenv.hostPlatform.isDarwin || stdenv.hostPlatform.isFreeBSD) [
    libintl
  ]
  ++ lib.optionals (!libOnly) (
    lib.optionals stdenv.hostPlatform.isLinux [
      alsa-lib
      udev
    ]
  );

  mesonFlags = [
    (lib.mesonEnable "alsa" (!libOnly && alsaSupport))
    (lib.mesonEnable "asyncns" false)
    (lib.mesonEnable "avahi" false)
    (lib.mesonEnable "bluez5" false)
    (lib.mesonEnable "bluez5-gstreamer" false)
    (lib.mesonOption "database" "simple")
    (lib.mesonBool "doxygen" false)
    (lib.mesonEnable "elogind" false)
    (lib.mesonEnable "gsettings" (
      stdenv.hostPlatform.isLinux && (stdenv.buildPlatform == stdenv.hostPlatform)
    ))
    (lib.mesonEnable "gstreamer" false)
    (lib.mesonEnable "gtk" false)
    (lib.mesonEnable "jack" false)
    (lib.mesonEnable "lirc" false)
    (lib.mesonEnable "openssl" false)
    (lib.mesonEnable "orc" false)
    (lib.mesonEnable "soxr" false)
    (lib.mesonEnable "systemd" false)
    (lib.mesonEnable "tcpwrap" false)
    (lib.mesonEnable "udev" (!libOnly && udevSupport))
    (lib.mesonEnable "valgrind" false)
    (lib.mesonEnable "webrtc-aec" false)
    (lib.mesonEnable "x11" false)

    (lib.mesonOption "localstatedir" "/var")
    (lib.mesonOption "sysconfdir" "/etc")
    (lib.mesonOption "sysconfdir_install" "${placeholder "out"}/etc")
    (lib.mesonOption "udevrulesdir" "${placeholder "out"}/lib/udev/rules.d")

    "--bindir=${placeholder "out"}/.bin-unwrapped"
  ];

  doCheck = !stdenv.hostPlatform.isDarwin;

  doInstallCheck = true;

  preCheck = ''
    export HOME=$(mktemp -d)
  '';

  postInstall =
    lib.optionalString libOnly ''
      find $out/share -maxdepth 1 -mindepth 1 ! -name "vala" -prune -exec rm -r {} \;
      find $out/share/vala -maxdepth 1 -mindepth 1 ! -name "vapi" -prune -exec rm -r {} \;
      rm -r $out/{.bin-unwrapped,etc,lib/pulse-*}
    ''
    + ''
      moveToOutput lib/cmake "$dev"
      rm -f $out/.bin-unwrapped/qpaeq

      cp config.h $dev/include/pulse
    '';

  preFixup =
    lib.optionalString (!libOnly) ''
      mkdir -p $out/bin
      ln -st $out/bin $out/.bin-unwrapped/*

      find "$out" -name "*.service" | while read f; do
          substituteInPlace "$f" --replace "$out/.bin-unwrapped/" "$out/bin/"
      done
    '';

  meta = {
    description = "Sound server for POSIX and Win32 systems";
    homepage = "http://www.pulseaudio.org/";
    license = lib.licenses.lgpl2Plus;
    maintainers = [ ];
    platforms = lib.platforms.unix;
  };
}
