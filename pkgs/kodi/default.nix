{
  lib,
  stdenv,
  fetchFromGitHub,
  fetchpatch,
  fetchzip,
  autoconf,
  automake,
  libtool,
  makeWrapper,
  pkg-config,
  cmake,
  yasm,
  python3,
  libxcrypt,
  libgcrypt,
  libgpg-error,
  libunistring,
  boost,
  avahi,
  lame,
  gettext,
  pcre-cpp,
  yajl,
  fribidi,
  which,
  openssl,
  gperf,
  tinyxml,
  tinyxml-2,
  taglib,
  libssh,
  jre_headless,
  gtest,
  ncurses,
  spdlog,
  libxml2,
  alsa-lib,
  libGLU,
  libGL,
  ffmpeg,
  fontconfig,
  freetype,
  ftgl,
  libjpeg,
  libpng,
  libtiff,
  libmpeg2,
  libsamplerate,
  libmad,
  libogg,
  libvorbis,
  flac,
  libxslt,
  lzo,
  libcdio,
  libmodplug,
  libass,
  libbluray,
  libudfread,
  sqlite,
  libmysqlclient,
  nasm,
  gnutls,
  libva,
  libdrm,
  curl,
  bzip2,
  zip,
  unzip,
  mesa-demos,
  libcec,
  libcec_platform,
  dcadec,
  libuuid,
  libmicrohttpd,
  bluez,
  doxygen,
  giflib,
  glib,
  harfbuzz,
  lcms2,
  libidn,
  libpthread-stubs,
  libtasn1,
  libplist,
  p11-kit,
  zlib,
  flatbuffers,
  fstrcmp,
  rapidjson,
  lirc,
  mesa-gl-headers,
  swig,
  x11Support ? true,
  libx11,
  xorgproto,
  libxt,
  libxmu,
  libxext,
  libxinerama,
  libxrandr,
  libxtst,
  libxfixes,
  xdpyinfo,
  libxdmcp,
  dbusSupport ? true,
  dbus,
  nfsSupport ? true,
  libnfs,
  pulseSupport ? true,
  libpulseaudio,
  pipewireSupport ? true,
  pipewire,
  rtmpSupport ? true,
  rtmpdump,
  sambaSupport ? true,
  samba,
  udevSupport ? true,
  udev,
  opticalSupport ? true,
  usbSupport ? false,
  libusb-compat-0_1,
  vdpauSupport ? true,
  libvdpau,
  gbmSupport ? false,
  libgbm,
  libinput,
  libdisplay-info,
  libxkbcommon,
  buildPackages,
}:

assert usbSupport -> !udevSupport; # libusb-compat-0_1 won't be used if udev is available
assert gbmSupport || x11Support;

let
  inherit (lib) optional optionals;

  kodi_platforms = optional gbmSupport "gbm" ++ optional x11Support "x11";

  libdvdcss = fetchFromGitHub {
    owner = "xbmc";
    repo = "libdvdcss";
    rev = "1.4.3-Next-Nexus-Alpha2-2";
    hash = "sha256-CJMGH50mNAkovccNcol5ArF3zUnZKfbVB9EXyQgu5k4=";
  };

  libdvdnav = fetchFromGitHub {
    owner = "xbmc";
    repo = "libdvdnav";
    rev = "6.1.1-Next-Nexus-Alpha2-2";
    hash = "sha256-m8SCjOokVbwJ7eVfYKHap1pQjVbI+BXaoxhGZQIg0+k=";
  };

  libdvdread = fetchFromGitHub {
    owner = "xbmc";
    repo = "libdvdread";
    rev = "6.1.3-Next-Nexus-Alpha2-2";
    hash = "sha256-AphBQhXud+a6wm52zjzC5biz53NnqWdgpL2QDt2ZuXc=";
  };

  groovy = fetchzip {
    url = "mirror://apache/groovy/4.0.16/distribution/apache-groovy-binary-4.0.16.zip";
    hash = "sha256-OfZBiMVrhw6VqHRHCSC7ZV3FiZ26n4+F8hsskk+L6yU=";
  };

  apache_commons_lang = fetchzip {
    url = "mirror://apache/commons/lang/binaries/commons-lang3-3.14.0-bin.zip";
    hash = "sha512-eKF1IQ6PDtifb4pMHWQ2SYHIh0HbMi3qpc92lfbOo3uSsFJVR3n7JD0AdzrG17tLJQA4z5PGDhwyYw0rLeLsXw==";
  };

  apache_commons_text = fetchzip {
    url = "mirror://apache/commons/text/binaries/commons-text-1.11.0-bin.zip";
    hash = "sha512-P2IvnrHSYRF70LllTMI8aev43h2oe8lq6rrMYw450PEhEa7OuuCjh1Krnc/A4OqENUcidVAAX5dK1RAsZHh8Dg==";
  };
in
stdenv.mkDerivation (
  finalAttrs:
  let
    texturePacker = buildPackages.callPackage (
      {
        cmake,
        giflib,
        libjpeg,
        libpng,
        lzo,
        stdenv,
        zlib,
        pkg-config,
      }:
      stdenv.mkDerivation {
        pname = finalAttrs.pname + "-build-tool-texture-packer";
        inherit (finalAttrs) version src;

        sourceRoot = "${finalAttrs.src.name}/tools/depends/native/TexturePacker/src";

        nativeBuildInputs = [
          pkg-config
          cmake
          cmake.configurePhaseHook
        ];

        buildInputs = [
          giflib
          libjpeg
          libpng
          lzo
          zlib
        ];

        env.NIX_CFLAGS_COMPILE = lib.optionalString (!stdenv.hostPlatform.isWindows) "-DTARGET_POSIX";

        preConfigure = ''
          cmakeFlagsArray+=(-DKODI_SOURCE_DIR=$src -DCMAKE_MODULE_PATH=$src/cmake/modules)
        '';

        meta.mainProgram = "TexturePacker";
      }
    ) { };

    jsonSchemaBuilder = buildPackages.callPackage (
      { stdenv, cmake }:
      stdenv.mkDerivation {
        pname = finalAttrs.pname + "-build-tool-json-schema-builder";
        inherit (finalAttrs) version src;

        sourceRoot = "${finalAttrs.src.name}/tools/depends/native/JsonSchemaBuilder/src";

        nativeBuildInputs = [
          cmake
          cmake.configurePhaseHook
        ];

        meta.mainProgram = "JsonSchemaBuilder";
      }
    ) { };
  in
  {
    pname = "kodi";
    version = "21.3";
    kodiReleaseName = "Omega";

    src = fetchFromGitHub {
      owner = "xbmc";
      repo = "xbmc";
      tag = "${finalAttrs.version}-${finalAttrs.kodiReleaseName}";
      hash = "sha256-36wBAqGEDCRZ4t1ygTg03Pyk7Gg9quUTUGD3SBp6nCk=";
    };

    patches = [
      # TexturePacker has some conditionals on GIFLIB 5, which break with
      # GIFLIB 6. This has been extended to support all versions >= 5 upstream,
      # but has not yet made it into a release.
      # https://github.com/xbmc/xbmc/pull/28016
      (fetchpatch {
        name = "texturepacker-giflib-6.patch";
        url = "https://github.com/xbmc/xbmc/commit/29492cbd20d4c90a9c00a30ab525d4d0e81a968b.patch";
        hash = "sha256-WNaODPCtRfn30jVU5HbBnAO2Vl/MQp2CYmKOTTyDGZI=";
      })
    ];

    nativeBuildInputs = [
      cmake
      cmake.configurePhaseHook
      doxygen
      makeWrapper
      which
      pkg-config
      autoconf
      automake
      libtool
      jre_headless
      yasm
      gettext
      python3
      flatbuffers
    ];

    buildInputs = [
      gnutls
      libidn.v2
      libtasn1
      nasm
      p11-kit
      libxml2
      python3
      boost
      libmicrohttpd
      gettext
      pcre-cpp
      yajl
      fribidi
      libva
      libdrm
      openssl
      gperf
      tinyxml
      tinyxml-2
      taglib
      libssh
      ncurses
      spdlog
      alsa-lib
      libGL
      libGLU
      fontconfig
      freetype
      ftgl
      libjpeg
      libpng
      libtiff
      libmpeg2
      libsamplerate
      libmad
      libogg
      libvorbis
      flac
      libxslt
      lzo
      libcdio
      libmodplug
      libass
      libbluray
      libudfread
      sqlite
      libmysqlclient
      avahi
      lame
      curl
      bzip2
      zip
      unzip
      mesa-demos
      libcec
      libcec_platform
      dcadec
      libuuid
      libxcrypt
      libgcrypt
      libgpg-error
      libunistring
      libplist
      bluez
      glib
      harfbuzz
      lcms2
      libpthread-stubs
      ffmpeg
      flatbuffers
      fstrcmp
      rapidjson
      lirc
      mesa-gl-headers
      giflib
      zlib
    ]
    ++ optionals x11Support [
      libx11
      xorgproto
      libxt
      libxmu
      libxext
      libxdmcp
      libxinerama
      libxrandr
      libxtst
      libxfixes
    ]
    ++ optional dbusSupport dbus
    ++ optional nfsSupport libnfs
    ++ optional pulseSupport libpulseaudio
    ++ optional pipewireSupport pipewire
    ++ optional rtmpSupport rtmpdump
    ++ optional sambaSupport samba
    ++ optional udevSupport udev
    ++ optional usbSupport libusb-compat-0_1
    ++ optional vdpauSupport libvdpau
    ++ optionals gbmSupport [
      libxkbcommon
      libgbm
      libinput
      libdisplay-info
    ];

    nativeCheckInputs = [
      gtest
    ];

    depsBuildBuild = [
      buildPackages.stdenv.cc
    ];

    strictDeps = true;

    cmakeEntries = {
      APP_RENDER_SYSTEM = if gbmSupport then "gles" else "gl";
      libdvdcss_URL = "${libdvdcss}";
      libdvdnav_URL = "${libdvdnav}";
      libdvdread_URL = "${libdvdread}";
      groovy_SOURCE_DIR = "${groovy}";
      "apache-commons-lang_SOURCE_DIR" = "${apache_commons_lang}";
      "apache-commons-text_SOURCE_DIR" = "${apache_commons_text}";
      GIT_VERSION = "${finalAttrs.version}-${finalAttrs.kodiReleaseName}";
      ENABLE_EVENTCLIENTS = true;
      ENABLE_INTERNAL_CROSSGUID = true;
      ENABLE_INTERNAL_RapidJSON = false;
      ENABLE_OPTICAL = opticalSupport;
      ENABLE_VDPAU = vdpauSupport;
      LIRC_DEVICE = "/run/lirc/lircd";
      SWIG_EXECUTABLE = "${buildPackages.swig}/bin/swig";
      FLATBUFFERS_FLATC_EXECUTABLE = "${buildPackages.flatbuffers}/bin/flatc";
      PYTHON_EXECUTABLE = "${buildPackages.python3}/bin/python";
      PYTHON_LIB_PATH = "${python3.sitePackages}";
      WITH_JSONSCHEMABUILDER = "${lib.getExe jsonSchemaBuilder}";
      KODI_WEBSERVER_EXTRA_WHITELIST = "${builtins.storeDir}";
      CORE_PLATFORM_NAME = lib.concatStringsSep " " kodi_platforms;
    }
    // lib.optionalAttrs (stdenv.hostPlatform != stdenv.buildPlatform) {
      WITH_TEXTUREPACKER = "${lib.getExe texturePacker}";
    };

    doInstallCheck = true;

    installCheckPhase = "$out/bin/kodi --version";

    postInstall = ''
      for p in $(ls --ignore=kodi-send $out/bin/) ; do
        wrapProgram $out/bin/$p \
          --prefix PATH ":" "${
            lib.makeBinPath (
              [
                python3
                mesa-demos
              ]
              ++ optional x11Support xdpyinfo
              ++ optional sambaSupport samba
            )
          }" \
          --prefix LD_LIBRARY_PATH ":" "${
            lib.makeLibraryPath (
              [
                curl
                libmad
                libcec
                libcec_platform
                libass
              ]
              ++ optional vdpauSupport libvdpau
              ++ optional nfsSupport libnfs
              ++ optional rtmpSupport rtmpdump
            )
          }"
      done

      wrapProgram $out/bin/kodi-send \
        --prefix PYTHONPATH : $out/${python3.sitePackages}

      substituteInPlace $out/share/xsessions/kodi.desktop \
        --replace kodi-standalone $out/bin/kodi-standalone
    '';

    passthru = {
      inherit python3 ffmpeg;
      kodi = finalAttrs.finalPackage;
    };

    meta = {
      description = "Media center";
      homepage = "https://kodi.tv/";
      license = lib.licenses.gpl2Plus;
      platforms = lib.platforms.linux;
      mainProgram = "kodi";
    };
  }
)
